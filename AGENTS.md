# Repository Guide for Coding Agents

Personal repository of expository notes and agent-assisted research explorations.

## Repository Layout

- `typst/` (`transformers.typ`, `machine-learning.typ`, `rl-short.typ`) — Active Typst expository notes (auto-compiled to `archive/pdf/*.pdf` on push). Keep untouched unless explicitly asked.
- `archive/` — Compiled PDFs (`archive/pdf/`) and legacy Markdown/LaTeX notes. Do not break existing `archive/pdf/*.pdf` paths (linked from GitHub Pages).
- `fonts/` — Bundled `Concrete Math` fonts required for Typst compilation.
- `INBOX.md` — Rough backlog of ideas and reading material.
- `research/` — Self-contained research topic folders (`research/<slug>/`). The single topic index lives in the `## Research` table of `README.md`.

## Research Rules

1. **Conversation before code:** Start by sharpening the intuition, checking literature and feasibility, and finding the cheapest decisive test. Do not scaffold full experiment code until the user decides the idea is worth pursuing.
2. **Start with one file:** A new topic needs only `research/<slug>/README.md`. Add `code/`, `figs/`, or `report.typ` only when the topic actually grows into them.
3. **Optimize for cold-start continuity:** Keep each topic's `README.md` concise and high-signal so a fresh session can resume immediately.
4. **Keep the index and status badges in sync:** Whenever a topic is added or changes stage, update the `## Research` table in `README.md` using these flat badges:
   - `![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)`
   - `![experimenting](https://img.shields.io/badge/experimenting-D97706?style=flat)`
   - `![done](https://img.shields.io/badge/done-1A7F37?style=flat)`
   - `![shelved](https://img.shields.io/badge/shelved-6E7781?style=flat)`
5. **Respect artifact hygiene:** Never commit large datasets, model weights, checkpoints, or raw run logs (see `.gitignore`).

## Workspace Skills

Use the project skills under `.agents/skills/` for step-by-step workflows:
- `research-explore` — Bouncing ideas, literature search, and feasibility checks on a new or vague topic.
- `research-distill` — Checkpointing a research conversation into `research/<slug>/README.md` and syncing status.
- `research-report` — Writing and compiling a polished Typst report (`report.typ`) matching this repository's expository note style.
