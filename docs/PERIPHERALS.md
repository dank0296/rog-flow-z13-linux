# Peripherals — Keyboard, Suspend, WiFi

Fixes for the Z13's peripherals on Linux.

## RGB Keyboard (asusctl)

```bash
# Ubuntu 24.04
echo "deb [arch=amd64] https://repo.asus-linux.org/ubuntu noble main" | \
  sudo tee /etc/apt/sources.list.d/asus.list
wget -qO - https://repo.asus-linux.org/asus.gpg | sudo apt-key add -
sudo apt update && sudo apt install asusctl
```

### Usage

```bash
asusctl led-mode static -c FF0000    # Red
asusctl led-mode breathe -c 00FF00   # Green breathing
asusctl led-mode rainbow              # 🌈
asusctl profile -P quiet | balanced | performance
asusctl chardev -e 80    # Charge limit 80%
```

### Optional GUI

```bash
sudo apt install rog-control-center
```

## Suspend / Sleep

Works out of the box on kernel 6.17-oem. Strix Halo chiplet design requires kernel ≥ 6.10 for proper sleep states.

If you were on older kernels: CachyOS kernel (Arch) or 6.17-oem (Ubuntu) resolves micro-stutters and sleep issues.

## WiFi (MediaTek MT7925)

WiFi 7. Works on 6.17-oem without patches for most users.

If disconnects occur:
```bash
lspci -k | grep -A3 MT7925
# Patches: https://github.com/burakgon/mt7925-wifi-patches
```

## Bluetooth

Working. Tested with Logitech MX Vertical.

## Tablet Mode

GNOME 46 (Wayland) handles rotation and OSK natively. No extra packages needed.

For Hyprland: `iio-hyprland-git`, `wvkbd-mobintl`, `rofi-wayland` (Arch only).

## Firmware

```bash
sudo dmidecode -s bios-version
# GZ302EA.311 or newer recommended
```
