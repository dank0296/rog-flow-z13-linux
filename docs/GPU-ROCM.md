# GPU + ROCm — Radeon 8060S iGPU Compute

The Z13's RDNA 3.5 iGPU is a beast for an integrated GPU — 40 CUs with unified 64GB memory. Here's how to use it for compute.

## Specs

| | Radeon 8060S |
|---|---|
| Architecture | RDNA 3.5 (gfx1151) |
| Compute Units | 40 |
| FP16 TFLOPS | ~12-16 |
| Memory | 64GB unified (shared with CPU) |
| Memory bandwidth | ~250 GB/s (LPDDR5X) |
| ROCm target | gfx1151 (Strix Halo) |

## ROCm on Strix Halo

ROCm support for Strix Halo (gfx1151) landed in ROCm 6.3+. It uses the **ROCm on Ryzen** consumer path, not the datacenter stack.

### Install

```bash
# Add AMD ROCm repo (Ubuntu 24.04)
wget -qO - https://repo.radeon.com/rocm/rocm.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/rocm.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/6.4.3 noble main" | \
  sudo tee /etc/apt/sources.list.d/rocm.list
sudo apt update
sudo apt install rocm-hip-sdk

# May need to set GPU target
export HSA_OVERRIDE_GFX_VERSION=11.5.1
```

### Verify

```bash
rocminfo | grep -A5 "Agent 2"
rocm-smi
```

## Ollama (local LLMs)

Ollama uses the iGPU via ROCm. Current working setup:

```bash
# Models running well at usable speeds:
ollama pull qwen3-coder:30b    # ~72 tokens/sec
ollama pull codestral:22b
ollama pull qwen2.5:14b
ollama pull deepseek-r1:14b
ollama pull llama3.2:3b
```

## NPU vs iGPU

See [NPU.md](NPU.md) for the full comparison. TL;DR: iGPU for big models, NPU for always-on lightweight inference.

## Known issues

- ROCm on APUs is still community-level support — not all libraries work
- Some ops may fall back to CPU; test workloads individually
- `HSA_OVERRIDE_GFX_VERSION` may be needed for framework compatibility