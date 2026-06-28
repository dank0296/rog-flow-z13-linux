# NPU — AMD XDNA 2 on Linux

Getting the Strix Halo NPU working on Ubuntu 24.04. Spoiler: AMD makes you fill out a compliance form just to download the drivers.

## Hardware

- **Chip:** AMD XDNA 2 (integrated in Ryzen AI MAX+ 395)
- **PCIe ID:** `1002:17f0`
- **TOPS:** 50 (INT8)
- **Precision:** INT8, limited BF16
- **Max model size:** ~7-8B (INT8 quantized)

## Kernel driver

The `amdxdna` driver is in-tree since kernel 6.14. On Ubuntu 24.04 with the oem kernel:

```bash
# Check if the module exists
find /lib/modules/$(uname -r) -name 'amdxdna*'

# Load it (should auto-load on boot with 6.17+)
sudo modprobe amdxdna

# Make it permanent
echo 'amdxdna' | sudo tee /etc/modules-load.d/amdxdna.conf

# Verify
ls /dev/accel/accel0
lspci | grep 17f0
```

## Userspace (XRT)

AMD ships the NPU runtime as part of the **Ryzen AI Software** package. As of Ryzen AI 1.7.1, Linux is supported for Strix (STX) platforms.

### Prerequisites

```bash
# Ubuntu 24.04, kernel ≥ 6.10
sudo apt install python3.12 python3.12-venv libboost-filesystem1.74.0
```

### Install XRT

1. Go to [AMD Ryzen AI Software](https://www.amd.com/en/developer/resources/ryzen-ai-software.html)
2. Fill out their compliance form (yes, really — for a driver download)
3. Download **Ryzen AI Software Drivers → Linux** (ZIP with `.deb` packages)
4. Install:

```bash
cd ~/Downloads
unzip RAI_*_Linux_NPU_XRT.zip -d rai_xrt
cd rai_xrt
sudo apt install --fix-broken -y ./*.deb
```

5. Add Python bindings to your path:

```bash
echo 'export PYTHONPATH=/opt/xilinx/xrt/python:$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc
```

6. Verify:

```bash
python3.12 -c "import pyxrt; print('pyxrt loaded OK')"
```

## What the NPU is good for

| Task | NPU | iGPU |
|---|---|---|
| Whisper (speech-to-text) | ✅ Optimized | Overkill |
| ONNX classifiers (INT8) | ✅ Perfect | Wastes power |
| Real-time translation | ✅ Always-on | Battery drain |
| LLM inference (7B+) | ❌ Too small | ✅ 30B+ fits |
| Stable Diffusion | ❌ Not designed for it | ✅ ROCm works |
| Background AI tasks | ✅ Efficient | 🔋 Hungry |

**Bottom line:** NPU is a sidekick, not a replacement. Use it for lightweight, always-on inference. Keep big models on the iGPU.

## References

- [Ryzen AI Linux Docs](https://ryzenai.docs.amd.com/en/latest/linux.html)
- [ROCm on Radeon/Ryzen](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/)