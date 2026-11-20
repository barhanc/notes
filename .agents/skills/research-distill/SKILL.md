---
name: research-distill
description: >-
  Use when wrapping up a research conversation, checkpointing findings and
  decisions into a topic's notes, resuming an existing research thread, or
  updating a topic's status (exploring, experimenting, done, shelved).
---

# Distill Research Session & Sync Status

Turn a messy research conversation or experiment session into crisp, durable memory inside the topic folder so future sessions start cold with full context.

## Procedure

1. **Locate or create the topic file**
   - Read `research/<slug>/README.md` (creating `research/<slug>/README.md` if this is the first checkpoint).

2. **Distill signal, not transcripts**
   - Update `research/<slug>/README.md` concisely with:
     - **Current question / hypothesis** (reflecting how it evolved).
     - **Literature & references** discovered (title, year, link, 1-line relevance).
     - **Key insights & decisions** reached in the session.
     - **Dead ends / ruled-out ideas** (briefly explain *why* so future sessions do not repeat them).
     - **Experiment takeaways** (exact metrics, configs, scripts in `code/`, and plots in `figs/`, if applicable).
     - **Open questions / next step** for the next session.
   - Keep prose tight and scannable; avoid copying raw chat back-and-forth.

3. **Handle shelving cleanly**
   - If the topic is being marked `shelved`, write a short **Why shelved** note capturing the negative result or blocker.

4. **Sync index and status badges**
   - Update the topic's row and status badge (defined in `AGENTS.md`) in the `## Research` table of `README.md`.
   - If a compiled PDF exists at `research/<slug>/report.pdf`, link it in the `Report` column.
