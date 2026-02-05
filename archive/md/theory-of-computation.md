Def. Problem decyzyjny to para $\Pi = (D_\Pi, Y_\Pi)$, gdzie $D_\Pi$ to zbiór "egzemplarzy"
problemu, a $Y_\Pi \subseteq D_\Pi$ to zbiór "egzemplarzy" z odpowiedzią "TAK".

Def. Alfabet $\Sigma$ to dowolny skończony i niepusty zbiór symboli. W szczególności jeśli $|\Sigma|
= 1$ to alfabet nazwiemy **unarnym**

Def. Słowo nad alfabetem $\Sigma$ to dowolny skończony ciąg symboli. W szczególności przez
$\epsilon$ będziemy oznaczać słowo puste.

Def. Język $L$ nad alfabetem $\Sigma$ to dowolny zbiór słów nad $\Sigma$.

Jeśli $A$, $B$ są językami to
- $A\cup B = \{x \mid x \in A \lor x \in B\}$ nazywamy sumą języków
- $A \cap B = \{x \mid x \in A \land x \in B\}$ nazywamy przecięciem języków
- $AB = \{xy \mid x\in A \land y\in B\}$ nazywamy konkatenacją języków
- $A^* = \{\epsilon\} \cup A \cup A^2 \cup \ldots$ nazywamy domknięciem języka (inaczej domknięciem
  Kleenego)

W szczególności $\Sigma^*$ oznacza zbiór wszystkich słów nad $\Sigma$. Dodatkowo wprowadzamy
oznaczenie $\Sigma^+ := \Sigma\Sigma^*$.

Każdy język $L$ definiuje problem decyzyjny postaci: *czy $x \in \Sigma^*$ należy do $L$?*
Jednocześnie każdy "sensowny" problem decyzyjny definiuje pewien język, przy założeniu, iż istnieje
"efektywna" funkcja $\langle\cdot\rangle$ kodującą problem w danym alfabecie $\Sigma$.

# Teoria obliczeń

## Maszyna Turinga

Maszyna Turinga $M$ to krotka $(\Sigma, \Gamma, Q, \delta, q_S, q_Y, q_N, \square)$, gdzie
- $\Sigma$ -- alfabet wejściow
- $\Gamma$ -- alfabet roboczy, taki że $\Sigma \subseteq \Gamma$
- $\square$ -- specjalny symbol pusty (zwany <i>blankiem</i>), o którym zakładamy, iż $\square \in
  \Gamma$ i $\square \notin \Sigma$
- $Q$ -- skończony i niepusty zbiór stanów
- $q_S$ -- stan początkowy, $q_S \in Q$
- $q_Y$ -- stan akceptujący, $q_Y \in Q$
- $q_N$ -- stan odrzucający, $q_N \in Q$
- $\delta: \Gamma \times Q \mapsto \Gamma \times Q \times \{\leftarrow, \rightarrow\}$ -- funkcja
  przejścia

