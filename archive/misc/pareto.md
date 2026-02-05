Multi-objective optimization
----------------------------
Standardowy problem optymalizacji można wyrazić następująco: mając daną funkcję celu (**objective
function**)
```math
f: X \mapsto \mathbb{R}
```
chcemy znaleźć $x^* \in X$ (**maximizer**) taki, że $\forall x \in X : f(x) \leq f(x^*)$. W
przypadku optymalizacji wielokryterialnej mamy kilka funkcji celu
```math
\mathbf{f}(x) = \begin{bmatrix} f_1(x) \\ \vdots \\ f_n(x)  \end{bmatrix} \in \mathbb{R}^n
```
Zadaniem jest znalezienie **frontu Pareto** rj. zbioru
```math
    P = \left\{ \mathbf{f}(x) \mid \#\{y :\mathbf{f}(y) \succ \mathbf{f}(x) \} = 0 \right\}\,,
```
gdzie $\succ$ jest relacją częściowego porządku zwaną **ścisłą dominacją** i zdefiniowaną jako
```math
\mathbf{y} \succ \mathbf{x} \iff \forall i : y_i \geq x_i \land \exists j : y_j > x_j
```
Inaczej jest to zbiór **wektorów kryterialnych** takich, że żaden inny wektor kryterialny nie
dominuje ściśle tego wektora. W przypadku optymalizacji wielokryterialnej możemy wyróżnić dwa
podejścia:
- a priori - należy znaleźć jedno, najlepsze rozwiązanie problemu wielokryterialnego opierając się
  na pewnych dodatkowych preferencjach a priori
- a posteriori - należy znaleźć cały front Pareto

Jedną z możliwych metod rozwiązania problemu wielokryterialnego a posteriori jest NSGA-II (Non-dominated Sorting Genetic Algorithm II), który możemy opisać następująco:
1. Mamy populację $P_t$.
2. Generujemy nową populację $Q_t$ poprzez stosowanie operatorów genetycznych.
3. Definiujemy $R_t = P_t \cup Q_t$.
4. Wykonujemy **sortowanie niedominujące** tj. dzielimy $R_t$ na frony:
    - $F_1$ - rozwiązania z $R_t$ niezdominowane przez inne rozwiązania
    - $F_2$ - rozwiązania z $R_t$ zdominowane tylko przez $F_1$
    - ...
    - $F_k$ - rozwiązania z $R_t$ zdominowane tylko przez $F_{k-1}$
5. Tworzymy nowe pokolonie. Dodajemy po kolei fronty $F_1$, $F_2$, ..., dopóki mamy miejsce w nowym
   pokoleniu. Jeśli dodanie całego frontu $F_i$ przekracza limit, to wybieramy z niego najlepsze
   rozwiązania wg. *crowding distance*, czyli średniej odległości od sąsiadów z frontu.

