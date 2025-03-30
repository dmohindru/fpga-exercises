cmake_minimum_required(VERSION 3.20)
project(counter_fpga)

# Set default board, can be overridden: -DBOARD=tangnano20k
set(BOARD "tangnano20k" CACHE STRING "Target FPGA board")

# Include common FPGA build logic
include(cmake/FPGA_Common.cmake)

# Load the appropriate toolchain based on BOARD
if (BOARD STREQUAL "tangnano20k")
    include(cmake/FPGA_TangNano20K.cmake)
elseif (BOARD STREQUAL "icebreaker")
    include(cmake/FPGA_IceBreaker.cmake)
elseif (BOARD STREQUAL "ecp5")
    include(cmake/FPGA_Lattice.cmake)
else()
    message(FATAL_ERROR "Unsupported FPGA board: ${BOARD}")
endif()
