# ROG Flow Z13 (2025) — Linux Setup Guide

[![Model](https://img.shields.io/badge/model-GZ302EA-blue)](#)
[![Kernel](https://img.shields.io/badge/kernel-6.17--oem-green)](#)
[![Ubuntu](https://img.shields.io/badge/ubuntu-24.04%20LTS-orange)](#)
[![NPU](https://img.shields.io/badge/NPU-XDNA%202-9cf)](#)

Everything you need to get the ASUS ROG Flow Z13 (2025, Strix Halo) running properly on Linux — kernel quirks, NPU drivers, iGPU compute, eGPU setup, and peripheral fixes.

**Hardware:** AMD Ryzen AI MAX+ 395 | Radeon 8060S (RDNA 3.5, 40 CU) | XDNA 2 NPU (50 TOPS) | 64GB unified memory

## What's covered

| Doc | What |
|---|---|
| [docs/PERIPHERALS.md](docs/PERIPHERALS.md) | RGB keyboard (asusctl), suspend fix, WiFi |
| [docs/NPU.md](docs/NPU.md) | XDNA 2 NPU driver, XRT install, AMD compliance wall |
| [docs/GPU-ROCM.md](docs/GPU-ROCM.md) | iGPU compute, Ollama, ROCm on Strix Halo |
| [docs/EGPU.md](docs/EGPU.md) | XG Mobile, supergfxctl, open-source XG_Mobile_Station |

## Quick start

```bash
# Install ASUS Linux tools (keyboard RGB, fan control)
echo "deb [arch=amd64] https://repo.asus-linux.org/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/asus.list
wget -qO - https://repo.asus-linux.org/asus.gpg | sudo apt-key add -
sudo apt update && sudo apt install asusctl

# Enable NPU
sudo modprobe amdxdna
echo 'amdxdna' | sudo tee /etc/modules-load.d/amdxdna.conf
```

## Hardware at a glance

```
AMD Ryzen AI MAX+ 395 (Strix Halo) — 16 Zen 5 cores, 32 threads
Radeon 8060S iGPU — RDNA 3.5, 40 CUs, ~12-16 TFLOPS FP16
XDNA 2 NPU — 50 TOPS INT8, dedicated AI accelerator
64GB LPDDR5X — unified memory (shared CPU/GPU/NPU)
1TB NVMe SSD
MediaTek MT7925 WiFi 7
XG Mobile eGPU port (GC34 compatible)
```

## Support this project

If this guide saved you hours of debugging, optional support is appreciated.

- Bitcoin (BTC): `bc1q3v2a2l7pgc764fk2wfdcmyddxsepm95z47fgkt`
- Ethereum (ETH): `0xEe8Cf82fBf92DF477792e7b065F73DcD1D2F9Ca5`
- Solana (SOL): `FgK8FktQfTTf32sdiizq9xaSZebSDXzLCHDTZ7Ej63J6`
- Tron (TRX): `TJz5GALB7UiNUhUqNvXFHLsvuj74yYmNsy`
