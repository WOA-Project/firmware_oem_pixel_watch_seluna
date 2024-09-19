# Seluna Firmware

This repository holds the latest Firmware for Seluna devices alongside the scripts and tools used to generate the output folder, designed to be used for Windows.

## Script

- Extract product.img into extracted\product
- Extract vendor.img into extracted\vendor
- Extract system_ext.img into extracted\system_ext
- Extract modem.img into extracted\modem
- Copy abl.img into extracted
- Copy imagefv.img into extracted
- Copy keymaster.img into extracted
- Copy qupfw.img into extracted
- Copy uefisecapp.img into extracted
- Copy xbl.img into extracted
- Run build.cmd

```
  _______        __  _____      _                  _
 |  ___\ \      / / | ____|_  _| |_ _ __ __ _  ___| |_ ___  _ __
 | |_   \ \ /\ / /  |  _| \ \/ / __| '__/ _` |/ __| __/ _ \| '__|
 |  _|   \ V  V /   | |___ >  <| |_| | | (_| | (__| || (_) | |
 |_|      \_/\_/    |_____/_/\_\\__|_|  \__,_|\___|\__\___/|_|


Target: Seluna
SoC   : SW5100
RKH   : 48F631ADEDF676192E79633EBA0F17983DE5B3CDE2F0A36180DA6E5830719867 (Pixel Firmware Origin Attestation CA)
```