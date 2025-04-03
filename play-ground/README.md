### Play Ground

This folder will serve as a practice playground to come up with folder structure and CMake build script to automate FPGA workflow from common verilog source to multiple FPGA boards.

### Points to explore

- assertion for test bench
- use of library in fpga project
- how are verilog modules resolution works
- constraints file component IO, IOPORT etc
- what is tangnano20K sdc file (gowin projects)

### How to use this build system

This [cmake](https://cmake.org/) build script is a modest attempt to automate fpga development workflow in ide and platform agnostics way. Under the hood it utilizes [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) for synthesis, pnr (place and route) and bit stream generation. And utilized [open fpga loader](https://github.com/trabucayre/openFPGALoader) to program an actual fpga device.

This build script will be able to support fpga device that are supported by oss-cad-suite. An attempt has been made have a folder structure inspired by the java maven or gradle project structure. Folder structure has been chosen so that

- HDL source code goes in single hierarchal folder structure
- Tests goes in folder structure of their own
- Board constraints file goes in a folder structure of their own
- Build artifacts goes into their own folder structure

**HDL source code folder structure**
This folder will serve the purpose of holding platform agnostics Verilog and VHDL source code(currently only verilog is supported). Folder structure is

- src/main/verilog (for verilog source)
- src/main/vhdl (for VHDL source)

**Test bench code folder structure**
This folder will serve the purpose of holding all the test bench source code so that main source code folder don't get cluttered with test code. Folder structure is

- src/test/verilog (for verilog test bench)
- src/test/vhdl (for VHDL test bench)

**Constrains file folder structure**
This folder will serve the purpose of holding platform specific constraints file. So essentially a same design can be synthesis, pnr, bit stream and program to different devices. `And the the very code idea behind this build system`. Folder structure is

- board/board-name-1/board-specific-constraint-file
- board/board-name-2/board-specific-constraint-file
- board/board-name-3/board-specific-constraint-file

**Build folder structure**
This build folder structure will be managed by cmake build system. I would have all the necessary file created by cmake (not cover in this wiki). However some folders and file are important for debugging process. `build` folder will contain single folder by a board name (can be many but by different board name) and will contain following files example file are for tangnano20k

- build/tangnano20k/tangnano20k_synth.ys --> yosys script file for synthesis input
- build/tangnano20k/project_name.json --> output of synthesis stage and serving as input to pnr stage
- build/tangnano20k/project_name_routed.json --> output of pnr stage and serving as input to bit stream stage
- build/tangnano20k/project_name_usage.json --> usage report for fpga device
- build/tangnano20k/project_name_usage.html --> html version of fpga device usage (to be developed)
- build/tangnano20k/project_name.fs --> bit stream file output of bit stream stage and serving as input for openFPGALoader for programming a device
