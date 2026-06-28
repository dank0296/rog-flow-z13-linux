#!/bin/bash
# Z13 Audio + Camera Fix — one-shot
# Run on Ubuntu 24.04, reboot after

set -e

echo "=== Z13 Audio + Camera Fix ==="
echo ""

# --- Audio: CS35L41 amp ---
echo "--- Audio: Configuring CS35L41 amplifier ---"
if [ -f /etc/modprobe.d/cs35l41.conf ]; then
    echo "✅ CS35L41 config already present"
else
    echo 'softdep snd_hda_intel post: cs35l41_hda' | sudo tee /etc/modprobe.d/cs35l41.conf
    echo "✅ CS35L41 config written"
fi

# --- Camera: UVC quirks ---
echo ""
echo "--- Camera: Applying UVC driver fixes ---"
if [ -f /etc/modprobe.d/uvcvideo-gz302.conf ]; then
    echo "✅ UVC quirks already present"
else
    sudo tee /etc/modprobe.d/uvcvideo-gz302.conf << 'EOF'
options uvcvideo quirks=0x80
options uvcvideo nodrop=1
EOF
    echo "✅ UVC quirks written"
fi

# --- Camera: udev permissions ---
if [ -f /etc/udev/rules.d/99-gz302-camera.rules ]; then
    echo "✅ Camera udev rules already present"
else
    sudo tee /etc/udev/rules.d/99-gz302-camera.rules << 'EOF'
SUBSYSTEM=="video4linux", GROUP="video", MODE="0664"
KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", GROUP="video", MODE="0664"
EOF
    echo "✅ Camera udev rules written"
fi

# --- Add user to video group ---
if groups $USER | grep -q video; then
    echo "✅ User already in video group"
else
    sudo usermod -a -G video $USER
    echo "✅ User added to video group"
fi

echo ""
echo "=== Done ==="
echo "⚠️  REBOOT REQUIRED for changes to take effect."
echo "    sudo reboot"
