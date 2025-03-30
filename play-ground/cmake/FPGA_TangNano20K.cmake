# Paths
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src/main/verilog")
set(TEST_DIR "${CMAKE_SOURCE_DIR}/src/test/verilog")
set(CONSTRAINTS_FILE "${CMAKE_SOURCE_DIR}/constraints/tangnano20k/counter.cst")

# Open-Source Toolchain Paths
set(YOSYS "/usr/bin/yosys")
set(NEXTPNR_GOWIN "/usr/bin/nextpnr-gowin")
set(GOWIN_PACK "/usr/bin/gowin_pack")
set(OPENFPGALOADER "/usr/bin/openFPGALoader")

# Build targets
add_custom_target(synthesize
    COMMAND ${YOSYS} -p "synth_gowin -top top -json counter.json" ${SRC_DIR}/counter.v
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running Yosys synthesis"
)

add_custom_target(pnr
    COMMAND ${NEXTPNR_GOWIN} --json counter.json --cst ${CONSTRAINTS_FILE} --device GW2AR-18C --write counter_routed.json
    DEPENDS synthesize
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running NextPNR for place & route"
)

add_custom_target(bitstream
    COMMAND ${GOWIN_PACK} counter_routed.json counter.fs
    DEPENDS pnr
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating bitstream"
)

# Upload targets
add_custom_target(upload_sram
    COMMAND ${OPENFPGALOADER} -b tangnano20k counter.fs
    DEPENDS bitstream
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Uploading bitstream to SRAM"
)

add_custom_target(upload_flash
    COMMAND ${OPENFPGALOADER} -b tangnano20k -f counter.fs
    DEPENDS bitstream
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Flashing bitstream to onboard storage"
)

# Simulation
add_custom_target(test
    COMMAND iverilog -o counter_tb ${TEST_DIR}/counter_tb.v ${SRC_DIR}/counter.v
    COMMAND vvp counter_tb
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running testbench"
)

# Installation: default upload to SRAM
add_custom_target(install DEPENDS upload_sram)
