// =============================================================================
// RL Cheatsheet
// =============================================================================

#set page(paper: "a5", margin: (x: 18mm, top: 22mm, bottom: 20mm), numbering: "1")
#set text(font: "Concrete Math", lang: "pl")
#set par(justify: true, leading: 0.65em)
#show heading.where(level: 1): it => counter(math.equation).update(0) + it
#show heading.where(level: 1): set text(13pt)
#show heading.where(level: 2): set text(11pt)
#show heading.where(level: 3): set text(10.5pt)
#show heading: set block(above: 1.8em, below: 1.2em)
#show math.equation: set text(font: "Concrete Math")

#set math.equation(
  numbering: n => ("(" + str(counter(heading).get().first()) + "." + str(n) + ")"),
  supplement: none,
)
#set heading(
  numbering: (..n) => (
    (if n.pos().len() == 1 { "§ " } else { "" }) + n.pos().map(str).join(".") + "."
  ),
  supplement: none,
)
#show ref: it => {
  let el = it.element
  if el != none and el.func() == heading {
    let num = counter(heading).at(el.location())
    let s = (if num.len() == 1 { "§ " } else { "" }) + num.map(str).join(".")
    link(el.location(), s)
  } else {
    it
  }
}

#let algorithm(title, body) = block(
  width: 100%,
  breakable: false,
  inset: (y: 6pt),
  stroke: (top: 0.8pt, bottom: 0.8pt),
)[
  #set par(justify: false, leading: 0.55em)
  *Algorytm:* #title
  #v(-0.4em)
  #line(length: 100%, stroke: 0.4pt)
  #v(-0.2em)
  #body
]

#align(center)[
  #text(16pt, strong("Uczenie przez Wzmacnianie"))
]

#v(0.8em)
#pad(x: 1.2em)[
  #set text(9pt)
  *Streszczenie.* Skondensowany przegląd podstawowych metod uczenia przez
  wzmacnianie: problem wielorękiego bandyty i strategie eksploracji, skończone
  procesy decyzyjne Markowa, programowanie dynamiczne, algorytmy Monte Carlo i
  TD (SARSA, Q-Learning, Double Q-Learning, metody $n$-krokowe), planowanie w
  architekturze Dyna-Q, aproksymacja funkcyjna i _deadly triad_ oraz metody
  gradientu polityki (REINFORCE, Actor--Critic).
]
#v(0.6em)

#outline()

#pagebreak()

= Bandyci

Problem wielorękiego bandyty to najprostszy model uczenia przez wzmacnianie, w
którym agent podejmuje decyzje w jednym stanie. Rozważamy zbiór akcji
$a in A$ o nieznanych rozkładach nagród $p(r | a)$. Liczbę wyborów akcji $a$
oraz estymowaną funkcję wartościującą akcje do chwili $t$ definiujemy jako
$
  N_t (a) & = sum_(i=1)^(t-1) [a_i = a] quad, \
  Q_t (a) & = 1 / (N_t (a)) sum_(i=1)^(t-1) r_i [a_i = a] quad,
$
co prowadzi do inkrementalnych reguł aktualizacji bez konieczności
przechowywania całej historii nagród:
$
  N_(t+1)(a) & = N_t (a) + [a_t = a] quad, \
  Q_(t+1)(a) & = Q_t (a) + ([a_t = a]) / (N_(t+1)(a)) (r_t - Q_t (a)) quad.
$
W środowiskach niestacjonarnych, gdzie rozkłady nagród zmieniają się w czasie,
zamiast malejącego kroku $1 / N_(t+1)(a)$ stosuje się stały krok
$alpha in (0, 1]$, co daje wykładniczą średnią ruchomą (_exponential
recency-weighted average_):
$
  Q_(t+1)(a) = Q_t (a) + alpha [a_t = a] (r_t - Q_t (a)) quad.
$

== Strategie eksploracji

Kluczowym wyzwaniem w problemie bandytów jest balans między *eksploracją*
(zbieraniem informacji o niepewnych akcjach) a *eksploatacją* (wyborem akcji o
najwyższej dotychczasowej estymacie):
- *$epsilon$-greedy:* z prawdopodobieństwem $epsilon$ wybieramy losową akcję
  $a ~ "Unif"(A)$, a z prawdopodobieństwem $1 - epsilon$ akcję zachłanną
  $a_t = arg max_a Q_t (a)$.
- *UCB (Upper Confidence Bound):* faworyzujemy akcje o wysokiej estymacie lub
  dużej niepewności (małym $N_t (a)$),
  $
    a_t = arg max_a { Q_t (a) + c sqrt((ln t) / (N_t (a))) } quad.
  $
