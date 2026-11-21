# Policy-First PFNs for In-Context RL

![exploring](https://img.shields.io/badge/exploring-0969DA?style=flat)

## Core Question

Can we build a **Prior-Data Fitted Network (ControlPFN)** for few-shot in-context RL **without any forward RL/optimal-control solver or behavior cloning**—by **inverse sampling** (sampling a policy/value structure first, then analytically constructing a realistic control problem for which it is *exactly* optimal)?

*Current stance:* Pure inverse sampling only—no teacher controllers (no iLQR/PPO/VI cloning). Just like TabPFN's breakthrough was its SCM prior, ~90% of the research problem is designing a **physically realistic, non-leaking sampling schema** whose prior transfers zero-shot to real forward environments.

## Prior Art & The Open Gap

| Work | Approach | Why Our Gap Remains Open |
| :--- | :--- | :--- |
| **Ferreira et al. (2024)**, *One-shot World Models* (`arXiv:2409.14084`) | PFN trained on synthetic NN/momentum dynamics $\to$ Gym | Learns a **world model**, still runs RL/planning at test time. |
| **Zighem & Vie (2026)**, *RL Foundation Models Should Already Be A Thing* (`arXiv:2606.18812`) | Attention network on synthetic tabular MDPs | Small discrete tabular MDPs solved **forward** (VI); hits curse of dimensionality. |
| **ICR-RL / TabPFN-RL (2025)** (`arXiv:2509.11259`) | Off-the-shelf TabPFN inside Fitted Q-Iteration | Gradient-free iterative FQI, not a single-pass control-prior policy PFN. |
| **DPT** (Lee et al., 2023) & **Algorithm Distillation** (Laskin et al., 2023) | Supervised in-context prediction of $\pi^*(s_q \mid \mathcal{H})$ | Requires oracle RL solvers on real task families, not synthetic priors. |
| **Bin Mohaya et al. (2026)**, *Generalizable Optimal Control* (`arXiv:2609.22672`) | In-context Transformer for LTI systems | Linear (LQR) with explicit cost matrices, not nonlinear RL from transitions. |

**Open gap:** Nobody has trained a **single-forward-pass nonlinear ControlPFN** using **inverse-generated (zero-solver) priors** that transfers zero-shot to real forward dynamical/MDP benchmarks.

## Unifying Principle: Invert for Dynamics, Not Reward

- **Dead end — naive reward inversion:** Fixing dynamics $(f, g)$ or $P$, sampling $V^*$, and solving HJB/Bellman for cost $q(x)$ or reward $r(s,a)$ induces **dense potential-based reward shaping**. In real RL, costs are simple/sparse and $V^*$ is complex; naive reward inversion flips this and risks training a myopic optimizer.
- **Core insight — dynamics inversion:** Fix a **simple, unshaped cost/reward** and sample $(V^*, \pi^*)$ first, then solve the **linear** HJB/Bellman constraint for the **dynamics** ($f(x)$ or $P(\cdot \mid s, a)$).

### Route A: Singularity-Free Inverse Mechanical Prior *(Primary Focus)*

For $n$-DOF 2nd-order mechanical systems $\dot{q} = v, \; \dot{v} = a(q, v) + B u$ ($q, v \in \mathbb{R}^n$, $u \in \mathbb{R}^m$ with $m \le n$, including **underactuated** plants since $B$ is never inverted):

1. Sample a smooth bowl potential $W(q) \ge 0$ ($W(0) = 0$), target velocity field $v^*(q) = -c\,\nabla W(q)$, SPD matrix $P$, actuation $B \in \mathbb{R}^{n \times m}$, discount $\rho > 0$, skew-symmetric gyroscopic matrix $S = -S^\top$, and velocity cost $R_v \succ 0$.
2. Exact optimal value & policy (with $e := v - v^*(q)$):
   $$V^*(q, v) = W(q) + \frac{1}{2} e^\top P e, \qquad u^*(q, v) = -R^{-1} B^\top P e$$
   *(Bounded torque $|u_i| \le u_{\max}$ works identically via the $\log\cosh$ convex conjugate $\implies u^* = -u_{\max}\tanh(\dots)$.)*
3. **Unshaped mechanical cost** (no $q \cdot v$ cross-terms):
   $$\ell(q, v) = \underbrace{\rho W(q) - \nabla W(q)^\top v^*(q) - \frac{1}{2} v^*(q)^\top R_v v^*(q)}_{\ell_q(q) \,\ge\, 0 \text{ for } c R_v \prec 2I} \;+\; \frac{1}{2} v^\top R_v v$$
4. **Singularity-free acceleration** ($e$ cancels identically out of HJB):
   $$a(q, v) = P^{-1}\!\big(-\nabla W + (P J_{v^*} - R_v)v^*\big) + \Big(\frac{\rho}{2}I + J_{v^*} - \frac{1}{2}P^{-1}R_v + \frac{1}{2}B R^{-1} B^\top P + P^{-1}S\Big) e$$

- **Global stability conditions** (guarantees HJB Verification Theorem & zero $u^*$ divergences):
  - Quadratic torque: $R_v + P B R^{-1} B^\top P \succ \rho P + \frac{1}{2} c R_v^2$.
  - Bounded $\tanh$ torque (or underactuated rank-deficient $B$): $R_v \succ \rho P$ (prevents quadratic discount growth from beating saturated/unactuated modes).
- **Scope:** Covers **stabilization, balancing, reaching, and tracking** with unstable equilibria & positive friction across 1–4 DOFs (`Pendulum` stabilization, `CartPole` / `Acrobot` balance, `Reacher`, planar quadrotor, $n$-link arms with unknown payload/friction/gain).
- **Honest boundary:** Smooth single-bowl $V^*$ does **not** capture multi-swing energy pumping under severe torque limits (`MountainCar`, `Pendulum-v1` from $\theta=\pi$) or discontinuous contact locomotion (`Hopper`, `HalfCheetah`).

### Route B: Discrete $P$-Solving Converse Bellman *(Complementary Track)*

Fix sparse goal reward ($r = +1$ at goal, $0$ elsewhere), sample a hop-depth $d(s)$ and slipperiness $p^* \in (0, 1]$, and construct transitions without Value Iteration:
- **5-line constant-slip sampler:** $a^*(s)$ transitions to depth $d-1$ with prob $p^*$ and stays/slips within depth $d$ with prob $1-p^*$; every $a \neq a^*(s)$ uses the **exact same probability vector** (zero entropy leakage) routed to distinct states at depth $\ge d$. Exact optimal value is $V^*(s) = \beta^{d(s)}$ with $\beta = \frac{\gamma p^*}{1 - \gamma(1-p^*)}$.
- **1-line general mixture** (for arbitrary $V^*$ and cross-layer slips): mix random $p_{\text{hi}}$ ($V \ge \mu^*$) and $p_{\text{lo}}$ ($V \le \mu^*$) with $w^* = (\mu^* - m_{\text{lo}}) / (m_{\text{hi}} - m_{\text{lo}})$.
- **Why it matters:** Lazy $O(1)$-per-step transition generation scales to huge factored discrete spaces (`Taxi`, `MiniGrid`, `OR-Gym` inventory/routing) where Zighem & Vie's forward VI cannot run.

## Sanity Check Results (Inverse Mechanical Sampler)

Verified via standalone NumPy + RK4 rollout check (100 random 1-DOF quadratic, 100 bounded-$\tanh$, 25 coupled 2-DOF + gyroscopic):
- **Max HJB PDE residuals:** `1.85e-13` (1-DOF quadratic), `5.32e-09` (1-DOF bounded $\tanh$), `1.28e-11` (2-DOF coupled + gyro).
- **Physical realism:** `66/100` (quadratic) and `63/100` (bounded) sampled plants simultaneously have an **unstable inverted equilibrium ($k_q > 0$)** and **positive physical friction ($d_0 > 0$)**.
- **Independent RK4 rollouts (15 random 1-DOF nonlinear plants):** `0/15` divergences under $u^*$; mean $|J_{\text{rollout}}(u^*) - V^*(x_0)| / V^*(x_0) = 0.57\%$; $u^*$ strictly beat all 5 baselines on `15/15` plants (open-loop $u=0$ diverged `13/15`; myopic $-q$ had `9.63×` median cost and diverged `5/15`; $0.5 u^*$ had `1.44×` median cost).
- **Visual phase-portrait diagnostic vs. `Pendulum-v1`:** Sampled unstable plants match `Pendulum-v1`'s upright saddle geometry and S-shaped force/bowl-cost shape, but naive parameter ranges are ~5–20× softer than `Pendulum-v1` ($|F| \sim 1\text{--}4$ vs. $15$) $\implies$ prior needs explicit force/time-scale randomization.

## Traps & Subtle Bugs Logged

1. **Reward-shaping inversion** (naive $q$/$r$-solving) and **transition leakage** (unmatched action entropy/self-loop rates in discrete $P$-solving).
2. **2-DOF gyroscopic bug:** Skew-symmetric term in $a(q,v)$ must be $P^{-1} S$ (not $P^{-1} S P$), since $(Pe)^\top (P^{-1} S) e = e^\top S e = 0$.
3. **Bounded-torque divergence:** Requires $r_v > \rho p$ (or restricting initial states to the controllable basin).
4. **Context distribution shift:** Pretraining context $\mathcal{H}$ must mix exploratory rollouts (OU/random), **wrong-plant optimal policies** $\pi^*_{M'}$ (mimics early online posterior-sampling rollouts), and noisy-optimal $\pi^*_M + \epsilon$.

## Next Step (Cheapest Decisive Experiment)

Build a minimal **1-DOF Mechanical ControlPFN** smoke test (4–6 layer TabPFN-masked Transformer, ~1–2M params, supervised NLL on exact $u^*(q_{\text{query}}, v_{\text{query}})$ given $N \in [30, 150]$ transitions, random actuator sign $b \in \pm[0.5, 4]$, random goal offset $q^*$, randomized force/time scales):
- [ ] Verify zero-shot few-shot convergence on held-out inverse nonlinear plants (including flipped motor sign $b < 0$).
- [ ] **Make-or-break OOD test:** Evaluate zero-shot (zero gradient updates) on *real forward ODEs* not generated by the inverse sampler—damped inverted pendulum, `Pendulum-v1` (stabilizable basin), and Duffing oscillator—against oracle LQR/iLQR and linear SysID + LQR.
- [ ] If 1-DOF transfers cleanly, scale the exact same sampler + variable-DOF tokenizer to $n \in \{1..4\}$-DOF with $m \le n$ (`CartPole` balance, `Reacher`, planar quadrotor).

## Key References

- **TabPFN / PFN Paradigm:** Müller et al. (2025), *Position: The Future of Bayesian Prediction Is Prior-Fitted*; Hollmann et al. (2023/2025), *TabPFN*.
- **In-Context RL:** Lee et al. (2023), *Decision-Pretrained Transformers* (DPT); Laskin et al. (2023), *Algorithm Distillation*.
- **Synthetic-Prior RL / Control:** Ferreira et al. (2024), *One-shot World Models Using a Transformer Trained on a Synthetic Prior*, [arXiv:2409.14084](https://arxiv.org/abs/2409.14084); Zighem & Vie (2026), *Position: Reinforcement Learning Foundation Models Should Already Be A Thing*, [arXiv:2606.18812](https://arxiv.org/abs/2606.18812); *ICR-RL / Gradient-Free Deep RL with TabPFN*, [arXiv:2509.11259](https://arxiv.org/abs/2509.11259); Bin Mohaya et al. (2026), *Generalizable Optimal Control with Transformers*, [arXiv:2609.22672](https://arxiv.org/abs/2609.22672).
- **Control Theory Foundations:** Freeman & Kokotović (1996), *Inverse Optimality in Robust Stabilization*; Todorov (2006) & Kappen (2005), *Linearly Solvable MDPs / Path Integral Control*; Ortega et al., *IDA-PBC / Port-Hamiltonian Energy Shaping*.
