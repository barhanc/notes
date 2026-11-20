# Context Compaction in Transformers

![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)

## Core Question

Human lifetime permanent memory is tiny compared to a single modern Transformer KV cache. Rather than mutating weights online at test time (e.g., Titans / TTT), can a **3-tier split** win instead:
1. **Decoder self-attention** — small, exact short-term working memory.
2. **Encoder latent memory (cross-attended)** — pre-distilled, compact representations of learned context/priors (zero reading tax, activation-only).
3. **Plain text files + `grep`** — lossless, human-auditable factual/episodic archive.

## Back-of-the-Envelope Anchor

| System | Capacity / Footprint | Notes |
| --- | --- | --- |
| Human lifetime memory (Landauer, 1986) | ~125 MB (~$10^9$ bits, ~2 bits/s) | Permanent long-term retention across modalities |
| Human language acquisition (Mollica & Piantadosi, 2019) | ~1.5 MB | Structured linguistic knowledge |
| Raw text (1M tokens) | ~4 MB (~1 MB gzipped) | Information-theoretic baseline |
| Llama-3 70B KV cache (1M tokens, bf16, GQA-8) | **~320 GiB** (~320 KiB/tok) | **~300,000×** blowup over gzipped text; **~2,500×** human lifetime |
| DeepSeek-V4.1-Flash CED + CSA2 + FP4 KV | **~890 B/tok** (~0.85 GiB @ 1M) | ~360× smaller than standard decoder-only KV |
| Transformer weight memorization (Morris et al., 2025) | ~3.6 bits / parameter | Landauer's 125 MB fits in ~300M params |

**Takeaway:** A Transformer KV cache is not a memory system — it is an uncompressed, layer-by-layer random-access scratchpad.

## Landscape & Trade-offs

| Paradigm | Representative Work | Pros | Core Limitation |
| --- | --- | --- | --- |
| **Heuristic KV pruning** | H2O, SnapKV, Expected Attention | Fast, drop-in | Brittle when future queries target previously low-attention tokens |
| **Latent KV compaction** | **Cartridges**, **Attention Matching** | 38–50× smaller KV; swappable activations; preserves ICL | Static-corpus focus; continual streaming updates still open |
| **Test-time fast weights** | **TTT**, **Titans**, E2E-TTT | Expressive continual compression; surprise-gated updates | Per-session weight mutation breaks GPU batching; drift/rollback risk |
| **Pointers / Virtual Memory** | **MemGPT**, **DeepSeek NSA**, `grep` + files | Exact recall, inspectable, infinite durability | "Folder tab" (pointer key = compression), hard RL credit assignment, serial foraging latency, reading tax |
| **Encoder-Decoder / Conditional Memory** | **YOCO**, **CEPE**, **DeepSeek CED / OCR / Engram** | Encodes context once; orders-of-magnitude smaller KV; clean separation of compute vs. memory | Needs a clean long-horizon update rule for the distilled encoder state |

## Key Insights & Current Stance

- **Why `grep + plain text files` works so well (and where it stops):** Zero pretraining impedance mismatch, active hypothesis-driven search beats one-shot RAG, exact provenance, human-editable. Fails on *lexical mismatch* (fuzzy/non-verbal patterns), *wiki rot* (stale/contradictory notes), *Polanyi's paradox* (tacit style/intuition serializes poorly to English), and the permanent *reading tax* (amnesiac re-prefill every session).
- **Why skepticism of Titans / TTT is justified:** Mutating weights per session hurts multi-tenant serving/batching and risks corrupting core reasoning. Meanwhile, cross-attending to $M$ distilled encoder/KV tokens is functionally analogous to a low-rank weight update (prefix-tuning $\leftrightarrow$ LoRA equivalence), giving behavioral steering *purely in activation space*.
- **Why pointers alone aren't enough:** A pointer token only works if its key/summary tells attention *when* to dereference it — so pointer design doesn't escape compression. Pointers excel at **episodic lookup**, not **distilled tacit priors**.
- **Objective matters:** *Cartridges* shows naive next-token prediction on a corpus compresses poorly for downstream QA/reasoning; **self-study context distillation** (synthetic Q&A + KL distillation) is what preserves utility.

## Open Questions / Next Steps

1. **The update rule for encoder memory $Z$ over weeks/months:**
   - *Append* ($[Z_1, \dots, Z_t]$) $\implies O(T)$ growth (eventually needs sparse/pointer routing anyway).
   - *Recurrent overwrite* ($Z_t = \text{Enc}(Z_{t-1}, x_t)$) $\implies$ fixed-size RNN bottleneck & drift.
   - *Periodic offline re-distillation from text-file ground truth* ("sleep-time" compilation into a fresh Cartridge / Attention-Matched KV / encoder state) $\implies$ **most promising direction to explore next**.
2. **Read *Cartridges* (`arXiv:2506.06266`) & *Attention Matching* (`arXiv:2602.16284`)** in detail to compare iterative gradient distillation vs. closed-form KV compaction as the offline compiler for the 3-tier design.

## Key References

- **Cartridges:** Eyuboglu et al. (2025), *Cartridges: Lightweight and general-purpose long context representations via self-study*, [arXiv:2506.06266](https://arxiv.org/abs/2506.06266) — offline self-study + context distillation into tiny loadable KV caches (~38–40× less memory).
- **Attention Matching:** Zweiger, Fu, Guo, Kim (2026), *Fast KV Compaction via Attention Matching*, [arXiv:2602.16284](https://arxiv.org/abs/2602.16284) — closed-form least-squares KV compaction (~50× in seconds, no backprop).
- **Encoder-Decoder / Cross-Attention KV:**
  - Sun et al. (2024), *You Only Cache Once (YOCO)*, [arXiv:2405.05254](https://arxiv.org/abs/2405.05254) — cache global KV once, reuse via cross-attention.
  - Yen, Gao, Chen (2024), *Long-Context Language Modeling with Parallel Context Encoding (CEPE)*, [arXiv:2402.16617](https://arxiv.org/abs/2402.16617) — small parallel chunk encoder + frozen decoder cross-attention.
  - DeepSeek-AI (2025), *DeepSeek-OCR: Contexts Optical Compression*, [arXiv:2510.18234](https://arxiv.org/abs/2510.18234) — 10–20× optical encoder-decoder context compression.
  - DeepSeek-AI (2025), *Native Sparse Attention (NSA)*, [arXiv:2502.11089](https://arxiv.org/abs/2502.11089) — trainable block-compression "pointer tokens" + top-$k$ block selection.
  - DeepSeek-AI (2026), *Conditional Memory via Scalable Lookup (Engram)* & DeepSeek-V4.1-Flash Causal Encoder-Decoder (CED) — separating compute (MoE) from static $O(1)$ lookup tables and splitting causal encoder/decoder KV projection.
- **Test-Time Neural Memory:** Behrouz, Zhong, Mirrokni (2025), *Titans: Learning to Memorize at Test Time*, [arXiv:2501.00663](https://arxiv.org/abs/2501.00663) — local attention + surprise-gated neural long-term memory.
- **OS / Virtual Memory:** Packer et al. (2023), *MemGPT*, [arXiv:2310.08560](https://arxiv.org/abs/2310.08560) — LLM context as RAM paging over external storage.
- **Capacity Bounds:** Landauer (1986), *How much do people remember?*; Mollica & Piantadosi (2019), *Humans store about 1.5 MB of information during language acquisition*; Morris et al. (2025), *How much do language models memorize?*, [arXiv:2505.24832](https://arxiv.org/abs/2505.24832).
