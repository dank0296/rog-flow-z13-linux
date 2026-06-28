# eGPU — XG Mobile & Open-Source Dock

The Z13 has ASUS's proprietary XG Mobile connector (GC34 compatible). Here are your options.

## Official XG Mobile (GC34)

- NVIDIA RTX 5070/5080 (locked to ASUS)
- Plug and play on Windows via Armoury Crate
- On Linux: use `supergfxctl` for switching
- **ROCm?** ❌ — NVIDIA GPU means CUDA only

## Open-Source: XG_Mobile_Station

[osy/XG_Mobile_Station](https://github.com/osy/XG_Mobile_Station) — ⭐684 stars, actively maintained open-source PCB that replaces the proprietary XG Mobile dock.

### What it is

| Variant | Description |
|---|---|
| **Standard** | Drop-in PCB for XG Station Pro enclosure, built-in 300W PSU + USB hub + 65W PD |
| **Lite** | Standalone board, external ATX PSU, USB passthrough |

### Key specs

- PCIe 4.0 x8 (2021-2023 Flow), PCIe 4.0 x4 (Ally)
- Accepts **any PCIe card** — AMD, NVIDIA, whatever
- STM32 MCU for cable detection + LEDs
- Requires: PCB fab (JLCPCB/PCBWay) + soldering + firmware flash

### AMD ROCm eGPU options

Since you're not locked to NVIDIA, grab an AMD card for native ROCm:

| GPU | Architecture | ROCm Target | Compute |
|---|---|---|---|
| RX 7900 XT/XTX | RDNA 3 | gfx1100 | ✅ Full support |
| RX 7800 XT | RDNA 3 | gfx1101 | ✅ Full support |
| RX 6800/6900 XT | RDNA 2 | gfx1030 | ✅ Full support |
| RX 9070 XT | RDNA 4 | gfx1201 | 🔄 Maturing |

### ⚠️ GZ302EA compatibility note

The XG_Mobile_Station is designed for 2021-2023 Flow models. The 2025 Z13 (GZ302EA) uses the same physical connector but PCIe lane allocation may differ. **Open an issue** on the repo before ordering PCBs to confirm.

## supergfxctl — GPU Switching on Linux

```bash
git clone https://gitlab.com/asus-linux/supergfxctl.git
cd supergfxctl
make && sudo make install
sudo systemctl enable supergfxd.service --now

# Switch to eGPU when connected
supergfxctl --mode AsusEgpu

# Back to integrated
supergfxctl --mode Integrated
```