cmake_minimum_required(VERSION 3.16)
project(FPGA_BuildSystem)

# Load utility functions
include(cmake/Utils.cmake)
include(cmake/Boards.cmake)

# Set default values
set(FPGA_FAMILY "" CACHE STRING "FPGA family: gowin or ice40 (must be set)")
set(BOARD "" CACHE STRING "Target FPGA board (must be set)")
set(PROJECT_NAME "" CACHE STRING "Verilog top module name (must be set)")

# Ensure mandatory variables are set
if(NOT FPGA_FAMILY)
    message(FATAL_ERROR "FPGA_FAMILY must be explicitly set (e.g., -DFPGA_FAMILY=gowin)")
endif()

if(NOT BOARD)
    message(FATAL_ERROR "BOARD must be explicitly set (e.g., -DBOARD=tangnano20k)")
endif()

if(NOT PROJECT_NAME)
    message(FATAL_ERROR "PROJECT_NAME must be explicitly set (e.g., -DPROJECT_NAME=my_project)")
endif()

# Validate board and FPGA family
validate_board(${BOARD})
validate_fpga_family(${FPGA_FAMILY})

# Create build directory
set(BUILD_DIR ${CMAKE_BINARY_DIR}/${BOARD})
file(MAKE_DIRECTORY ${BUILD_DIR})

# Collect Verilog sources
file(GLOB_RECURSE VERILOG_FILES "${CMAKE_SOURCE_DIR}/src/main/verilog/*.v")
if(NOT VERILOG_FILES)
    message(FATAL_ERROR "No Verilog files found in src/main/verilog/")
endif()

# Load FPGA-specific build logic
if(FPGA_FAMILY STREQUAL "gowin")
    include(cmake/FPGA_gowin.cmake)
elif(FPGA_FAMILY STREQUAL "ice40")
    include(cmake/FPGA_ice40.cmake)
else()
    message(FATAL_ERROR "Unsupported FPGA family: ${FPGA_FAMILY}")
endif()