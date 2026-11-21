# Physical Transformers as a Computational Substrate

![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)

## Core Question

Today's AI inference stack feels backwards: we haul billions of static weights over off-chip copper wires to simulate Transformers on general-purpose von Neumann silicon. **What does it take physically to make the Transformer itself the native hardware substrate** — and once neural inference becomes a microsecond, milliwatt primitive, what higher-level abstractions can sit on top?

*Current stance:* Skeptical of speculative "thermodynamic computing" marketing (e.g., Extropic); assume **Transformers are the right primitive** and focus on concrete CMOS, memory, and analog/in-memory hardware physics.

## The Fundamental Physical Bottleneck

In CMOS, arithmetic is cheap; **charging wire capacitance ($E \propto C_{\text{wire}}(L) \cdot V^2$) dominates everything**:
- Local 8-bit MAC (microns): **~0.1–0.5 pJ**
- Cross-chip SRAM (~10 mm): **~5–20 pJ/word**
- Off-chip HBM/DRAM: **~100–600 pJ/word** (**100–1,000×** the compute energy)

Autoregressive decoding (~1 FLOP/byte) spends ~99% of its energy and latency moving static weights back and forth. Every physical Transformer must separate two fundamentally different workloads:
1. **Static weights** ($W_Q, W_K, W_V, W_O, W_{\text{MLP}}$) — read-only at inference; should never leave the compute site.
2. **Dynamic state** (activations + **KV cache**) — read/write every token; requires fast volatile memory.

## Hardware Physics Landscape

| Medium / Approach | Area / Density | Read Energy | Core Example | Physical Catch |
| --- | --- | --- | --- | --- |
| **Transformer Digital ASIC + HBM** | Standard HBM3E | ~100–600 pJ | **Etched (Sohu)** | High MFU (~90%), still pays off-chip HBM wall |
| **On-chip Spatial SRAM** | **6T–8T / bit** | ~1–5 pJ | **Groq, Cerebras, IBM NorthPole** | Area wall: reticle die (~815 mm²) holds only ~200–400 MB SRAM |
| **Mask ROM / Via-Programmed** | **~1T / single via / bit** | **<1 pJ** | **Taalas HC1** (TSMC 6nm, 815 mm², 53B T, Llama 3.1 8B @ ~17k tok/s/user; acquired by AMD 2026) | 6–10× denser than SRAM (2 upper via masks to respin); base weights frozen, on-die SRAM limits KV concurrency (~4–5 users) |
| **Analog NVM Crossbar** (PCM / ReRAM / FeFET) | **1T1R** (multi-bit/cell) | **~0.01–0.1 pJ/MAC** | **IBM Analog PCM AIMC** | ADC/DAC boundary tax, conductance drift, noise cascading |
| **Photonic Interference** (MZIs) | **$\mu$m waveguides** (~1,000× worse density) | Ultra-low optical propagation | Photonic Transformers / CPO | Wavelength diffraction limit + O-E-O laser/modulator tax; winning first in **chip-to-chip interconnects (CPO)** |

## Key Physics Constraints on Physical Transformers

1. **The ADC/DAC Boundary Tax (Analog's killer):** Ohm's Law ($I = GV$) + Kirchhoff ($\sum I$) compute matmuls in one step, but LayerNorm/RMSNorm, RoPE, Softmax, and SwiGLU force Analog $\leftrightarrow$ Digital conversion every layer. High-precision ADCs scale sharply with bit-width ($\sim 2^B$–$4^B$ in the thermal-noise regime) and can consume 50–80% of chip power/area.
2. **Conductance Drift & Noise:** PCM/ReRAM cells relax logarithmically over time; without noise-aware training, small errors cascade across deep autoregressive layers.
3. **The Dynamic Attention Wall ($Q K^T V$):** Unlike MLPs (dynamic $\times$ static), attention multiplies two *dynamic* tensors. KV caches cannot live in Mask ROM (immutable) or NVM (slow writes, wear-out), forcing them back into scarce volatile SRAM. **Cross-topic link:** [Context Compaction](../context-compaction/README.md) (100× smaller KV) directly unlocks high concurrency on weight-stationary physical Transformer chips.
4. **Converging realistic architecture:** Heterogeneous 3D silicon — weight-stationary fabric (Mask ROM, 3D hybrid-bonded memory-on-logic, or low-bit CIM) for static weights + volatile SRAM/gain-cell eDRAM microns above logic for KV/LoRA + Co-Packaged Optics for chip-to-chip links.

## Open Questions & TODO

- [ ] **Ultra-low-bit quantization for analog / CIM hardware:** Investigate how ternary / 1.58-bit (**BitNet b1.58**) and 2–4 bit quantization change the ADC/DAC energy-precision curve, conductance-drift tolerance, and whether ternary weights eliminate multipliers cleanly in digital SRAM CIM vs. analog crossbars.
- [ ] **3D hybrid bonding & gain-cell eDRAM:** Check how close 3D-stacked volatile memory gets to solving the dynamic KV-cache concurrency bottleneck on weight-stationary chips.
- [ ] **Abstractions above a physical substrate:** Once inference is a microsecond primitive (~17k+ tok/s), explore speculative/parallel verification loops and inverting the CPU/neural co-processor hierarchy.

## Key References

- **BitNet b1.58:** Ma et al. (2024), *The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits*, [arXiv:2402.17764](https://arxiv.org/abs/2402.17764) — ternary $\{-1, 0, +1\}$ weights replacing multipliers with additions.
- **Hardware Lottery:** Hooker (2020), *The Hardware Lottery*, [arXiv:2009.06489](https://arxiv.org/abs/2009.06489) — framing hardware/algorithm co-evolution (useful foil even when betting on Transformers).
- **Physical Neural Networks:** Wright et al. (2022), *Deep physical neural networks trained with backpropagation for arbitrary physical systems*, *Nature* / [arXiv:2104.13386](https://arxiv.org/abs/2104.13386).
- **Silicon Milestones (2024–2026):** **Taalas HC1** (via-programmed mask-ROM Llama 3.1 8B + SRAM KV/LoRA); **Etched Sohu** (Transformer-only digital ASIC); **IBM NorthPole** (spatial SRAM-intertwined digital inference) & IBM 3D Analog PCM AIMC.
