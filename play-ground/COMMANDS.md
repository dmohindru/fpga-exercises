### Build commands

List of commands currently supported by cmake build script. Refer to [README.md](./README.md) to have more context about using each command in a project.

**1. Configure CMake project**

```sh
cmake -S . -B build -DFPGA_FAMILY=gowin -DBOARD=tangnano20k -DPROJECT_NAME=my_project
```

or if you which to have a different constraints file from that of `PROJECT_NAME`

```sh
cmake -S . -B build -DFPGA_FAMILY=gowin -DBOARD=tangnano20k -DPROJECT_NAME=my_project -DCONSTRAINT_FILE=constraint_file_name
```

> Breakdown:
>
> - `-B build` → Specifies the build directory (build/).
> - `-DFPGA_FAMILY=gowin` → Defines the FPGA family.
> - `-DBOARD=tangnano20k` → Selects the FPGA board.
> - `-DPROJECT_NAME=my_project` → Defines the top-level Verilog module.
> - `-DCONSTRAINT_FILE=constraint_file_name` -> Define the name of constraints file that build script will look for

**2. Run the Synthesis Step**

```sh
cmake --build build --target synthesize
```

> Breakdown:
>
> - `--build build` → Runs the build process inside the build/ directory.
> - `--target synthesize` → Calls the synthesis target, which:
>   - Uses Yosys to process Verilog files.
>   - Outputs a JSON representation of the netlist.

**3. Run the Place & Route (PnR)**

```sh
cmake --build build --target pnr
```

> Breakdown:
>
> - `--target pnr` → Calls the place-and-route target, which:
>   - Uses nextpnr-himbaechel to:
>     - Read the JSON netlist.
>     - Assign FPGA logic blocks and routing.
>     - Write the routed JSON file.
>   - Applies constraints (.cst file).
>   - Uses the correct FPGA device and family.

**4. Generate the Bitstream**

```sh
cmake --build build --target bitstream
```

> Breakdown:
>
> - `--target bitstream` → Calls the bitstream target, which:
> - Uses gowin_pack to:
>   - Convert routed JSON into a .fs bitstream file.
>   - Pack it for the target FPGA.

**5. Upload Bitstream to FPGA**

(a) Upload to SRAM (Volatile, erased on power off)

```sh
cmake --build build --target upload_sram
```

> Breakdown:
>
> - `--target upload_sram` → Calls the SRAM upload target, which:
>   - Uses openFPGALoader to temporarily load the bitstream into FPGA.

(b) Upload to Flash (Non-Volatile)

```sh
cmake --build build --target upload_flash
```

> Breakdown:
>
> - `--target upload_flash` → Calls the Flash upload target, which:
>   - Uses openFPGALoader to permanently flash the bitstream onto the FPGA.

**6. Clean Build Directory**

```sh
cmake --build build --target clean
```

> Breakdown:
>
> - `cmake --build build`: This tells CMake to use the build directory.
> - `--target clean`: This executes the clean target, which removes all generated files.
