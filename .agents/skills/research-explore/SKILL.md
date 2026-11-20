---
name: research-explore
description: >-
  Use when the user brings a vague research idea, wants to brainstorm or bounce
  ideas, search for relevant papers/prior art, evaluate feasibility, or decide
  whether a topic is worth pursuing before writing experiment code.
---

# Research Exploration & Feasibility

Act as a rigorous research sparring partner before any heavy implementation begins.

## Procedure

1. **Check existing context first**
   - Scan the `## Research` table in root `README.md` and `INBOX.md` to see if the idea overlaps with an existing thread or backlog item.
   - If continuing an existing topic, read `research/<slug>/README.md` before responding.

2. **Sharpen the question**
   - Restate the core intuition cleanly and surface hidden assumptions, edge cases, or ambiguities.
   - Ask focused clarifying questions only when they genuinely change the direction.

3. **Survey prior art & feasibility**
   - Search relevant literature (using available literature/arXiv/web search tools) for closest prior work, standard terminology, known failure modes, and existing benchmarks.
   - Give an honest assessment: is this already solved, subtly flawed, or genuinely promising?
   - If a quick back-of-the-envelope calculation or tiny one-off sanity check settles a theoretical or empirical question, run it — but **do not** build a full experiment pipeline or scaffold `code/` until the user agrees it is worth pursuing.

4. **Identify the cheapest decisive test**
   - Propose the smallest concrete experiment or derivation that would validate or falsify the core hypothesis.

5. **Capture only when ready**
   - Once the thread has enough substance to keep (or when the user asks), create `research/<slug>/README.md` with the topic's question, key papers, current thinking, and open questions.
   - Register the topic in the `## Research` table of root `README.md` with the `exploring` badge:
     `![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)`
