### Tang Nano 20K Wiki

This wiki cover [tangnano20K](https://wiki.sipeed.com/hardware/en/tang/tang-nano-20k/nano-20k.html) setting up toolchain and development workflow know how.

Basic steps to setup development for tang nano 20k

1. Setup VS code plugins for fpga development. Follow Lushay Labs tang nano 9K tutorial.
2. Download latest [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build) toolchain and setup in $HOME/opt/eda directory.
3. Install [openFPGALoader](https://github.com/trabucayre/openFPGALoader) either through ubuntu package manager apt, snap or by compiling from source.
4. Set user permission to use openFPGALoader as normal user.
5. Set **oss-cad-suite** toolchain path in Lushay vscode plugin installed in step 1.
6. Lushay vscode plugin by default targets tangnano9K board. This plugin can be easily adapted to tangnano20K by adding file `projectName.lushay.json` with following content to root of your project

```json
{
  "board": "tangnano20k"
}
```

5. Initially received tangnano20K board's onboard programmer firmware would not flash the chips SRAM or external flash. So the debugger's firmware need to be updated, follow this [link](https://wiki.sipeed.com/hardware/en/tang/common-doc/update_debugger.html) for more instruction.

### Links

- [Lushay Labs tang nano 9K](https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/): This tutorial help to setup a completely open source tool chain for tang nano 9k and can be adapted very easily for tang nano 20k
