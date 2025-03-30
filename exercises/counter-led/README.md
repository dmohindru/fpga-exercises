### Counter led

### Build system objects

1. Have a separate folder for verilog source, and constraint files.
2. Have a folder structure similar to java maven project for src and test bench
3. Use CMake build system
4. Build in separate build directory
5. ** Good to have a vscode ide plugin to execute each test bench individually **

### Commands to convert verilog and cst file to bitstream

Verilog file counter.v
Constraints file counter.cst

1. Create a build directory

```shell
mkdir -p build
```

2. Synthesis (Using yosys)

```shell
yosys -p "read_verilog counter.v; synth_gowin -top counter -json build/counter.json"
```

3. Place and Route (Using NextPNR)

```shell
nextpnr-gowin --json build/counter.json --write build/counter_routed.json --cst counter.cst --device GW2A-18C --family GW2AR --freq 27
```

4. Bitstream Generation (Using Gowin Pack)

```shell
gowin_pack -d GW2A-18C -o build/counter.fs build/counter_routed.json

```

5. Flash to Tang Nano 20K (Using OpenFPGALoader)

```shell
openFPGALoader -b tangnano20k -f build/counter.fs

```
