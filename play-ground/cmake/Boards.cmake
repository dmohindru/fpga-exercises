# cmake/Boards.cmake

# Define a mapping of board names to their device names
set(BOARD_DEVICE_NAME)
set(BOARD_DEVICE_NAME_tangnano20k "GW2AR-LV18QN88C8/I7")
set(BOARD_DEVICE_NAME_tangnano9k "GW1NR-LV9QN88PC6/I5")  # Example, verify actual name
set(BOARD_DEVICE_NAME_tangnano4k "GW1NSR-LV4CQN48PC7/I6")  # Example, verify actual name
set(BOARD_DEVICE_NAME_tangnano1k "GW1NZ-LV1QN48C6/I5")  # Example, verify actual name

# Define a mapping of board names to their FPGA family names
set(BOARD_FAMILY_NAME)
set(BOARD_FAMILY_NAME_tangnano20k "GW2A-18C")
set(BOARD_FAMILY_NAME_tangnano9k "GW1NR-9C")  # Example, verify actual name
set(BOARD_FAMILY_NAME_tangnano4k "GW1NSR-4C")  # Example, verify actual name
set(BOARD_FAMILY_NAME_tangnano1k "GW1NZ-1C")  # Example, verify actual name

# Function to get board properties
function(get_board_properties board out_device out_family)
    if(DEFINED BOARD_DEVICE_NAME_${board} AND DEFINED BOARD_FAMILY_NAME_${board})
        set(${out_device} ${BOARD_DEVICE_NAME_${board}} PARENT_SCOPE)
        set(${out_family} ${BOARD_FAMILY_NAME_${board}} PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Unsupported board: ${board}")
    endif()
endfunction()
