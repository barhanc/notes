---
name: research-report
description: >-
  Use when the user wants to turn a mature research topic or completed
  experiment into a polished Typst report (`report.typ`) matching this
  repository's expository note styling and CI compilation setup.
---

# Write a Typst Research Report

Distill mature notes and experimental findings from `research/<slug>/` into a clean, publication-grade Typst document.

## Procedure

1. **Gather source material**
   - Read `research/<slug>/README.md` and inspect any figures in `research/<slug>/figs/` and scripts/results in `research/<slug>/code/`.
   - Check the preamble of `typst/transformers.typ` (or `typst/machine-learning.typ` for Polish) to stay visually consistent with the repository's expository notes.

2. **Match repository Typst style**
   - Create `research/<slug>/report.typ` using:
     - `Concrete Math` font for body and math (`#set text(font: "Concrete Math")` and `#show math.equation: set text(font: "Concrete Math")`).
     - `§` level-1 heading numbering, `(section.eq)` equation numbering resetting per level-1 heading, and the custom `#show ref` rule for heading cross-references.
     - A4 page size for reports with tables/figures (or A5 if the user prefers the compact expository note look).
     - Relative paths for topic figures (e.g., `image("figs/plot.png")`).
   - Do not prefix the main report filename with `_` (CI skips `_*.typ` helpers).

3. **Verify compilation**
   - Compile from the repository root if `typst` is available:
     ```bash
     typst compile --root . --font-path assets/fonts research/<slug>/report.typ
     ```
   - On push to `master`, `.github/workflows/compile-typst.yml` automatically compiles `research/<slug>/report.typ` to `research/<slug>/report.pdf`.

4. **Update index**
   - Link `report.pdf` (and update the status badge to `done` if complete) in `research/<slug>/README.md` and the `## Research` table in root `README.md`.
