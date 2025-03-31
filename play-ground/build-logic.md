### Build logic for verilog to bitstream

### Logic for root cmake file

- Check if env variable OSS_CAD_HOME exists, fail build if not with descriptive message of "OSS_CAD_HOME" env variable must be set
- Check if BOARD project variable set
  - Fail build if not with descriptive message of "BOARD project variable must be set"
  - If present ensure BOARD value is from allowed board list ("tangnano20k", "tangnano9k", "tangnano4k", "tangnano1k"). If not fail with descriptive message of "Allowed board names $BOARD_NAMES". This list will grow eventually. Should allow on command line with -DBOARD.
- Check if FPGA_FAMILY project variable set
  - Fail build if not with descriptive message of "FPGA_FAMILY project variable must be set"
  - If present ensure FPGA_FAMILY value is from allowed board list ("gowin" "ice40"). If not fail with descriptive message of "Allowed FPGA family $FPGA_FAMILIES". This list will grow eventually. Should allow on command line with -DFPGA_FAMILY
- Check if PROJECT_NAME project variable set. This PROJECT_NAME will be ensure verilog file containing top module is by name PROJECT_NAME.v and should contain top module also named as PROJECT_NAME which would be passed to yosys synthesis command. If not present fail with descriptive message of "PROJECT_NAME must be set". Should allow on command line with -DPROJECT_NAME
- Check if top verilog file is present in src/main/verilog/PROJECT_NAME.v . Other wise fail with descriptive message "PROJECT_NAME.v top module verilog file not found"
- Create a directory in build folder by name of BOARD like build/tangnano20 or build/tangnano9k etc.
- Prepare absolute path of all the verilog files sitting in src/main/verilog. Files can be organised in multiple and hierarchal folder structure to be passes to yosys with read_verilog command.
- Create a script file in build/BOARD folder as BOARD_synth.ys(which would help in debugging) and add read_verilog command for each file discovered in previous set like
  - read_verilog -sv ABSOLUTE_PATH_OF_FIRST_VERILOG_FILE
  - read_verilog -sv ABSOLUTE_PATH_OF_SECOND_VERILOG_FILE
  - read_verilog -sv ABSOLUTE_PATH_OF_THIRD_VERILOG_FILE
  - so on ....
- Accord to the value of FPGA_FAMILY conditionally include child cmake files as
  - gowin: cmake/FPGA_gowin.cmake
  - ice40: cmake/FPGA_ice40.cmake
  - so on...

### Logic for cmake per FPGA family e.g. FPGA_gowin

- Append command to BOARD_synth.ys script file created earlier with
  synth_gowin -top $PROJECT_NAME -json build/BOARD/PROJECT_NAME.json
- Add custom target "synthesize" for synthesis with yosys with necessary commands like
  $OSS_CAD_HOME/yosys -s build/BOARD/BOARD_synth.ys
- Create a map BOARD_DEVICE_NAME between board name and its device name like

  - tangnano20k : GW2AR-LV18QN88C8/I7
  - tangnano9k : -- find name from appropriate source --
  - tangnano4k : -- find name from appropriate source --
  - tangnano1k : -- find name from appropriate source --

- Create a map BOARD_FAMILY_NAME between board name and its family like

  - tangnano20k: GW2A-18C
  - tangnano9k: -- find name from appropriate source --
  - tangnano4k : -- find name from appropriate source --
  - tangnano1k : -- find name from appropriate source --

- Check if project's constraint file is present in directory board/${BOARD}/${PROJECT_NAME}.cst. If not fail with descriptive message of "board/${BOARD}/${PROJECT_NAME}.cst must be present for place and route stage"
- Add custom target "pnr" for place and route with command
  $OSS_CAD_HOME/nextpnr-himbaechel --json build/BOARD/PROJECT_NAME.json --write build/${BOARD}/${PROJECT_NAME}_routed.json --device BOARD_DEVICE_NAME[$BOARD] --vopt cst=board/${BOARD}/${PROJECT_NAME}.cst --vopt family=BOARD_FAMILY_NAME[$BOARD] --vopt freq=27 --report build/${BOARD}/${PROJECT_NAME}\_usage.json

- Add custom target "bitstream" for bitstream generation with command
  $OSS_CAD_HOME/gowin_pack -d BOARD_FAMILY_NAME[$BOARD] -o build/${BOARD}/${PROJECT_NAME}.fs build/${BOARD}/${PROJECT_NAME}\_routed.json

- Add custom target "upload_flash" with command
  openFPGALoader -b $BOARD_NAME -f build/${BOARD}/${PROJECT_NAME}.fs

- Add custom target "upload_sram" with command
  openFPGALoader -b $BOARD_NAME build/${BOARD}/${PROJECT_NAME}.fs

### Currently no commands for testing

- will add them later after bit of research