- *Podejście gradientowe:* zamiast estymować wartości $Q_t (a)$, uczymy
  numeryczne preferencje $w_t (a)$ i definiujemy politykę przez funkcję softmax,
  $
    pi_t (a) & = (exp w_t (a)) / (sum_(b in A) exp w_t (b)) quad, \
    w_(t+1)(a) & = w_t (a) + alpha (r_t - overline(r)_t)
                 ([a_t = a] - pi_t (a)) quad,
  $
  gdzie $overline(r)_t$ jest średnią dotychczasowych nagród pełniącą rolę
  punktu odniesienia (_baseline_).

== Thompson Sampling

W podejściu Bayesowskim utrzymujemy rozkład a posteriori nad parametrami
nagród $theta_(a_t)$ i aktualizujemy go po obserwacji $r_t$:
$
  p_t (theta_(a_t) | r_t) & prop p(r_t | theta_(a_t)) p_t (theta_(a_t)) quad, \
  p_(t+1)(theta_(a_t)) & = p_t (theta_(a_t) | r_t) quad.
$
W każdym kroku próbkujemy parametry $underline(theta)_a ~ p_t (theta_a)$ dla
wszystkich akcji i wybieramy akcję maksymalizującą oczekiwaną nagrodę,
$
  a_t = arg max_a EE[r | underline(theta)_a] quad.
$

Dla *bandytów Bernoulliego*, gdzie nagrody są binarne i
$p(r | theta_a) = "Ber"(theta_a)(r) = theta_a^r (1 - theta_a)^(1 - r)$, prior
sprzężony stanowi rozkład Beta:
$
  p_1 (theta_a) = "Beta"(alpha_1, beta_1) prop
  theta_a^(alpha_1 - 1) (1 - theta_a)^(beta_1 - 1) quad.
$
Dzięki sprzężeniu po obserwacji $r_1 in {0, 1}$ rozkład a posteriori zachowuje
tę samą postać:
$
  p_2 (theta_a) & prop theta_a^(r_1) (1 - theta_a)^(1 - r_1)
                  theta_a^(alpha_1 - 1) (1 - theta_a)^(beta_1 - 1) \
                & = "Beta"(alpha_1 + r_1, beta_1 + 1 - r_1) quad.
$

= Skończone procesy decyzyjne Markowa (FMDP)

W ogólnych zadaniach sekwencyjnych decyzje agenta wpływają nie tylko na
natychmiastową nagrodę, lecz także na kolejne stany środowiska. Dynamika
środowiska jest opisana rozkładem przejść i nagród $p(s', r | s, a)$ (własność
Markowa: przyszłość zależy wyłącznie od obecnego stanu i akcji). Zdyskontowany
zwrot od chwili $t$ definiujemy jako
$
  G_t = sum_(k=0)^infinity gamma^k R_(t+k+1) quad,
$
gdzie $gamma in [0, 1)$ jest współczynnikiem dyskontującym, który określa wagę
przyszłych nagród i zapewnia zbieżność sumy. Funkcje wartościujące stany oraz
pary stan--akcja dla ustalonej polityki $pi(a | s)$ mają postać
$
  v_pi (s) & = EE_pi [G_t | S_t = s] quad, \
  q_pi (s, a) & = EE_pi [G_t | S_t = s, A_t = a] quad.
$

== Równania Bellmana i zasada optymalności

