# Upload targets (Shared across FPGA families)
add_custom_target(upload_flash
    COMMAND openFPGALoader -b ${BOARD} -f ${BITSTREAM_FILE}
    DEPENDS bitstream
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Uploading bitstream to FPGA (Flash mode)"
)

add_custom_target(upload_sram
    COMMAND openFPGALoader -b ${BOARD} ${BITSTREAM_FILE}
    DEPENDS bitstream
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Uploading bitstream to FPGA (SRAM mode)"
)