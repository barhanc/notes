# Policy-First PFNs for In-Context RL

![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)

## Original Framing (Verbatim)

> I was thinking about bringing the idea of PFNs (Prior Fitted Networks) to RL problems for few-shot (no training adaptation) in downstream tasks. The idea is to "model the world" through sampling schemas. More concretely we could consider some family of control problems for which 1) some policy is eeasy to sample 2) for that policy it is easy to sample a problem for which it is optimal. We could then train the PFN transformer in such a way that it takes the trajectories inside it's context (so (s,a,r,s,a,...)) and is trained in a supervised fashion to infere in-context to appropriate action).
