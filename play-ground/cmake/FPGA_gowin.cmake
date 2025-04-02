# FPGA family-specific build logic for Gowin

# Get board-specific properties
get_board_properties(${BOARD} DEVICE_NAME FAMILY_NAME)

# Define build paths
set(SYNTH_SCRIPT "${BUILD_DIR}/${BOARD}_synth.ys")
set(JSON_FILE "${BUILD_DIR}/${PROJECT_NAME}.json")
set(ROUTED_JSON_FILE "${BUILD_DIR}/${PROJECT_NAME}_routed.json")
set(BITSTREAM_FILE "${BUILD_DIR}/${PROJECT_NAME}.fs")
set(USAGE_REPORT "${BUILD_DIR}/${PROJECT_NAME}_usage.json")

# Detect constraints file
if(DEFINED CONSTRAINT_FILE AND NOT "${CONSTRAINT_FILE}" STREQUAL "")
    set(CST_FILE_PATH "${CMAKE_SOURCE_DIR}/board/${BOARD}/${CONSTRAINT_FILE}.cst")
else()
    set(CST_FILE_PATH "${CMAKE_SOURCE_DIR}/board/${BOARD}/${PROJECT_NAME}.cst")
endif()


if(NOT EXISTS ${CST_FILE_PATH})
    message(FATAL_ERROR "Constraints file not found: ${CST_FILE_PATH}")
endif()

# Clock frequency detection
if(NOT DEFINED FREQ)
    set(FREQ 27) # Default to 27 MHz
endif()

# Generate synthesis script
file(WRITE ${SYNTH_SCRIPT} "")
foreach(VERILOG_FILE ${VERILOG_FILES})
    file(APPEND ${SYNTH_SCRIPT} "read_verilog -sv ${VERILOG_FILE}\n")
endforeach()
file(APPEND ${SYNTH_SCRIPT} "synth_gowin -top ${PROJECT_NAME} -json ${JSON_FILE}\n")

# Add synthesis target
# Synthesis: Generates JSON file
add_custom_command(
    OUTPUT ${JSON_FILE}
    COMMAND $ENV{OSS_CAD_HOME}/yosys -s ${SYNTH_SCRIPT}
    DEPENDS ${VERILOG_FILES} ${SYNTH_SCRIPT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running Yosys synthesis for Gowin FPGA"
)

add_custom_target(synthesize DEPENDS ${JSON_FILE})

# PNR: Generates Routed JSON file
add_custom_command(
    OUTPUT ${ROUTED_JSON_FILE} ${USAGE_REPORT}
    COMMAND $ENV{OSS_CAD_HOME}/nextpnr-himbaechel 
        --json ${JSON_FILE} 
        --write ${ROUTED_JSON_FILE} 
        --device ${DEVICE_NAME} 
        --vopt cst=${CST_FILE_PATH} 
        --vopt family=${FAMILY_NAME} 
        --vopt freq=${FREQ} 
        --report ${USAGE_REPORT}
    DEPENDS ${JSON_FILE}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running nextpnr for Gowin FPGA"
)

add_custom_target(pnr DEPENDS ${ROUTED_JSON_FILE})

# Bitstream Generation: Outputs Bitstream file
add_custom_command(
    OUTPUT ${BITSTREAM_FILE}
    COMMAND $ENV{OSS_CAD_HOME}/gowin_pack -d ${FAMILY_NAME} -o ${BITSTREAM_FILE} ${ROUTED_JSON_FILE}
    DEPENDS ${ROUTED_JSON_FILE}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating bitstream for Gowin FPGA"
)

add_custom_target(bitstream DEPENDS ${BITSTREAM_FILE})

# Include upload targets
include(cmake/FPGA_upload.cmake)
