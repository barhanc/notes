* In Python 3.8+ you can compute inverse of `a` modulo `m` using built-in (not from `math` module)
  `pow` function like this
  ```python
  b = pow(a, -1, m)
  assert((a * b - 1) % m == 0)
  ```

* Python has built-in `divmod` function which returns the quotient and the remainder
  ```python
  q, r = divmod(n, d)
  ```

* When working with 2-D vectors represented as `tuple[int, int]` you can use built-in complex
  numbers instead. You can easily 
  * compute linear combination of vectors
  ```python
  z1 = x1 + y1 * 1j
  z2 = x2 + y2 * 1j
  z = a*z1 + b*z2
  ```
  * rotate vector `x+y*1j` by an angle using multiplication by a suitable complex number
    $\mathrm{e}^{\mathrm{i} \theta}$, e.g. `1j` for 90 degrees.

* Don't forget about `@functools.cache()` decorator which makes memoization a breeze.

* There is `cmath` library for complex number mathematical functions.

* Using `collections.Counter` is useful. It is basically a histogram.

* In Python there is `for else` construct
  ```python
  for x in iterable:
    if cond(x):
      # do something if condition is true
      break
    # do something
  else:
    # do something if the for loop was not interrupted using break or iterable is empty
  ```

* **Bezout's lemma**

  Let $a,b \in \mathbb{Z}$ then there exist integers $x,y$ such that $ax+by = \mathrm{gcd}(a,b)$.
  Moreover given any pair $x_0, y_0$ satisfying this equation, all pairs of the form $(x_0 - kb/d,
  y_0+ka/d)$, where $d := \mathrm{gcd}(a,b)$ satisfy it. Initial pair $(x_0,y_0)$ can be obtained
  using Extended Euclidan Algorithm which given $a,b$ computes $\mathrm{gcd}(a,b)$ and $x,y$
  satisfying the equation $ax+by = \mathrm{gcd}(a,b)$.
  ```python
  def egcd(a: int, b: int) -> tuple[int, int, int]:
    if b == 0:
      return a, 1, 0
    d, x, y = egcd(b, a % b)
    return d, y, x - y * (a // b)  
  ```

  Bezout's lemma can be used to solve linear Diophantine equations of the form $ax+by=c$. First
  notice that $d := \mathrm{gcd}(a,b)$ must divide $c$. Indeed if that is not the case the equation
  has no solutions as we then have $ax+by \equiv_{d} 0 \not\equiv_{d} c$. Therefore we can write $c
  = dl$ for some integer $l$. Note, however that if $(x, y)$ is a solution of $ax+by=d$, then
  $(xl,yl)$ is a solution to $ax+by=dl=c$, thus all solutions of the equation $ax+by=c$ are given by
  $$
  x = lx_0 - kl\frac{b}{d}\,,\quad y = ly_0 + kl\frac{a}{d}\,,\quad k \in \mathbb{Z}
  $$
  where $d = \mathrm{gcd}(a,b)$, $l = c / d$ and $x_0, y_0$ are computed using EEA.

  The solution to the linear Diophantine equation $ax+by=c$ can also be computed using modular
  inverse. Indeed assume that $a \perp b$ (if that is not the case then divide both sides by
  $\mathrm{gcd}(a,b)$ and afterwards multiply the solutions by it) then the equation is equivalent
  to a pair of modular equalities $ax \equiv_b c$, $by \equiv_a c$. Because of the assumption $a
  \perp b$ we can write $x \equiv_b ca^{-1}$ and $y = (c - ax)/b$ and obtain all solutions from a
  single pair as before.

* **Chinese remainder theorem** 

  Let $n_i \in \mathbb{Z}-\{0,1\}$, $i \in [k]$, $N := \prod_{i=1}^k n_i$ and assume that $n_i \perp
  n_j$ forall $i \neq j$, $i,j\in[k]$. Given integers $0 \leq a_i < n_i$, $i \in [k]$ there is
  exactly one integer $x$ s.t. $0 \leq x < N$ and $x \equiv_{n_i} a_i$ forall $i \in [k]$.

  **Proof.**

  First assume that $k=2$. Using Bezout's lemma there are two integers $m_1, m_2$ s.t. $n_1 m_1 +
  n_2 m_2 = 1$ (since $\mathrm{gcd}(n_1,n_2) = 1$). Notice we can construct $x$ as
  $$
    x = a_1 n_1 m_1 + a_2 n_2 m_2 = a_1 + n_2 m_2 (a_2 - a_1) = a_2 + n_1 m_1 (a_1 - a_2)
  $$
  Indeed $x \equiv_{n_1} a_1$ and $x \equiv_{n_2} a_2$.