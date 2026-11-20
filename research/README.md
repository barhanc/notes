# Research

Lightweight, agent-assisted research workspace. Ideas start as conversations and literature checks, and only grow code or formal reports when they prove worth pursuing. See the [Research table](../README.md#research) in the root README for the topic index.

## Workflow

Each topic gets a self-contained folder `research/<slug>/` (optionally prefixed with `YYYY-MM-` if time-bounded) and grows organically through three stages:

1. **Explore** ![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)
   - Start with a single `research/<slug>/README.md`.
   - Bounce ideas with a coding agent, pull relevant papers, run quick feasibility checks or sanity tests.
   - At the end of a session, distill what was learned, key links, decisions, and open questions back into `README.md` so the next session can pick up seamlessly.

2. **Experiment** ![experimenting](https://img.shields.io/badge/experimenting-D97706?style=flat)
   - Only once an idea looks worth testing: add `code/` and `figs/` inside the same topic folder.
   - Keep datasets, weights, and large outputs out of git (covered by [`.gitignore`](../.gitignore)).

3. **Wrap Up** ![done](https://img.shields.io/badge/done-1A7F37?style=flat) ![shelved](https://img.shields.io/badge/shelved-6E7781?style=flat)
   - **Worth publishing:** write a polished `report.typ` inside the topic folder; pushing to `master` auto-compiles `report.pdf` alongside it via [`.github/workflows/compile-typst.yml`](../.github/workflows/compile-typst.yml).
   - **Dead end / not worth pursuing:** mark `shelved` and jot down a short note on why — negative findings are still valuable.

## Conventions

- **Start minimal:** One file (`README.md`) is enough until a topic actually needs `code/`, `figs/`, or `report.typ`.
- **Typst compilation:** Any `.typ` file under `research/` (except files prefixed with `_`) compiles automatically on push using `--root . --font-path fonts`.
- **No premature templates:** Let structure emerge from real topics; extract shared Typst styles or templates only once patterns repeat.