Dla ustalonej polityki $pi$ zachodzą równania Bellmana, które rekurencyjnie
wiążą wartość stanu z wartościami jego następników (tworząc zawsze układ
równań liniowych dla $v_pi (s)$ lub $q_pi (s, a)$):
$
  v_pi (s) & = sum_a pi(a | s) q_pi (s, a) quad, \
  q_pi (s, a) & = sum_(s', r) p(s', r | s, a) [r + gamma v_pi (s')] quad.
$
Optymalne funkcje wartościujące $v^*$ i $q^*$ spełniają nieliniowe równania
optymalności Bellmana:
$
  v^*(s) & = max_pi v_pi (s) = max_a q^*(s, a) quad, \
  q^*(s, a) & = max_pi q_pi (s, a) =
              sum_(s', r) p(s', r | s, a) [r + gamma v^*(s')] quad.
$

== Programowanie dynamiczne

Gdy znamy pełny model środowiska $p(s', r | s, a)$, możemy rozwiązać równania
Bellmana iteracyjnie za pomocą metod programowania dynamicznego.

#algorithm("Iterative Policy Evaluation (IPE)")[
  Zainicjalizuj $v_pi^((0))(s)$ tak, aby $v_pi^((0))("terminal") = 0$. \
  Powtarzaj aż do zbieżności:
  $
    v_pi^((k+1))(s) = sum_a pi(a | s) sum_(s', r) p(s', r | s, a)
    [r + gamma v_pi^((k))(s')] quad.
  $
]

#algorithm("Policy Iteration")[
  Zainicjalizuj deterministyczną politykę $pi_0 (s)$. \
  Powtarzaj aż do stabilizacji polityki: \
  #pad(left: 1.2em)[
    1. Oblicz $v_(pi_k)(s)$ korzystając z IPE.
    2. Popraw politykę zachłannie:
       $
         pi_(k+1)(s) = arg max_a q_(pi_k)(s, a) quad.
       $
  ]
]

#algorithm("Value Iteration")[
  Zainicjalizuj $v_0 (s)$ tak, aby $v_0 ("terminal") = 0$. \
  Powtarzaj aż do zbieżności:
  $
    v_(k+1)(s) = max_(a in A) sum_(s', r) p(s', r | s, a)
    [r + gamma v_k (s')] quad.
  $
  *zwróć* politykę zachłanną względem $v_k$
]

= Metody Monte Carlo i TD

W praktyce zazwyczaj nie znamy modelu $p(s', r | s, a)$ i musimy uczyć się
bezpośrednio z próbek doświadczenia.

== Monte Carlo

Metody Monte Carlo estymują wartości na podstawie pełnych epizodów (bez
bootstrappingu). W metodach *on-policy* ewaluujemy i ulepszamy tę samą politykę,
według której wybieramy akcje. Jeśli używamy podejścia *off-policy*, mamy dwie
polityki: $pi$ --- politykę docelową (optymalną) oraz $b$ --- politykę
behawioralną (eksplorującą). Ponieważ prawdopodobieństwa wystąpienia danego
epizodu są różne dla $pi$ i $b$, stosujemy *importance sampling*, ważąc krok
aktualizacji iloczynem ilorazów wiarygodności:
$
  alpha <- (product_(k=t)^(T-1) (pi(A_k | S_k)) / (b(A_k | S_k))) dot alpha quad.
$

== Temporal Difference (TD)

Metody TD łączą uczenie z próbek (jak MC) z bootstrappingiem (jak DP),
aktualizując estymaty po każdym kroku bez czekania na koniec epizodu. Błąd TD
definiujemy jako
$
  delta_t = R_(t+1) + gamma v(S_(t+1)) - v(S_t) quad.
$

#algorithm("SARSA (on-policy TD(0) control)")[
  Dla każdego epizodu wybieraj akcję $A$ według $Q(S, dot)$ oraz akcję $A'$
  według $Q(S', dot)$ (np. $epsilon$-greedy) i aktualizuj:
  $
    Q(S, A) <- Q(S, A) + alpha [R + gamma Q(S', A') - Q(S, A)] quad.
  $
]

#algorithm("Q-Learning (off-policy TD(0) control)")[
  Dla każdego epizodu wybieraj akcję $A$ według $Q(S, dot)$ (np.
  $epsilon$-greedy) i aktualizuj:
  $
    Q(S, A) & <- Q(S, A) \
            & quad + alpha [R + gamma max_a Q(S', a) - Q(S, A)] quad.
  $
]

SARSA znajduje optymalną politykę wśród polityk eksplorujących. Jest więc
lepszym wyborem, gdy mamy ciągłą eksplorację (np. problem z klifem: SARSA
znajduje ścieżkę nieco dłuższą, ale znacznie bezpieczniejszą). Q-Learning
znajduje politykę optymalną, ale w czasie treningu korzysta z polityki
behawioralnej (która może spaść z klifu) --- jest więc lepszym wyborem, gdy
mamy dwie fazy (eksperymentu i ewaluacji) i eksperymenty nie są kosztowne.

== Expected SARSA

Wariantem zmniejszającym wariancję aktualizacji (kosztem większej złożoności
obliczeniowej w pojedynczym kroku) jest *Expected SARSA*, która zamiast jednej
wylosowanej akcji $A'$ używa wartości oczekiwanej po polityce:
$
  Q(S, A) & <- Q(S, A) \
          & quad + alpha [R + gamma sum_a pi(a | S') Q(S', a) - Q(S, A)] quad.
$

== Błąd maksymalizacji i Double Q-Learning

Q-Learning (i częściowo Expected SARSA) wycenia wartości nadmiernie
optymistycznie (*maximisation bias*), ponieważ używa operatora $max$. Jeśli
nagrody mają dużą wariancję, algorytm powiela dodatnie wahania --- źródłem
błędu jest to, że oceniamy ten sam wybór na podstawie tej samej funkcji $Q$,
której użyliśmy do wyboru akcji.

Rozwiązaniem jest *Double Q-Learning*: utrzymujemy dwie niezależne funkcje
$Q_1, Q_2$, które aktualizujemy losowo w każdym kroku, rozdzielając wybór akcji
od jej oceny:
$
  Q_1 (S, A) & <- Q_1 (S, A) \
             & quad + alpha [
                 R + gamma Q_2 (S', arg max_a Q_1 (S', a)) - Q_1 (S, A)
               ] quad.
$

== Metody $n$-krokowe

Metody $n$-krokowe uogólniają TD(0) ($n = 1$) oraz Monte Carlo ($n -> infinity$),
korzystając z $n$ rzeczywistych nagród przed wykonaniem bootstrappingu. Dla
$n$-krokowej SARSY (on-policy) aktualizacja ma postać
$
  Q(S_t, A_t) & <- Q(S_t, A_t) \
              & quad + alpha [
                  sum_(k=0)^(n-1) gamma^k R_(t+k+1) +
                  gamma^n Q(S_(t+n), A_(t+n)) - Q(S_t, A_t)
                ] quad.
$
W przypadku off-policy należy uwzględnić ważenie importance sampling. Metody
$n$-krokowe umożliwiają szybsze przekazywanie informacji między stanami, ale
zbliżanie $n -> infinity$ powoduje rzadsze aktualizacje i dużą wariancję.

= Planowanie (Dyna-Q)

W architekturze *Dyna-Q* łączymy uczenie z rzeczywistego doświadczenia (*direct
RL update* funkcji wartości/polityki) z uczeniem modelu środowiska
$M(S, A) -> (R, S')$. W pętli planowania (*planning updates*) losujemy przeszłe
pary $(S, A)$ i symulujemy przejścia korzystając z modelu $M(S, A)$, co pozwala
znacznie efektywniej wykorzystać zebrane próbki.

Wariant *Dyna-Q+* nagradza powrót do dawno nieodwiedzanych przejść na etapie
planowania (co pomaga w środowiskach niestacjonarnych):
$
  r_+ = r + kappa sqrt(tau) quad,
$
gdzie $tau$ oznacza czas od ostatniego odwiedzenia danego przejścia między
stanami. Ponadto Dyna-Q oraz TD($lambda$) dla $lambda >> 1$ sprawdzają się
szczególnie dobrze w problemach, w których tylko wyróżnione stany dają duże
nagrody, a pozostałe do nich prowadzą (np. _maze search_), ponieważ istotne
jest wówczas „cofanie się wstecz”.

= Metody aproksymujące i Deadly Triad

Dotychczasowe algorytmy tabelaryczne wymagały przechowywania wartości dla
wszystkich par $(s, a)$, co jest niemożliwe w dużych lub ciągłych
przestrzeniach. Stosujemy wówczas aproksymację funkcyjną parametryzowaną
wektorem $bold(theta)$:
$
  hat(q)(s, a; bold(theta)) approx q_pi (s, a) quad.
$
W podejściu *semi-gradientowym* parametry aktualizujemy w kierunku celu $G_t$
(ignorując zależność samego celu od $bold(theta)$ przy liczeniu gradientu):
$
  bold(theta)_(t+1) = bold(theta)_t + alpha [
    G_t - hat(q)(S_t, A_t; bold(theta)_t)
  ] nabla_bold(theta) hat(q)(S_t, A_t; bold(theta)_t) quad.
$
Jeśli $G_t$ jest zwrotem Monte Carlo, estymator jest nieobciążony (choć może
mieć dużą wariancję). Dla celu TD otrzymujemy np. *semi-gradient SARSA*:
$
  bold(theta)_(t+1) & = bold(theta)_t + alpha [
                        R_(t+1) + gamma hat(q)(S_(t+1), A_(t+1); bold(theta)_t) -
                        hat(q)(S_t, A_t; bold(theta)_t)
                      ] \
                    & quad dot nabla_bold(theta)
                      hat(q)(S_t, A_t; bold(theta)_t) quad.
$

== Deadly Triad

Metody off-policy w połączeniu z metodami semi-gradientowymi są niestabilne.
Istnieją trzy czynniki, które osobno są pożądane, ale razem powodują
niestabilność treningu:
1. *Aproksymacja funkcyjna* (np. sieci neuronowe) --- aby generalizować i radzić
   sobie z ogromnymi przestrzeniami stanów/akcji.
2. *Bootstrapping* --- w Monte Carlo wariancja jest duża, aktualizacje rzadkie i
   nie ma transferu wiedzy w trakcie epizodów.
3. *Uczenie off-policy* --- aby osobno utrzymywać politykę optymalną i politykę
   eksplorującą.

Podbicie wartości jednego stanu powoduje (przez generalizację oraz
bootstrapping z błędem TD), że wartości innych stanów mogą rozbiegać do
nieskończoności. W uczeniu on-policy do tego nie dochodzi, ponieważ trajektorie
opuszczają przeszacowane stany i wyrównują ich wartości.

= Metody gradientu polityki (Policy Gradient)

Zamiast wyprowadzać politykę pośrednio z funkcji wartościujących $v, q$, możemy
bezpośrednio parametryzować i optymalizować politykę $pi(a | s; bold(theta))$
metodą wzrostu gradientowego:
$
  bold(theta)_(t+1) = bold(theta)_t + alpha (partial J) / (partial bold(theta))
  quad, quad J(bold(theta)) = v_(pi_bold(theta))(s_0) quad,
$
dla pewnego meta-stanu początkowego $s_0$. Z *twierdzenia o gradiencie polityki*
mamy analityczną postać gradientu niewymagającą znajomości dynamiki
środowiska:
$
  (partial J) / (partial bold(theta)) prop
  EE[G_t nabla_bold(theta) ln pi(A_t | S_t; bold(theta)_t)] quad.
$

#algorithm("REINFORCE (Monte Carlo Policy Gradient)")[
  1. Wygeneruj epizod zgodnie z polityką $pi(a | s; bold(theta)_t)$.
  2. Dla każdego kroku $t$ zaktualizuj parametry polityki:
     $
       bold(theta)_(t+1) = bold(theta)_t + alpha G_t
       nabla_bold(theta) ln pi(A_t | S_t; bold(theta)_t) quad.
     $
]

== REINFORCE z baseline i Actor--Critic

Wariancję estymatora gradientu redukujemy przez odjęcie funkcji bazowej
(_baseline_) $b(S_t)$ niezależnej od wybranej akcji (co nie wprowadza
obciążenia):
$
  bold(theta)_(t+1) = bold(theta)_t + alpha (G_t - b(S_t))
  nabla_bold(theta) ln pi(A_t | S_t; bold(theta)_t) quad.
$
Naturalnym wyborem jest $b(S_t) = hat(v)(S_t; bold(phi))$, gdzie krytyk
$bold(phi)$ uczy się równolegle z aktorem $bold(theta)$:
$
  bold(phi)_(t+1) & = bold(phi)_t + alpha [G_t - hat(v)(S_t; bold(phi)_t)]
                    nabla_bold(phi) hat(v)(S_t; bold(phi)_t) quad, \
  bold(theta)_(t+1) & = bold(theta)_t + alpha [G_t - hat(v)(S_t; bold(phi)_t)]
                      nabla_bold(theta) ln pi(A_t | S_t; bold(theta)_t) quad.
$
Ponieważ mamy już estymację $hat(v)(S_t; bold(phi)_t)$, możemy zastąpić zwrot
Monte Carlo $G_t$ jednokrokowym celem TD (bootstrapping), łącząc zalety metod
wartościujących i politykowych w architekturze *Actor--Critic*:
$
  bold(phi)_(t+1) & = bold(phi)_t + alpha delta_t
                    nabla_bold(phi) hat(v)(S_t; bold(phi)_t) quad, \
  bold(theta)_(t+1) & = bold(theta)_t + alpha delta_t
                      nabla_bold(theta) ln pi(A_t | S_t; bold(theta)_t) quad,
$
gdzie $delta_t = R_(t+1) + gamma hat(v)(S_(t+1); bold(phi)_t) -
hat(v)(S_t; bold(phi)_t)$.

W zadaniach nieepizodycznych (*continual learning*) klasyczny zwrot $G_t$ traci
sens z powodu dyskontowania; wprowadzamy wówczas zwrot różnicowy względem
średniej nagrody $overline(R)$:
$
  G_t & = R_(t+1) - overline(R) + R_(t+2) - overline(R) + dots.c quad, \
  delta_t & = R - overline(R) + q(S', A') - q(S, A) quad.
$
