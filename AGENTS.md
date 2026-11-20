# Repository Guide for Coding Agents

Personal repository of theoretical monographs, notes, and agent-assisted research explorations.

## Repository Layout

- `monographs/` (`transformers.typ`, `machine-learning.typ`, `rl-short.typ`) — Active Typst monographs (auto-compiled to `archive/pdf/*.pdf` on push). Keep untouched unless explicitly asked.
- `archive/` — Compiled monograph PDFs (`archive/pdf/`) and legacy Markdown/LaTeX notes. Do not break existing `archive/pdf/*.pdf` paths (linked from GitHub Pages).
- `fonts/` — Bundled `Concrete Math` fonts required for Typst compilation.
- `INBOX.md` — Rough backlog of ideas and reading material.
- `research/` — Self-contained research topic folders (`research/<slug>/`) and workflow conventions in `research/README.md`. The single topic index lives in the `## Research` table of root `README.md`.

## Research Workflow Rules

1. **Conversation before code:** Research topics typically start as vague ideas. Focus first on discussing the intuition, searching relevant literature, checking feasibility, and finding the cheapest way to test or falsify the idea. Do not jump into building full experiment codebases until the user decides the idea is worth pursuing.
2. **Start with one file:** A new topic needs only `research/<slug>/README.md`. Add `code/`, `figs/`, or `report.typ` only when the topic actually grows into them. Do not create empty placeholder directories or rigid boilerplate.
3. **Optimize notes for cold-start continuity:** Keep each topic's `README.md` concise and high-signal (current question, key papers, decisions, dead ends, open questions) so a fresh agent session can resume immediately without re-explaining context.
4. **Keep the research index and status badges in sync:** Whenever a topic is added or changes stage (`exploring`, `experimenting`, `done`, `shelved`), update the `## Research` table in the root `README.md` using the flat shields.io badges defined in `research/README.md`.
5. **Respect artifact hygiene:** Never commit large datasets, model weights, checkpoints, or raw run logs (see `.gitignore`).
6. **Typst compilation:** Any `.typ` file under `research/` (unless prefixed with `_`) is auto-compiled to a sibling `.pdf` on push to `master` by `.github/workflows/compile-typst.yml`. Local compilation command:
   ```bash
   typst compile --root . --font-path fonts <path/to/file.typ>
   ```

## Workspace Skills

Use the project skills under `.agents/skills/` when applicable:
- `research-explore` — Bouncing ideas, literature search, and feasibility checks on a new or vague topic.
- `research-distill` — Checkpointing a research conversation into `research/<slug>/README.md` and syncing statuses/indexes.
- `research-report` — Writing a polished Typst report (`report.typ`) matching this repository's monograph style.
