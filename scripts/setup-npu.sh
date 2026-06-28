#!/bin/bash
# Z13 Linux NPU Setup — one-shot script
# Run on Ubuntu 24.04 with kernel >= 6.10

set -e

echo "=== Z13 NPU Setup ==="
echo ""

KERNEL=$(uname -r)
echo "Kernel: $KERNEL"
if [[ "$KERNEL" < "6.10" ]]; then
    echo "⚠️  Kernel too old. Need >= 6.10 for amdxdna driver."
    exit 1
fi

echo ""
echo "--- Loading amdxdna kernel driver ---"
if lsmod | grep -q amdxdna; then
    echo "✅ amdxdna already loaded"
else
    sudo modprobe amdxdna
    echo "✅ amdxdna loaded"
fi

echo 'amdxdna' | sudo tee /etc/modules-load.d/amdxdna.conf > /dev/null

if [ -e /dev/accel/accel0 ]; then
    echo "✅ NPU detected: /dev/accel/accel0"
else
    echo "❌ No NPU — check BIOS: Advanced → AMD CBS → NPU"
fi

echo ""
echo "--- Installing Python 3.12 + deps ---"
sudo apt update -qq
sudo apt install -y python3.12 python3.12-venv libboost-filesystem1.74.0
echo "✅ Done"

echo ""
echo "--- XRT Userspace ---"
echo "⚠️  Download XRT .debs from AMD (requires compliance form):"
echo "   https://www.amd.com/en/developer/resources/ryzen-ai-software.html"
echo "   → Ryzen AI Software Drivers → Linux"
echo "   Then: unzip && sudo apt install ./*.deb"
echo ""

if python3.12 -c "import pyxrt" 2>/dev/null; then
    echo "✅ pyxrt importable"
elif [ -f /opt/xilinx/xrt/python/pyxrt*.so ]; then
    echo "✅ XRT files found. Adding to PYTHONPATH..."
    grep -q '/opt/xilinx/xrt/python' ~/.bashrc 2>/dev/null || \
        echo 'export PYTHONPATH=/opt/xilinx/xrt/python:$PYTHONPATH' >> ~/.bashrc
    export PYTHONPATH=/opt/xilinx/xrt/python:$PYTHONPATH
    python3.12 -c "import pyxrt; print('✅ pyxrt OK')"
else
    echo "⚠️  XRT not installed yet."
fi

echo ""
echo "=== Done ==="
echo "Next: https://ryzenai.docs.amd.com/en/latest/linux.html"
