# cmake/Utils.cmake

# Function to validate FPGA family
function(validate_fpga_family family)
    set(ALLOWED_FAMILIES "gowin" "ice40")
    list(FIND ALLOWED_FAMILIES "${family}" index)
    if(index EQUAL -1)
        message(FATAL_ERROR "Invalid FPGA_FAMILY: ${family}. Allowed values: gowin, ice40")
    endif()
endfunction()

# Function to validate board name
function(validate_board board)
    set(ALLOWED_BOARDS "tangnano20k" "tangnano9k" "tangnano4k" "tangnano1k")
    list(FIND ALLOWED_BOARDS "${board}" index)
    if(index EQUAL -1)
        message(FATAL_ERROR "Invalid BOARD: ${board}. Allowed values: ${ALLOWED_BOARDS}")
    endif()
endfunction()

# Function to set up the build directory
function(setup_build_directory board)
    set(BUILD_DIR ${CMAKE_BINARY_DIR}/${board} PARENT_SCOPE)
    file(MAKE_DIRECTORY ${BUILD_DIR})
endfunction()

# Function to collect all Verilog files
function(collect_verilog_sources)
    file(GLOB_RECURSE VERILOG_FILES "${CMAKE_SOURCE_DIR}/src/main/verilog/*.v")
    if(NOT VERILOG_FILES)
        message(FATAL_ERROR "No Verilog files found in src/main/verilog/")
    endif()
    set(VERILOG_FILES ${VERILOG_FILES} PARENT_SCOPE)
endfunction()