Maszynę Turinga możemy wyobrażać sobie jako składającą się z nieskończonej w prawo taśmy podzielonej
na komórki oraz głowicy przechowującej stan $q$, która może czytać oraz pisać symbole z alfabetu
roboczego do komórki, na którą w danym momencie wskazuje. Początkowo na taśmie zapisane jest słowo
wejściowe $w \in \Sigma^*$ i zakładamy iż pozostałe komórki zawierają symbol blank $\square$.
Głowica będąc w stanie $q$ i czytając z komórki taśmy symbol $a \in \Gamma$ wpisuje do tej komórki
symbol $b$, zmienia stan na $q'$ i przechodzi w prawo lub lewo zgodnie z wartością funkcji przejścia
$\delta(a, q) = (b, q', \leftarrow\,\text{lub}\,\rightarrow)$.

```text
    -------------------------------------
    | a | b | a | c |   |   |   |   | ...
    -------------------------------------
            ↑
        ---------
        | q | δ |
        ---------
```

Def. Konfiguracją maszyny $M$ nazywamy dowolny napis postaci $\alpha q \beta$, gdzie $\alpha \in
\Gamma^*$, $q \in Q$ i $\beta \in \Gamma^+$, przy czym w zapisie słowa $\beta$ pomijamy
nieskończenie wiele symboli blank. Zapis taki oznacza, iż głowica maszyny wskazuje na pierwszy
symbol słowa $\beta = b_1\ldots b_k$, po lewej stronie którego zapisane na taśmie jest słowo $\alpha
= a_1\ldots a_n$, a maszyna znajduje się w stanie $q$.

```text
    ---------------------------------------------
    | a1 | a2 | .. | an | b1 | b2 | .. | bk | ...
    ---------------------------------------------
                          ↑
                      ---------
                      | q | δ |
                      ---------
```

Def. Mówimy, że maszyna $M$ akceptuje słowo $x = x_1\ldots x_n \in \Sigma^*$ iff istnieje skończony
ciąg konfiguracji, takich że pierwszym elementem ciągu jest $\epsilon q_S x_1$, ostatnim -- $\alpha
q_Y\beta$ dla pewnych $\alpha \in \Gamma^*, \beta \in \Gamma^+$ oraz dla dowolnej konfiguracji $k_t$
będącej elementem ciągu maszyna może w jednym kroku przejść z konfiguracji $k_t$ do konfiguracji
$k_{t+1}$. Jeśli $M$ nie akceptuje i nie odrzuca wprost słowa $x$, to mówimy, że $M$ odrzuca $x$
przez działanie w nieskończoność.

Def. Mówimy, że maszyna $M$ akceptuje język $L$ iff dla każdego $x\in\Sigma^*$, $M$ akceptuje $x$
iff $x\in L$.

Def. Mówimy, że maszyna $M$ rozstrzyga o języku $L$ iff akceptuje język $L$ oraz kończy działanie na
każdym słowie.

## Klasy języków

Dla danej maszyny $M$ przez $L(M)$ oznaczymy język akceptowany przez $M$. Definiujemy następujące
klasy języków
- $\text{R} := \{L \subseteq \Sigma^* \mid \exists M : M\,\text{rozstrzyga o}\,L\}$
- $\text{RE} := \{L \subseteq \Sigma^* \mid \exists M : M\,\text{akceptuje}\,L\}$
- $\text{coRE} := \{L' \mid L \in \text{RE}\}$

Języki należące do klasy $\text{RE}$ nazywamy rekurencyjnie przeliczalnymi, a języki należące do
klasy $\text{R}$ -- rozstrzygalnymi. Zauważmy, że każdy język skończony $L = \{x_1, \ldots, x_n\}$
jest rozstrzygalny, gdyż możemy skonstruować maszynę Turinga, która o nim rozstrzyga
```text
M(x):
    if x = x1: accept
    elif x = x2: accept
    ...
    elif x = xn: accept
    else: reject
```
Zauważmy, iż taka konstrukcja nie działa, gdy język jest nieskończony, gdyż wówczas "kod" maszyny
Turinga byłby nieskończony.

---

Tw. $\text{RE}\cap\text{coRE} = \text{R}$

---

Dowód. Niech $L \subseteq \Sigma^*$ będzie dowolnym językiem nad alfabetem $\Sigma$. Załóżmy wpierw,
iż $L \in \text{RE}\cap\text{coRE}$, wówczas z definicji klas $\text{RE}$ i $\text{coRE}$ istnieją
maszyny $M_L$ i $M_{L'}$ takie, że $M_L$ akceptuje $L$ i $M_{L'}$ akceptuje $L'$. Skonstruujemy
maszynę $M$ rozstrzygającą o $L$
```text
M(x):
    for k = 1,2,...:
        if M_L(x)  accepts in at most k steps: accept
        if M_L'(x) accepts in at most k steps: reject
```
Zauważmy, że każde słowo $x \in \Sigma^*$ jest akceptowane przez dokładnie jedną z maszyn $M_L$,
$M_{L'}$, zatem dla wystarczająco dużej liczby kroków $k$ dokładnie jeden z warunków będzie
prawdziwy i maszyna $M$ rozstrzygnie o słowie $x$, przy czym zaakceptuje je iff $x \in L$. W takim
razie pokazaliśmy, iż $\forall L \subseteq\Sigma^* : L \in \text{RE}\cap\text{coRE} \implies L \in
\text{R}$

Załóżmy teraz natomiast, iż $L \in \text{R}$, wówczas z definicji istnieje maszyna $M$, która
rozstrzyga o $L$. Skonstruujemy maszyny $M_L$ i $M_{L'}$ akceptujące odpowiednio języki $L$ i $L'$
```text
M_L(x):
    if M(x) accepts: accept
        reject

M_L'(x):
    if M(x) accepts: reject
        accept
```
Oczywiście maszyna $M$ kończy działanie dla każdego wejścia $x$ i akceptuje tylko słowa z języka
$L$. Maszyna $M_L$ akceptuje zatem język $L$, a maszyna $M_{L'}$ nie akceptuje żadnego słowa z
języka $L$ i akceptuje każde inne słowo, czyli akceptuje język $L'$. W takim razie $\forall
L\subseteq\Sigma^*: L\in\text{R} \implies L\in\text{RE} \land L \in\text{coRE} \Longleftrightarrow L
\in \text{RE}\cap\text{coRE}$. Z powyższego zatem otrzymujemy tezę.

---

## Teza Churcha-Turinga

**Pojęcie maszyny Turinga jest równoważne intuicyjnemu pojęciu algorytmu.**

## Uniwersalna Maszyna Turinga

Uniwersalna Maszyna Turinga $U$ mając na wejściu zakodowaną maszynę $M$ oraz słowo $x$ tj. $\langle
M, x\rangle$ symuluje działanie maszyny $M$ dla wejścia $x$. Jest to model komputera z programem
przechowywanym w pamięci. Ustalmy alfabet $\Sigma = \{0,1,\#\}$. Kodowanie maszyny $M$ możemy
przedstawić jako
```math
\langle M \rangle = \langle \Gamma \rangle \# \langle Q \rangle \# \langle \delta \rangle \# \#
```
gdzie $\langle \Gamma \rangle = \langle |\Gamma |\rangle$ i $\langle Q \rangle = \langle |Q|\rangle$
to po prostu kodowania binarne liczby symboli w alfabecie roboczym i liczby stanów, natomiast
```math
\langle \delta \rangle = \langle \text{ciąg kolejnych napisów postaci $\langle \delta(a,q)\rangle$ dla $q\in Q$, $a
\in \Gamma$} \rangle
```

## Problem stopu

Problem stopu definiujemy jako język 
```math
H := \{\langle M, x \rangle \mid \text{$M$ akceptuje $x$}\}
```

Tw. Problem stopu jest nierozstrzygalny $H \notin \text{R}$.

Tw. Rice'a. Niech $\mathscr{L} \subseteq \text{RE}$ będzie pewnym podzbiorem klasy $\text{RE}$.
Mówimy, że język $L \in \text{RE}$ ma własność $\mathscr{L}$ iff $L \in \mathscr{L}$. Jeśli tylko
$\mathscr{L} \neq \emptyset$ i $\mathscr{L} \neq \text{RE}$ to język 
```math
B_\mathscr{L} := \{\langle M \rangle \mid L(M) \in \mathscr{L}\}
```
jest nierozstrzygalny.

Twierdzenie to mówi, iż niemal każdy język dotyczący własności języków akceptowanych przez maszynę
Turinga jest nierozstrzygalny.

Def. Niech $f: \Sigma^*\mapsto\Sigma^*$. Mówimy, że funkcja $f$ jest obliczalna iff istnieje maszyna
Turinga $M$ taka, że dla każdego słowa $x \in\Sigma^*$, $M$ kończy działanie w konfiguracji
$\epsilon q_Y f(x)$.

Def. Mówimy, że język $A$ redukuje się do języka $B$, co zapisujemy jako $A \leq_m B$ iff istnieje
obliczalna funkcja $f$ taka, że
```math
\forall x\in\Sigma^*: x \in A \Longleftrightarrow f(x) \in B\quad.
```
Indeks dolny $m$ określa redukcję many-to-one tzn. wiele (nawet wszystkie) słów z języka $A$ może
być odwzorowywanych do jednego słowa z języka $B$. Jeśli $A \leq_m B$ to możemy mówić, iż $A$ jest
nietrudniejszy (inaczej co najwyżej tak trudny) niż $B$. Istotnie jeśli umiemy rozwiązać problem $B$
to umiemy rozwiązać problem $A$ przez odwzorowanie słowa z tego języka do słowa z języka $B$.
Własności redukcji:
- jeśli $A \leq_m B$ oraz $B \in \text{R}$ to $A\in\text{R}$
- jeśli $A \leq_m B$ oraz $B \in \text{RE}$ to $A\in\text{RE}$
- jeśli $A \leq_m B$ oraz $A \notin \text{R}$ to $B\notin\text{R}$

Def. Mówimy, że język $B$ jest $\text{RE}$-trudny iff dla każdego języka $A \in \text{RE}$ zachodzi
     $A \leq_m B$.

Def. Mówimy, że język $B$ jest $\text{RE}$-zupełny iff jest $\text{RE}$-trudny i $B\in\text{RE}$.

Tw. Język $H$ jest $\text{RE}$-zupełny, $H \in \text{RE-com}$.<br>

Ogólną technikę dowodzenia $\text{RE}$-zupełności możemy zatem zapisać jako:
- mamy dany język $C$, o którym chcemy udowodnić, iż jest $\text{RE-com}$
- wiemy, że język $B$ jest $\text{RE-com}$
- pokazujemy, że $C \in \text{RE}$
- pokazujemy, że $B \leq_m C$, wówczas z przechodniości relacji $\leq_m$ mamy, iż dla każdego $A \in
  \text{RE}$, $A \leq_m B \leq_m C$, co wraz z punktem wyżej dowodzi $C \in \text{RE-com}$

Tw. Język $A \in \text{RE}$ iff gdy istnieje język $B \in \text{R}$ taki, że
```math
A = \{x \mid \exists y\in\Sigma^* : \langle x,y \rangle \in B\}\,.
```

## Hierarchia arytmetyczna

Def. Powiemy, iż język $A \subseteq \Sigma^*$ należy do klasy $\Sigma_i$ dla $i\geq 1$ iff istnieje
język $B\in\text{R}$ taki, że
```math
A = \{x \mid \exists y_1 : \forall y_2 : \ldots : Q_n y_n : \langle x,y_1,\ldots,y_n \rangle \in B\}\,,
```
gdzie $Q_n = \exists$ jeśli $n$ nieparzyste i $Q_n = \forall$ jeśli $n$ parzyste. Dodatkowo powiemy,
iż język $A$ należy do klasy $\Pi_i$ iff $A' \in \Sigma_i$. Zauważmy, że z definicji tej i
poprzedniego twierdzenia wynika, iż $\Sigma_1 = \text{RE}$ oraz $\Pi_1 = \text{coRE}$.<br>

Zdefiniowane klasy tworzą nieskończoną hierarchię, w której
```math
\Sigma_{i-1} \subseteq \Sigma_i \cap \Pi_i\,,\quad \Pi_{i-1} \subseteq \Sigma_i \cap \Pi_i\,,
```
gdzie $i \geq 1$ oraz $\Sigma_0 = \Pi_0 = \text{R}$.

```text
    -----------------------------------
    |    -----------------    |       |
    |    |          |    |    |       |
    |    |     R    |    RE   |       |
    |    |          |    |    |     Sigma_2 ...
    |    -----------------    |       |
    |    |          |         |       |
    |    ----coRE----         |       |
    -----------------------------------
    |                         |
    |                         |
    ------------Pi_2-----------
                    ⋮
```

# Teoria złożoności obliczeniowej

Def. Niech $M$ będzie maszyną Turinga. Złożoność czasowa $M$ to funkcja $f:
\mathbb{N}\mapsto\mathbb{N}$ taka, że maksymalna liczba kroków $M$ na wejściu $x$ wynosi $f(|x|)$.

Def. Niech $M$ będzie maszyną Turinga. Złożoność pamięciowa $M$ to funkcja $f:
\mathbb{N}\mapsto\mathbb{N}$ taka, że maksymalna liczba wykorzystanych komórek pamięci $M$ na
wejściu $x$ wynosi $f(|x|)$.

Def. $\text{TIME}[t(n)]$ to zbiór języków $L$, dla których istnieje maszyna $M$ rozstrzygająca o $L$
w czasie $O(t(n))$.

Def. $\text{SPACE}[s(n)]$ to zbiór języków $L$, dla których istnieje maszyna $M$ rozstrzygająca o
$L$ w pamięci $O(s(n))$.

Def. $\text{P} = \bigcup_{k=0}^\infty \text{TIME}(n^k)$

Def. $\text{EXP} = \bigcup_{k=0}^\infty \text{TIME}(2^{n^k})$

Def. $\text{PSPACE} = \bigcup_{k=0}^\infty \text{SPACE}(n^k)$

Def. $\text{EXPSPACE} = \bigcup_{k=0}^\infty \text{SPACE}(2^{n^k})$

Def. Niedeterministyczna Maszyna Turinga (NMT) to krotka $(\Sigma, \Gamma, Q, \delta, q_S, q_Y, q_N,
\square)$, gdzie wszystkie elementy są takie jak w Standardowej Maszynie Turinga (SMT) poza
$\delta$, która teraz jest relacją
```math
\delta \subseteq (\Gamma \times Q \setminus \{q_Y, q_N\}) \times (\Gamma \times Q \times \{\leftarrow,
\rightarrow\})
```
Widząc dany symbol i będąc w danym stanie NMT może:
- mieć dokładnie jedną drogę kontynuowania obliczeń
- mieć więcej niż jedną drogę kontynuowania obliczeń
- nie mieć żadnego możliwego ruchu (przyjmujemy, że jest to konfiguracja odrzucająca)

Def. Mówimy, iż NMT $M$ akceptuje słowo $x$ w $k$ krokach iff:
- każda ścieżka obliczeń na $x$ wymaga najwyżej $k$ kroków
- co najmniej jedna ścieżka akceptuje w $k$ krokach

Def. Mówimy, iż NMT $M$ odrzuca słowo $x$ w $k$ krokach iff:
- każda ścieżka obliczeń na $x$ wymaga najwyżej $k$ kroków
- wszystkie ścieżki odrzucają w $k$ krokach

Def. Niech $f: \mathbb{N} \mapsto \mathbb{N}$. Mówimy, że NMT $M$ rozstrzyga o $L$ w czasie $f(n)$
iff $M$ akceptuje $x \in \Sigma^*$ wtedy i tylko wtedy, gdy $x \in L$ oraz dla wszystkich $x \in
\Sigma^*$ wszystkie ścieżki obliczeniowe $M$ na $x$ mają najwyżej $f(|x|)$ kroków.

Def. $\text{NTIME}[t(n)]$ to zbiór języków $L$, dla których istnieje NMT $M$ rozstrzygająca o $L$ w
czasie $O(t(n))$.

Def. $\text{NP} = \bigcup_{k=0}^\infty \text{NTIME}(n^k)$

Def. $\text{NEXP} = \bigcup_{k=0}^\infty \text{NTIME}(2^{n^k})$

Def. Mówimy, że język $L$ jest rzadki iff istnieje wielomian $p$ taki, że $\forall n\in\mathbb{N} :
|L^{\leq n}| \leq p(n)$.

Def. Mówimy, że język $L$ jest unarny iff $L \subseteq \{0\}^*$.

Tw. Każdy język unarny jest rzadki.

Tw. (Mahaney 1982) Jeśli istnieje $\text{NP}$-trudny język rzadki to $\text{P} = \text{NP}$.

Zależność między klasami złożoności obliczeniowej.
```text
    ---------------------------------------------------------
    |    ----------------------------------------------      |
    |    |                                            |      |
    |    |    -------------------------               |      |
    |    |    |   --------------      |               |     NEXP
    |    |    |   | ------- |   |     |               |      |
    |    |    |   | |  P  | |   NP    |               |      |
    |    |    |   | ------- |   |  PSPACE=NPSPACE     EXP    |
    |    |    |   ----------|----     |               |      |
    |    |    |   |         |         |               |      |
    |    |    |   ----coNP---         |               |      |
    |    |    -------------------------               |      |
    |    |                                            |      |
    |    ----------------------------------------------      |
    ----------------------------------------------------------
```

W szczególności wnętrze klasy $\text{NP}$ może wyglądać tylko tak
```text
                                    ---------------------------- 
        ------------                |                          |
        |          |                |   -------   ----------   |
        |  P = NP  |        lub     |   |  P  |   | NP-com |   NP
        |          |                |   -------   ----------   |
        ------------                |                          |
                                    ----------------------------
```
a nie może wyglądać tak
```text
        ------------- NP -
        |       |        |
        |   P   | NP-com |
        |       |        |
        ------------------
```

Tw. Jeśli $\text{P}\neq \text{NP}$ to istnieje język $A$ taki, że $A \in \text{NP}$, $A \notin
\text{P}$, $A \notin \text{NP-com}$.

Tw. Jeśli $\text{P} = \text{NP}$ to $\text{EXP} = \text{NEXP}$.

Tw. (Ladner) Dla każdego języka $B \notin \text{P}$ istnieje język $A \in \text{P}$ taki, że:

- $A \cap B \notin \text{P}$
- $A \cap B \leq_m^p B$
- $B \not\leq_m^p A \cap B$

Symbol $\leq_m^p$ oznacza redukcję wiele-do-jeden w czasie wielomianowym tzn. do własności
obliczalności funkcji redukującej dorzucamy jeszcze wymóg, aby była obliczalna w czasie
wielomianowym.