// =============================================================================
// Klasyczne uczenie maszynowe
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
  #text(16pt, strong("Klasyczne Uczenie Maszynowe"))
]

#outline()

= Wnioskowanie Bayesowskie

Typowym sposobem połączenia wyników matematycznej teorii prawdopodobieństwa z
eksperymentami jest interpretacja częstościowa, która stwierdza iż
prawdopodobieństwo zdarzenia $A$ to częstość realizacji $A$ w dużej liczbie prób.
Dla wielu zdarzeń pojęcie _dużej liczby prób_ nie jest jednak dobrze
zdefiniowane. Wówczas interpretacja Bayesowska prawdopodobieństwa jako miary
niepewności co do rezultatu określonego zdarzenia jest bardziej naturalna.
Wnioskowanie Bayesowskie opiera się na twierdzeniu Bayesa
$
  underbrace(p(bold(x) | bold(y)), "posterior") =
  (underbrace(p(bold(y) | bold(x)), "likelihood")
  underbrace(p(bold(x)), "prior")) /
  (underbrace(integral p(bold(y) | bold(x)) p(bold(x)) dif bold(x), "evidence"))
$
oraz dwóch regułach znanych z rachunku prawdopodobieństwa: _sum rule_ i
_product rule_,
$
  p(bold(x)) = integral p(bold(x), bold(y)) dif bold(y) quad, quad
  p(bold(x), bold(y)) = p(bold(x) | bold(y)) p(bold(y)) quad.
$
Typowe zastosowanie wnioskowania Bayesowskiego przebiega następująco: mamy
pewien zbiór obserwacji $cal(X)$, o których zakładamy, iż pochodzą z pewnego
rozkładu prawdopodobieństwa z parametrami $bold(theta)$, tj. znamy wiarygodność
$p(cal(X) | bold(theta))$. Zakładamy dodatkowo pewien prior nad parametrami
$p(bold(theta))$. Następnie korzystając z twierdzenia Bayesa wyznaczamy rozkład
a posteriori nad parametrami modelu
$
  p(bold(theta) | cal(X)) =
  (p(cal(X) | bold(theta)) p(bold(theta))) /
  (integral p(cal(X) | bold(theta)) p(bold(theta)) dif bold(theta)) quad.
$
Rozkład a posteriori podsumowuje całą naszą wiedzę o estymowanym parametrze (z
perspektywy wnioskowania Bayesowskiego). Korzystając z tego rozkładu możemy:
- Wyznaczyć estymatę punktową (tzw. estymatę _maximum a posteriori_ (MAP))
  parametru $bold(theta)$ jako
  $
    bold(theta)_"MAP" = arg max_bold(theta) p(bold(theta) | cal(X)) quad.
  $

- Wyznaczyć _przedział wiarygodności_ (ang. _credible interval_, nie mylić z
  przedziałem ufności) parametru $bold(theta)$ jako
  $
    C_alpha (bold(theta); cal(X)) = (underline(bold(theta)), overline(bold(theta))) quad,
  $
  gdzie
  $
    integral_underline(bold(theta))^overline(bold(theta))
    p(bold(theta) | cal(X)) dif bold(theta) = 1 - alpha quad.
  $

- Skonstruować _rozkład predyktywny_ (ang. _posterior predictive distribution_)
  dla nowych obserwacji
  $
    p(bold(x) | cal(X)) = integral p(bold(x) | bold(theta))
    p(bold(theta) | cal(X)) dif bold(theta) quad.
  $

- Wyznaczyć wartość parametru $bold(theta)$, która minimalizuje oczekiwaną
  stratę dla pewnej funkcji kosztu,
  $
    bold(theta)^* & = arg min_(bold(theta)') EE_(bold(theta) ~ p(bold(theta) | cal(X)))
                      [L(bold(theta)', bold(theta))] \
                  & = arg min_(bold(theta)') integral L(bold(theta), bold(theta)')
                      p(bold(theta) | cal(X)) dif bold(theta) quad.
  $

== Rozkład normalny

Wielowymiarowy rozkład normalny o średniej $bold(mu) in RR^n$ i symetrycznej,
nieujemnie określonej macierzy kowariancji $bold(Sigma) in RR^(n times n)$ to
rozkład o gęstości danej przez
$
  p(bold(x) | bold(mu), bold(Sigma)) =
  1 / ((2pi)^(n/2) |bold(Sigma)|^(1/2))
  exp[- 1 / 2 (bold(x) - bold(mu))^top bold(Sigma)^(-1) (bold(x) - bold(mu))] quad.
$
Macierz $bold(Lambda) = bold(Sigma)^(-1)$ nazywamy macierzą precyzji. Będziemy
często korzystać z następującej własności rozkładów normalnych: jeśli zmienne
$bold(x) in RR^n$ i $bold(y) in RR^m$ mają łącznie wielowymiarowy rozkład
normalny
$
  mat(bold(x); bold(y)) ~ cal(N)(
    mat(bold(mu)_x; bold(mu)_y),
    mat(bold(Sigma)_(x x), bold(Sigma)_(x y); bold(Sigma)_(y x), bold(Sigma)_(y y))
  ) quad,
$
to rozkłady brzegowe są rozkładami normalnymi
$
  bold(x) ~ cal(N)(bold(mu)_x, bold(Sigma)_(x x)) quad, quad
  bold(y) ~ cal(N)(bold(mu)_y, bold(Sigma)_(y y))
$
oraz rozkłady warunkowe są rozkładami normalnymi
$
  bold(x) | bold(y) ~ cal(N)(bold(mu)_(x | y), bold(Sigma)_(x | y)) quad,
$
gdzie
$
  bold(mu)_(x | y) & = bold(mu)_x + bold(Sigma)_(x y) bold(Sigma)_(y y)^(-1)
                      (bold(y) - bold(mu)_y) quad, \
  bold(Sigma)_(x | y) & = bold(Sigma)_(x x) - bold(Sigma)_(x y)
                         bold(Sigma)_(y y)^(-1) bold(Sigma)_(y x) quad.
$

== Liniowe modele Gaussowskie

Jednym z najprostszych modeli, do którego można zastosować wnioskowanie
Bayesowskie jest tzw. liniowy model Gaussowski. Zakładamy, iż mamy obserwację
$bold(y)$, która pochodzi z rozkładu normalnego
$
  bold(y) | bold(x) ~ cal(N)(bold(A) bold(x) + bold(b), bold(Sigma)_y) quad,
$
gdzie $bold(x)$ jest pewną zmienną ukrytą (ang. _hidden variable_), natomiast
$bold(A)$, $bold(b)$ i $bold(Sigma)_y$ są znane dokładnie. Dodatkowo przyjmijmy
_prior sprzężony do wiarygodności_ dla parametru $bold(x)$ będący rozkładem
normalnym o znanych parametrach $bold(mu)_x$, $bold(Sigma)_x$,
$
  bold(x) ~ cal(N)(bold(mu)_x, bold(Sigma)_x) quad.
$
Wówczas rozkład a posteriori również będzie rozkładem normalnym o parametrach
$
  bold(mu)_(x | y) & = bold(Sigma)_(x | y) (bold(A)^top bold(Sigma)_y^(-1)
                      (bold(y) - bold(b)) + bold(Sigma)_x^(-1) bold(mu)_x) quad, \
  bold(Sigma)_(x | y) & = (bold(Sigma)_x^(-1) + bold(A)^top bold(Sigma)_y^(-1)
                         bold(A))^(-1) quad.
$

= Regresja liniowa

Załóżmy, że modelujemy obserwacje postaci $(y, bold(x))$, gdzie $y$ to skalar
zwany _zmienną objaśnianą_, natomiast $bold(x)$ to wektor cech lub inaczej
_zmiennych objaśniających_. Zakładamy, że zmienna objaśniana zależy liniowo od
zmiennych objaśniających oraz, iż zależność ta jest obarczona pewnym błędem
losowym. Model ten ma więc postać
$
  y(bold(x)) = phi(bold(x); bold(w), b) + epsilon =
  bold(w)^top bold(x) + b + epsilon quad,
$
gdzie $y(bold(x))$ jest wartością zmiennej losowej obserwowaną dla znanego
dokładnie wektora cech $bold(x)$ (wektor cech _nie_ jest zmienną losową),
natomiast $bold(w)$ i $b$ to parametry modelu $phi$, o których chcemy
wnioskować. Model ten jest typowym przykładem _regresji liniowej_.
Parametryzację regresji liniowej można uprościć przyjmując, że do wektora cech
dokładamy stałą wartość $1$, a parametr $b$ włączamy do $bold(w)$,
$
  bold(x)^top <- mat(bold(x)^top, 1) quad, quad
  bold(w)^top <- mat(bold(w)^top, b) quad.
$
W zależności od przyjętego rozkładu zmiennej opisującej błąd losowy $epsilon$
otrzymujemy różne modele, np.:
- regresja liniowa (ang. _linear regression_), $epsilon ~ cal(N)(0, sigma^2)$
  dla znanego $sigma^2$,

- regresja odporna (ang. _robust regression_),
  $epsilon ~ "Laplace"(0, lambda)$ dla znanego $lambda$,
  $
    "Laplace"(x; mu, lambda) = 1 / (2b) exp[- |x - mu| / b] quad,
  $

- regresja kwantylowa (ang. _quantile regression_),
  $epsilon ~ "ALD"(0, lambda, p)$ dla znanego $lambda$ i percentyla $p$,
  $
    "ALD"(x; mu, lambda, p) = (p(1 - p)) / lambda dot cases(
      e^(- ((p - 1)(x - mu)) / lambda) & quad x <= mu \,,
      e^(- (p(x - mu)) / lambda) & quad x > mu \,.
    )
  $

Zauważmy tutaj, że założenie iż znamy skalę (tj. parametry $sigma$, $lambda$)
błędu jest dosyć mocne --- z reguły nie wiemy jak dokładnie możemy przybliżyć
zmienną objaśnianą. Dokładne wnioskowanie Bayesowskie przeprowadzimy tylko dla
pierwszego z powyższych modeli, gdzie błędy mają rozkład normalny. To
założenie, choć sensowne, ma również swoje konsekwencje --- nasz model będzie
dosyć wrażliwy na obserwacje odstające (ang. _outliers_). Zamiast rozkładu
normalnego można przyjąć rozkład, w którym gęstość prawdopodobieństwa ma tzw.
ciężkie ogony (ang. _heavy tails_) --- np. rozkład Laplace'a. Otrzymamy wówczas
model zwany odporną regresją liniową (ang. _robust linear regression_). Oba
powyższe modele równo rozkładają masę prawdopodobieństwa błędów. Jeśli interesuje
nas natomiast estymacja kwantyli warunkowych (tj. prostej która najlepiej dzieli
obserwacje tak aby odpowiedni ułamek z nich znalazł się pod nią), to możemy
wykorzystać asymetryczny rozkład Laplace'a. Otrzymany model nazywamy wówczas
kwantylową regresją liniową (ang. _quantile linear regression_).

Przyjmijmy obecnie, że dysponujemy zbiorem obserwacji
$cal(X) = {(y_i, bold(x)_i)}_(i=1)^n$. Zakładamy, że obserwacje te są i.i.d. ---
niezależne i pochodzące z tego samego rozkładu
$y_i ~ cal(N)(phi(bold(x)_i; bold(w)), sigma^2)$. Jawne wnioskowanie Bayesowskie
możliwe jest również dla regresji liniowej. Bardzo często jednak stosuje się
prostsze podejście adekwatne również do pozostałych dwóch modeli. Otóż
poszukujemy jedynie estymaty punktowe parametrów $bold(w)$, ignorując
niepewność ich oszacowania. Taką estymację punktową można wyznaczyć _metodą
największej wiarygodności_ (ang. _maximum likelihood estimation_ (MLE)),
$
  bold(w)_"MLE" = arg max_bold(w) p(cal(X) | bold(w)) quad.
$
Korzystamy wówczas jedynie z wiarygodności $p(cal(X) | bold(w))$. Z założenia,
iż obserwacje są i.i.d., możemy łatwo wyznaczyć wiarygodność
$
  p(cal(X) | bold(w)) & = product_(i=1)^n
                          cal(N)(y_i; phi(bold(x)_i; bold(w)), sigma^2) \
                      & prop product_(i=1)^n
                          exp(- (y_i - phi(bold(x)_i; bold(w)))^2 / (2sigma^2))
                          quad,
$
gdzie pominęliśmy współczynnik, gdyż nie ma on wpływu na zagadnienie
optymalizacji. W praktyce często łatwiej jest minimalizować sumę pewnych wyrażeń,
niż ich iloczyn, dlatego wprowadzamy _zanegowaną logarytmiczną funkcję
wiarygodności_ (ang. _negated log-likelihood function_ (NLL)),
$
  L(cal(X), bold(w)) = - log p(cal(X) | bold(w)) quad,
$
gdzie korzystamy oczywiście z faktu, iż logarytm (naturalny) jest funkcją ściśle
rosnącą. Estymatę MLE możemy wówczas znaleźć jako
$
  bold(w)_"MLE" = arg min_bold(w) L(cal(X), bold(w)) quad.
$
W przypadku regresji liniowej otrzymujemy
$
  bold(w)_"MLE" = arg min_bold(w) 1 / 2 sum_(i=1)^n
  (y_i - phi(bold(x)_i; bold(w)))^2 quad.
$
Z powyższego problemu optymalizacyjnego wynika popularna nazwa tej formy
regresji liniowej --- _metoda najmniejszych kwadratów_ (ang. _Ordinary Least
Squares_ (OLS)), ponieważ minimalizujemy sumę kwadratów rezyduów. W tym
szczególnym przypadku postać $bold(w)_"MLE"$ można znaleźć analitycznie.
Istotnie wprowadźmy
$
  bold(y) = mat(y_1; dots.v; y_n) quad, quad
  bold(X) = mat(bold(x)_1^top; dots.v; bold(x)_n^top) quad, quad
  bold(phi) = bold(X) bold(w) quad.
$
Wówczas mamy
$
  (partial L) / (partial phi_beta) = (phi_beta - y_beta)
$
oraz dalej
$
  (partial L) / (partial w_alpha) = sum_(beta=1)^n
  (partial L) / (partial phi_beta) (partial phi_beta) / (partial w_alpha) =
  sum_(beta=1)^n (phi_beta - y_beta) X_(beta alpha) quad.
$
Z warunków koniecznych dla minimum lokalnego mamy
$forall alpha : (partial L) / (partial w_alpha) = 0$, co możemy zapisać jako
$
  bold(X)^top (bold(phi) - bold(y)) =
  bold(X)^top (bold(X) bold(w)_"MLE" - bold(y)) = bold(0) quad,
$
skąd
$
  bold(w)_"MLE" = (bold(X)^top bold(X))^(-1) bold(X)^top bold(y) quad.
$
Wielkość $(bold(X)^top bold(X))^(-1) bold(X)^top$ nazywa się pseudoodwrotnością
Moore'a--Penrose macierzy $bold(X)$. Warto tutaj zaznaczyć, iż w praktyce rzadko
wyznaczamy $bold(w)_"MLE"$ korzystając wprost z powyższego wzoru, ze względu na
dość słabe własności numeryczne. Typowo jeśli macierz $bold(X)$ jest niewielka,
to pseudoodwrotność obliczamy korzystając z rozkładu SVD macierzy $bold(X)$.
Natomiast dla dużych macierzy nie korzystamy ze wzoru analitycznego, tylko z
metody iteracyjnej stochastycznego spadku wzdłuż gradientu,
$
  w_alpha^((t+1)) = w_alpha^((t)) - eta (partial L) / (partial w_alpha) quad,
$
która w tym przypadku zbiega do minimum globalnego $bold(w)_"MLE"$.

== Regresja Bayesowska

Pokażemy teraz, jak przeprowadzić pełne wnioskowanie Bayesowskie dla modelu
regresji liniowej. Założymy rozkład a priori nad parametrami $bold(w)$ w postaci
rozkładu normalnego
$
  bold(w) ~ cal(N)(bold(mu)_0, bold(Sigma)_0) quad.
$
Wiarygodność, jak pokazaliśmy powyżej, ma natomiast postać
$
  cal(X) | bold(w) ~ cal(N)(bold(X) bold(w), sigma^2 bold(I)) quad.
$
Zauważmy, że jest to instancja modelu liniowego, więc korzystając z
wyprowadzonych wzorów wiemy, iż
$
  bold(w) | cal(X) ~ cal(N)(bold(mu)_n, bold(Sigma)_n) quad,
$
gdzie
$
  bold(mu)_n & = bold(Sigma)_n (1 / sigma^2 bold(X)^top bold(y) +
                 bold(Sigma)_0^(-1) bold(mu)_0) quad, \
  bold(Sigma)_n & = (bold(Sigma)_0^(-1) + 1 / sigma^2 bold(X)^top bold(X))^(-1)
                    quad.
$
W powyższych wzorach nazwy parametrów nie są przypadkowe. Przed zaobserwowaniem
danych mamy rozkład a priori $bold(w) ~ cal(N)(bold(mu)_0, bold(Sigma)_0)$. Po
zaobserwowaniu $n$ przykładów aktualizujemy nasze przekonania w postaci rozkładu
a posteriori $bold(w) | cal(X) ~ cal(N)(bold(mu)_n, bold(Sigma)_n)$.

Znając rozkład a posteriori nad $bold(w)$ możemy również wyznaczyć rozkład
predykcyjny nad zmienną objaśnianą $y$ dla ustalonego wektora cech $bold(x)$.
Formalnie interesuje nas rozkład $p(y | cal(X))$. Rozkład ten możemy opisać w
następujący sposób:
$
  bold(w) | cal(X) & ~ cal(N)(bold(mu)_n, bold(Sigma)_n) quad, \
  y | bold(w) & ~ cal(N)(bold(w)^top bold(x), sigma^2) quad,
$
gdzie interesuje nas rozkład
$
  p(y | cal(X)) = integral p(y | bold(w)) p(bold(w) | cal(X)) dif bold(w) quad.
$
Można pokazać, iż rozkład ten jest rozkładem normalnym
$
  y | cal(X) ~ cal(N)(mu_y, sigma_y^2)
$
o parametrach
$
  mu_y = bold(mu)_n^top bold(x) quad, quad
  sigma_y^2 = sigma^2 + bold(x)^top bold(Sigma)_n bold(x) quad.
$

== Regresja grzbietowa

Rozważmy Bayesowską regresję liniową, w której prior ma postać
$bold(w) ~ cal(N)(0, tau^2 bold(I))$, czyli elementy wektora parametrów są
a priori wzajemnie niezależne, a ich amplitudy są rzędu $tau$. Znajdźmy estymatę
MAP parametrów $bold(w)$. Zauważmy, że
$
  - log p(bold(w) | cal(X)) prop [
    1 / (2sigma^2) sum_(i=1)^n (y_i - phi(bold(x)_i; bold(w)))^2 +
    1 / (2tau^2) norm(bold(w))_2^2
  ] quad.
$
Wyrażenie w nawiasach możemy przemnożyć przez $sigma^2$ --- nie wpłynie to na
położenie minimum, bo $sigma^2$ to dodatnia stała. Estymata MAP w tym modelu to
zatem
$
  bold(w)_"MAP" = arg min_bold(w) [
    1 / 2 sum_(i=1)^n (y_i - phi(bold(x)_i; bold(w)))^2 +
    gamma / 2 norm(bold(w))_2^2
  ] quad,
$
gdzie $gamma = sigma^2 / tau^2$ to _stała regularyzująca_. Pierwszy z członów to
znana z OLS suma kwadratów rezyduów, natomiast drugi człon to _człon
regularyzujący_ rozwiązanie, który ogranicza amplitudy parametrów (wag). Jest to
tzw. model _regresji grzbietowej_ (ang. _ridge regression_). Jest to
jednocześnie oczywiście moda rozkładu a posteriori, czyli w przypadku rozkładu
normalnego --- wyznaczony wcześniej parametr $bold(mu)_n$,
$
  bold(w)_"MAP" = (sigma^2 / tau^2 bold(I) + bold(X)^top bold(X))^(-1)
  bold(X)^top bold(y) quad.
$

== Regresja w ujęciu częstościowym

Podstawowym pytaniem, na które sama estymacja punktowa nie daje odpowiedzi w
przypadku modelu liniowego, jest: czy dany podzbiór współczynników jest istotny
statystycznie? Oczywiście w ujęciu Bayesowskim odpowiedzi na to pytanie udziela
rozkład a posteriori nad parametrami modelu. Chcemy mieć jednak również
klasyczną, częstościową argumentację. Niech $hat(y)_i$ będzie odpowiedzią modelu
dla cech $bold(x)_i$, a $y_i$ prawdziwą odpowiedzią. Wielkość
$
  "RSS" := sum_(i=1)^N (y_i - hat(y)_i)^2
$
nazywamy _rezydualną sumą kwadratów_ (ang. _residual sum of squares_). Wówczas
jeśli potrzebujemy testu sprawdzającego istotność podzbioru współczynników,
tzn. testujemy hipotezę
$
  H_0 : w_(i_1) = 0, ..., w_(i_q) = 0 quad,
$
to odpowiednią statystyką testową jest
$
  ("RSS"_0 - "RSS") / "RSS" dot (n - p - 1) / q ~ F(q, n - p - 1) quad,
$
gdzie $"RSS"_0$ oznacza rezydualną sumę kwadratów dla modelu spełniającego
$H_0$, $F$ oznacza rozkład F Snedecora, natomiast $p$ to liczba wszystkich
parametrów modelu.

Korzystając z metod częstościowych możemy również podać przedział ufności na
poziomie $1 - alpha$ przy przewidywaniu odpowiedzi dla nieznanej wartości
$bold(x)_0$ jako
$
  hat(bold(w))^top bold(x)_0 plus.minus t_(1 - alpha/2, n - p - 1)
  hat(sigma)^2 sqrt(bold(x)_0^top (bold(X)^top bold(X))^(-1) bold(x)_0) quad,
$
gdzie
$
  hat(sigma)^2 = "RSS" / (n - p - 1) quad,
$
natomiast $t_(1 - alpha/2, n - p - 1)$ jest kwantylem rzędu $1 - alpha / 2$
rozkładu t Studenta z parametrem $n - p - 1$.

== Predyktory jakościowe

Zmienne jakościowe, które mają być użyte jako predyktory w regresji liniowej,
wymagają reprezentacji numerycznej. Typowo stosowanym kodowaniem jest kodowanie
za pomocą tzw. _dummy variables_ w taki sposób, że zmienna jakościowa o $k$
poziomach jest kodowana jako wektor binarny o $k - 1$ składowych (aby uniknąć
tzw. _dummy variable trap_ --- naiwny one-hot-encoding powoduje redundancję w
postaci liniowej zależności składowych wektora kodującego $x_1 + ... + x_k = 1$).
Przykładowo dla zmiennej jakościowej
$sans("ShelveLoc") in {sans("Bad"), sans("Medium"), sans("Good")}$ tworzymy
wektor binarny o dwóch składowych: $sans("ShelveLocBad") in {0, 1}$,
$sans("ShelveLocGood") in {0, 1}$. Wektor $(0, 0)$ reprezentuje wówczas wartość
$sans("Medium")$ zmiennej $sans("ShelveLoc")$.

== Ocena jakości dopasowania

Najpopularniejszymi miarami dopasowania modelu są:
- RSE (ang. _residual standard error_) zdefiniowany jako
  $sqrt("RSS" / (n - p - 1))$,
- Ułamek wariancji wyjaśnionej przez model
  $
    R^2 := 1 - "RSS" / "TSS" quad, quad "TSS" = sum_(i=1)^n (y_i - overline(y))^2 quad,
  $
  który powinien być jak najbliższy $1$.

Należy pamiętać, iż powyższe miary dopasowania _nie_ są dobrymi miarami przy
porównywaniu modeli o _różnej_ liczbie predyktorów (jeśli liczymy te miary na
zbiorze treningowym). Aby poradzić sobie z tym problemem mamy dwie opcje: metody
bezpośrednie, w których estymujemy błąd testowy za pomocą walidacji krzyżowej lub
metody holdout, lub metody pośrednie, w których wprowadzamy poprawki do błędu
treningowego. W szczególności miarami pośrednimi są:
- adjusted $R^2$ obliczany jako $1 - ("RSS"(n - 1)) / ("TSS"(n - p - 1))$,
- kryterium Mallowa $C_p = 1 / n ("RSS" + 2 p hat(sigma)^2)$.

= Uogólnione modele liniowe

Prosty model regresji liniowej może posłużyć nam jako wzór do tworzenia bardziej
skomplikowanych modeli statystycznych. Formalnie dowolny model statystyczny jest
uogólnionym modelem liniowym (ang. _Generalized Linear Model, GLM_), jeśli
zachodzi:
1. Parametry $bold(beta)$ modelu są związane z wektorem $bold(x)$ jedynie
   poprzez tzw. _składnik systematyczny_ $bold(beta)^top bold(x)$ (jest to zatem
   model liniowy).

2. Rozkład $y | bold(x), bold(beta)$ pochodzi z ustalonej wykładniczej rodziny
   rozkładów $P(theta, tau)$ z parametrami $theta, tau$ o gęstości danej przez
   $
     p(z; theta, tau) = exp[(theta z - f(theta)) / (d(tau)) + k(z, tau)] quad,
   $
   dla pewnych funkcji $f, d, k$.

3. Parametr $theta$ jest związany ze składnikiem systematycznym równością
   $
     g(f'(theta)) = bold(beta)^top bold(x)
   $
   dla pewnej funkcji wiążącej $g$.

== Regresja logistyczna

Rozpatrzymy teraz problem klasyfikacji binarnej z perspektywy estymacji MLE.
Niech $cal(X) = {t_i (bold(x)_i)}_(i=1)^n$ będzie zbiorem obserwacji i.i.d.,
gdzie zakładamy, iż $t in {0, 1}$. Jako model statystyczny przyjmiemy, iż klasa
$t(bold(x))$ pochodzi z rozkładu Bernoulliego z parametrem
$pi(bold(x); bold(w))$ (prawdopodobieństwem klasy pozytywnej, gdzie $pi$ jest
tzw. funkcją wiążącą, ang. _link function_) zależnym od estymowanych parametrów
$bold(w)$,
$
  t | bold(x), bold(w) ~ "Ber"(pi(bold(x); bold(w))) quad.
$
W przypadku regresji logistycznej jako funkcję $pi(bold(x); bold(w))$ przyjmiemy
$sigma(phi(bold(x); bold(w)))$, gdzie
$
  sigma(z) = 1 / (1 + e^(-z))
$
to tzw. _funkcja logistyczna_ (będąca szczególnym przypadkiem funkcji
sigmoidalnej), natomiast $phi(bold(x); bold(w))$ może być dowolną funkcją
wykorzystywaną do zagadnienia regresji. W przypadku regresji logistycznej
przyjmujemy prosty model liniowy
$
  phi(bold(x); bold(w)) = bold(w)^top bold(x) quad.
$
Zauważmy, iż taka postać uwzględnia człon stały poprzez podstawienie
$bold(x)^top <- mat(bold(x)^top, 1)$. Wiarygodność dla powyższego modelu
statystycznego ma postać
$
  p(cal(X) | bold(w)) = product_(i=1)^n pi(bold(x)_i; bold(w))^(t_i)
  (1 - pi(bold(x)_i; bold(w)))^(1 - t_i) quad,
$
skąd funkcja NLL ma postać
$
  L(cal(X); bold(w)) = - sum_(i=1)^n [
    t_i log pi_i + (1 - t_i) log(1 - pi_i)
  ] quad,
$
gdzie $pi_i = pi(bold(x)_i; bold(w))$. Taką funkcję kosztu nazywamy _binarną
entropią krzyżową_ (ang. _binary cross-entropy function_). Niestety dla takiej
postaci funkcji kosztu nie można znaleźć minimum w postaci analitycznej (jak
zrobiliśmy w przypadku regresji liniowej), dlatego musimy wykorzystywać
algorytmy optymalizacji numerycznej, które najczęściej wykorzystują pierwsze
pochodne funkcji kosztu po parametrach. Typowo wykorzystywanym do tego celu
algorytmem jest _spadek wzdłuż gradientu_ (ang. _gradient descent_), w którym
iteracyjnie wykonujemy
$
  bold(w)_(t+1) = bold(w)_t - eta (partial L) / (partial bold(w)) |_(bold(w)_t)
  quad.
$
Wyznaczymy więc pochodne funkcji $L$ po parametrach $bold(w)$. Wprowadźmy macierz
$X_(alpha beta) = x_beta^((alpha))$ oraz wektory
$phi_alpha = phi(bold(x)_alpha; bold(w))$, $sigma_alpha = sigma(phi_alpha)$.
Wówczas
$
  L(cal(X); bold(w)) = - sum_(alpha=1)^n [
    t_alpha log sigma_alpha + (1 - t_alpha) log(1 - sigma_alpha)
  ] quad.
$
W takim razie mamy
$
  (partial L) / (partial phi_alpha) = sum_(beta=1)^n
  (partial L) / (partial sigma_beta) (partial sigma_beta) / (partial phi_alpha)
  quad,
$
gdzie
$
  (partial L) / (partial sigma_beta) =
  (1 - t_beta) / (1 - sigma_beta) - t_beta / sigma_beta
$
oraz
$
  (partial sigma_beta) / (partial phi_alpha) =
  sigma'(phi_beta) delta_(alpha beta) quad,
$
gdzie
$
  sigma'(z) = e^(-z) / (1 + e^(-z))^2 = sigma(z)(1 - sigma(z)) quad,
$
zatem
$
  (partial L) / (partial phi_alpha) = (
    (1 - t_alpha) / (1 - sigma_alpha) - t_alpha / sigma_alpha
  ) sigma_alpha (1 - sigma_alpha) = sigma_alpha - t_alpha quad.
$
W takim razie, z powyższego mamy
$
  (partial L) / (partial w_alpha) = sum_(beta=1)^n
  (partial L) / (partial phi_beta) (partial phi_beta) / (partial w_alpha) =
  sum_(beta=1)^n (sigma_beta - t_beta) X_(beta alpha) quad,
$
co możemy zapisać w zwartej postaci macierzowej
$
  (partial L) / (partial bold(w)) = bold(X)^top (bold(sigma) - bold(t)) quad.
$

== Wieloklasowa regresja logistyczna

Regresję logistyczną możemy w prosty sposób uogólnić na przypadek klasyfikacji
jednej z $k$ klas. Zakładamy teraz, iż zbiór obserwacji i.i.d. ma postać
$cal(X) = {t_i (bold(x)_i)}_(i=1)^n$ dla $t in {1, ..., k}$. Nasz model
statystyczny uogólnimy do postaci rozkładu kategorialnego (ang. _categorical
distribution_ lub _multinomial distribution_) z parametrem
$bold(pi)(bold(x); bold(W))$ (wektorem prawdopodobieństw każdej klasy) zależnym
od estymowanych parametrów $bold(W)$,
$
  t | bold(x), bold(W) ~ "Cat"(bold(pi)(bold(x); bold(W))) quad.
$
W przypadku regresji softmax jako funkcję $bold(pi): RR^m -> [0, 1]^k$
przyjmiemy funkcję $bold(sigma)(bold(phi)(bold(x); bold(W)))$, gdzie
$bold(sigma): RR^k -> [0, 1]^k$,
$
  sigma_alpha (bold(z)) = exp(z_alpha) / (sum_(beta=1)^k exp(z_beta))
$
to tzw. _funkcja softmax_, natomiast $bold(phi): RR^m -> RR^k$ to dowolna
funkcja. W przypadku regresji softmax przyjmiemy prosty model liniowy
$
  bold(phi)(bold(x); bold(W)) = bold(W) bold(x) quad.
$
Wiarygodność dla powyższego modelu ma postać
$
  product_(alpha=1)^n product_(beta=1)^k pi_(alpha beta)^(t_(alpha beta)) quad,
$
skąd funkcja NLL ma postać
$
  L(cal(X); bold(W)) = - sum_(alpha=1)^n sum_(beta=1)^k
  t_(alpha beta) log pi_(alpha beta) quad,
$
gdzie
$
  pi_(alpha beta) & = sigma_beta (bold(phi)(bold(x)_alpha; bold(W))) =
                    (exp phi_(alpha beta)) / (sum_(gamma=1)^k exp phi_(alpha gamma)) quad, \
  phi_(alpha beta) & = phi_beta (bold(x)_alpha; bold(W)) quad, \
  t_(alpha beta) & = [t_alpha = beta] quad.
$
Wiersze macierzy $bold(t)$ są binarnymi wektorami kodującymi w sposób one-hot
klasę danego przykładu. Niestety dla takiej postaci funkcji kosztu nie można
znaleźć minimum w postaci analitycznej, dlatego musimy wykorzystywać algorytmy
optymalizacji numerycznej. Wyznaczymy więc jeszcze pierwsze pochodne funkcji $L$
po parametrach $bold(W)$,
$
  (partial L) / (partial pi_(beta beta')) = - t_(beta beta') / pi_(beta beta')
  quad.
$
Jednocześnie mamy
$
  (partial L) / (partial phi_(alpha alpha')) =
  sum_(beta=1)^n sum_(beta'=1)^k
  (partial L) / (partial pi_(beta beta'))
  (partial pi_(beta beta')) / (partial phi_(alpha alpha')) quad,
$
gdzie
$
  (partial pi_(beta beta')) / (partial phi_(alpha alpha'))
  & = (exp phi_(beta beta') delta_(alpha beta) delta_(alpha' beta')) /
      (sum_(gamma=1)^k exp phi_(beta gamma)) -
      (exp phi_(beta beta') exp phi_(beta alpha') delta_(alpha beta)) /
      (sum_(gamma=1)^k exp phi_(beta gamma))^2 \
  & = pi_(beta beta') delta_(alpha beta) delta_(alpha' beta') -
      pi_(beta beta') pi_(beta alpha') delta_(alpha beta) quad.
$
Z powyższego mamy zatem
$
  (partial L) / (partial phi_(alpha alpha')) =
  pi_(alpha alpha') sum_(beta'=1)^k t_(alpha beta') - t_(alpha alpha') =
  pi_(alpha alpha') - t_(alpha alpha') quad.
$
Ostatecznie zatem
$
  (partial L) / (partial W_(beta beta')) =
  sum_(alpha=1)^n sum_(alpha'=1)^k
  (partial L) / (partial phi_(alpha alpha'))
  (partial phi_(alpha alpha')) / (partial W_(beta beta')) quad,
$
gdzie
$
  (partial phi_(alpha alpha')) / (partial W_(beta beta')) =
  X_(alpha beta') delta_(alpha' beta) quad,
$
zatem
$
  (partial L) / (partial W_(beta beta')) =
  sum_(alpha=1)^n (pi_(alpha beta) - t_(alpha beta)) X_(alpha beta') quad,
$
co możemy zapisać w zwartej postaci macierzowej
$
  (partial L) / (partial bold(W)) = (bold(pi) - bold(t))^top bold(X) quad.
$

== Regresja probitowa

Regresja probitowa to model analogiczny do regresji logistycznej, w którym jako
funkcję wiążącą przyjmujemy
$
  pi(bold(x); bold(w)) = Phi(bold(w)^top bold(x)) quad,
$
gdzie $Phi$ jest dystrybuantą standardowego, jednowymiarowego rozkładu
normalnego. Taki model możemy traktować jako model ze _zmienną ukrytą_ (ang.
_latent variable_)
$
  h | bold(x), bold(w) ~ cal(N)(bold(w)^top bold(x), 1) quad,
$
która wyznacza obserwowalną zmienną odpowiedzi jako
$
  t = cases(
    1 & quad "jeśli" h > 0 \,,
    0 & quad "w.p.p."
  )
$

== Regresja Poissonowska

Regresja Poissonowska to podstawowy model dla danych zliczeniowych, w których
zmienna objaśniana $t$ przyjmuje dowolne wartości naturalne $t in NN$. Jest to
zasadniczo model postaci
$
  t | bold(x), bold(w) ~ "Pois"(e^(bold(w)^top bold(x))) quad.
$
Zanegowana logarytmiczna funkcja wiarygodności ma dla tego modelu postać
$
  L(cal(X); bold(w)) = - sum_(i=1)^n (
    t_i bold(w)^top bold(x)_i - e^(bold(w)^top bold(x)_i)
  ) quad,
$
pamiętając, iż funkcja masy prawdopodobieństwa dla rozkładu Poissona to
$
  P(Y = k; lambda) = lambda^k / (k!) e^(-lambda) quad.
$

== Regresja porządkowa

Regresja porządkowa to podstawowy model w przypadku, w którym zmienna
objaśniana $t$ przyjmuje wartości z _liniowo uporządkowanego zbioru_, o którym
bez straty ogólności założymy, iż ma postać ${1, 2, ..., k}$. Regresja
porządkowa może być rozumiana jako model klasyfikacyjny, ale ze względu na
nacisk na zachowanie porządku etykiet przypomina też regresję całkowitoliczbową
(Poissona). Jest to zasadniczo model postaci
$
  t | bold(x), bold(w), theta_1, ..., theta_(k-1) ~
  "Cat"(pi_1 (bold(x); bold(w), bold(theta)), ...,
    pi_k (bold(x); bold(w), bold(theta))) quad,
$
gdzie
$
  pi_alpha (bold(x); bold(w), bold(theta)) :=
  Phi(theta_alpha - bold(w)^top bold(x)) -
  Phi(theta_(alpha-1) - bold(w)^top bold(x))
$
dla $theta_0 = -infinity < theta_1 < dots.c < theta_(k-1) < theta_k = +infinity$
i $Phi$ będącego dystrybuantą standardowego, jednowymiarowego rozkładu
normalnego. Zauważmy, że przy takim wyborze funkcji $pi_alpha$ zachodzi wymagany
warunek
$
  sum_(alpha=1)^k pi_alpha (bold(x); bold(w), bold(theta))
  & = Phi(theta_k - bold(w)^top bold(x)) -
      Phi(theta_0 - bold(w)^top bold(x)) \
  & = Phi(+infinity) - Phi(-infinity) = 1 quad.
$
Parametry modelu $bold(w)$ i $bold(theta)$ są estymowane metodą największej
wiarygodności. Zauważmy, że możemy ten model interpretować jako model ze
_zmienną ukrytą_ (ang. _latent variable_)
$
  h | bold(x), bold(w) ~ cal(N)(bold(w)^top bold(x), 1) quad,
$
która wyznacza obserwowaną odpowiedź modelu $t$ zgodnie z
$
  t = cases(
    1 & quad "jeśli" theta_0 < h <= theta_1 \,,
    2 & quad "jeśli" theta_1 < h <= theta_2 \,,
    dots.v \,,
    k & quad "jeśli" theta_(k-1) < h <= theta_k \,.
  )
$

= Wprowadzenie do procesów Gaussowskich

Macierz kowariancji $n$-wymiarowej zmiennej losowej $bold(x)$ o wartości
oczekiwanej $bold(mu)$ jest zdefiniowana jako
$
  bold(Sigma) = EE[(bold(x) - bold(mu))(bold(x) - bold(mu))^top] quad.
$
Wiemy również, iż macierz ta jest nieujemnie określona. Pokażemy teraz, iż dla
każdej nieujemnie określonej macierzy symetrycznej $bold(K)$ wymiaru
$n times n$ istnieje $n$-wymiarowa zmienna losowa o wielowymiarowym rozkładzie
normalnym, dla której $bold(K)$ jest macierzą kowariancji. Istotnie dla każdej
nieujemnie określonej macierzy symetrycznej istnieje macierz $bold(L)$ taka, że
$
  bold(K) = bold(L) bold(L)^top quad,
$
jest to tzw. _dekompozycja Choleskiego_. Niech
$bold(z) ~ cal(N)(bold(0), bold(1))$, wówczas zmienna losowa $bold(L) bold(z)$
ma rozkład o zerowej wartości oczekiwanej i macierzy kowariancji
$
  EE[(bold(L) bold(z))(bold(L) bold(z))^top] =
  bold(L) EE[bold(z) bold(z)^top] bold(L)^top =
  bold(L) bold(1) bold(L)^top = bold(K) quad.
$
Powyższe własności wskazują, iż macierze kowariancji można w pewnym sensie
utożsamiać z nieujemnie określonymi macierzami symetrycznymi.

Funkcję $k: RR^n times RR^n -> RR$ taką, że
$forall m in NN : forall X = {bold(x)_1, ..., bold(x)_m} subset RR^n$ macierz
$
  k(X, X) = mat(
    k(bold(x)_1, bold(x)_1), k(bold(x)_1, bold(x)_2), dots.c, k(bold(x)_1, bold(x)_m);
    k(bold(x)_2, bold(x)_1), k(bold(x)_2, bold(x)_2), dots.c, k(bold(x)_2, bold(x)_m);
    dots.v, dots.v, dots.down, dots.v;
    k(bold(x)_m, bold(x)_1), k(bold(x)_m, bold(x)_2), dots.c, k(bold(x)_m, bold(x)_m)
  )
$
jest dodatnio określoną macierzą symetryczną nazywamy funkcją kowariancji,
jądrem dodatnio określonym (ang. _positive definite kernel_) lub _jądrem
Mercera_.

Dla dwóch zbiorów punktów $X = {bold(x)_1, ..., bold(x)_m} subset RR^n$ i
$Y = {bold(y)_1, ..., bold(y)_s} subset RR^n$ i funkcji kowariancji $k$
wprowadzimy oznaczenie
$
  k(X, Y) := mat(
    k(bold(x)_1, bold(y)_1), k(bold(x)_1, bold(y)_2), dots.c, k(bold(x)_1, bold(y)_s);
    k(bold(x)_2, bold(y)_1), k(bold(x)_2, bold(y)_2), dots.c, k(bold(x)_2, bold(y)_s);
    dots.v, dots.v, dots.down, dots.v;
    k(bold(x)_m, bold(y)_1), k(bold(x)_m, bold(y)_2), dots.c, k(bold(x)_m, bold(y)_s)
  ) quad.
$
Poniżej podajemy kilka przykładów funkcji kowariancji:
- _Gaussian kernel_ dla normy $norm(dot)$ i hiperparametrów $a, l$ (amplituda i
  skala długości),
  $
    k(bold(x), bold(y)) = a^2 exp{- 1 / (2 l^2) norm(bold(x) - bold(y))^2} quad,
  $

- _Periodic kernel_ dla normy $norm(dot)$ i hiperparametrów $a, l, p$
  (amplituda, skala długości, okres zmienności),
  $
    k(bold(x), bold(y)) = a^2 exp{- 2 / l^2 sin^2(pi / p norm(bold(x) - bold(y)))}
    quad,
  $

- _White noise kernel_ dla hiperparametru $sigma$,
  $
    k(bold(x), bold(y)) = sigma^2 delta_(bold(x), bold(y)) quad,
  $

- _Matérn kernel_ dla normy $norm(dot)$ i hiperparametrów $a, l, nu$ (amplituda,
  skala długości, regularność),
  $
    k(bold(x), bold(y)) = a^2 (2^(1 - nu)) / Gamma(nu)
    (sqrt(2 nu) / l norm(bold(x) - bold(y)))^nu
    K_nu (sqrt(2 nu) / l norm(bold(x) - bold(y))) quad,
  $
  gdzie $Gamma(x)$ to funkcja gamma Eulera, a $K_nu (x)$ to zmodyfikowana
  funkcja Bessela 2-go rodzaju rzędu $nu$.

Suma lub iloczyn dwóch funkcji kowariancji oraz złożenie funkcji kowariancji z
wielomianem o nieujemnych współczynnikach jest również funkcją kowariancji.

Procesem Gaussowskim (ang. _Gaussian Process_) nazywamy rodzinę skalarnych
zmiennych losowych indeksowanych przez punkty $bold(x) in RR^n$,
$
  cal(G P) = {f_bold(x) | bold(x) in RR^n} quad,
$
taką, że każdy skończony podzbiór $cal(G P)$ ma łącznie wielowymiarowy rozkład
normalny, tj. dla dowolnego zbioru
$X = {bold(x)_1, ..., bold(x)_m} subset RR^n$ zachodzi
$
  mat(f_(bold(x)_1); dots.v; f_(bold(x)_m)) ~
  cal(N)(bold(mu)_X, bold(Sigma)_X) quad.
$

Zauważmy, iż proces Gaussowski możemy jednoznacznie zdefiniować podając przepisy
na parametry $bold(mu)_X$ i $bold(Sigma)_X$ dla dowolnego zbioru $X$. W praktyce
często przyjmujemy $bold(mu)_X = bold(0)$, natomiast przepisem na macierz
kowariancji może być zdefiniowana wyżej funkcja kowariancji $k(X, X)$, tj.
$
  mat(f_(bold(x)_1); dots.v; f_(bold(x)_m)) ~
  cal(N)(bold(0), k(X, X)) quad.
$
Proces Gaussowski daje nam w praktyce rozkład prawdopodobieństwa nad funkcjami
$f: RR^n -> RR$, których charakter jest określony przez jądro $k$ (np. funkcja
gładka dla jądra Gaussowskiego, okresowa dla jądra periodycznego itp.). Zauważmy,
że nie wnioskujemy tu o parametrach konkretnej rodziny funkcji (jak w przypadku
regresji liniowej); interesuje nas jedynie rozkład predykcyjny. Załóżmy, iż w
dokładnie znanych przez nas punktach $X = {bold(x)_1, bold(x)_2, ..., bold(x)_m}$
zaobserwowaliśmy wartości pewnej funkcji, o których zakładamy, iż pochodzą z
procesu Gaussowskiego zadanego jądrem $k$, które wyraża nasze założenia a priori
co do charakteru badanej funkcji,
$
  bold(f)_X = mat(f_(bold(x)_1); dots.v; f_(bold(x)_m)) ~
  cal(N)(bold(0), k(X, X)) quad.
$
Powiedzmy, iż chcemy znać wartości $bold(f)_Y$ tej funkcji w zadanych punktach
$Y = {bold(y)_1, bold(y)_2, ..., bold(y)_s}$. Ponieważ założyliśmy, iż wartości
funkcji pochodzą z procesu Gaussowskiego, więc rozkład łączny $bold(f)_X$ i
$bold(f)_Y$ jest rozkładem normalnym
$
  mat(bold(f)_X; bold(f)_Y) ~ cal(N)(
    bold(0),
    mat(k(X, X), k(X, Y); k(Y, X), k(Y, Y))
  ) quad.
$
Zauważmy, iż z twierdzenia o własnościach niezdegenerowanego rozkładu normalnego
wnioskujemy, iż rozkład warunkowy $bold(f)_Y | bold(f)_X$ jest również
rozkładem normalnym o parametrach
$
  bold(mu) & = k(Y, X) k^(-1)(X, X) bold(f)_X quad, \
  bold(Sigma) & = k(Y, Y) - k(Y, X) k^(-1)(X, X) k(X, Y) quad.
$
Dodatkową niepewność związaną z pomiarem wartości $bold(f)_X$ możemy uchwycić
zmieniając postać jądra
$
  k(bold(x), bold(y)) <- k(bold(x), bold(y)) +
  cal(I)_X (bold(x)) sigma^2 delta_(bold(x), bold(y)) quad,
$
gdzie $sigma$ jest hiperparametrem określającym precyzję pomiaru. Oczywiście $k$
jest dalej funkcją kowariancji, gdyż takie podstawienie powoduje jedynie dodanie
dodatnich członów do pewnych elementów diagonalnych macierzy kowariancji, więc
macierz ta jest nadal symetryczna i dodatnio określona. Wówczas rozkład
predykcyjny ma parametry
$
  bold(mu) & = k(Y, X) [k(X, X) + sigma^2 bold(1)]^(-1) bold(f)_X quad, \
  bold(Sigma) & = k(Y, Y) - k(Y, X) [k(X, X) + sigma^2 bold(1)]^(-1) k(X, Y)
                  quad.
$

= Liczby losowe w komputerze

Opiszemy teraz pokrótce metody generowania liczb pseudolosowych z dowolnych
rozkładów prawdopodobieństwa w sposób algorytmiczny. Podstawowym narzędziem,
którego będziemy potrzebować do generowania próbek z bardziej skomplikowanych
rozkładów będzie prosty generator liczb z rozkładu jednostajnego $cal(U)(0, 1)$.
Moglibyśmy oczywiście wykorzystać jakieś fizyczne urządzenie lub proces, który
generuje liczby prawdziwie losowe (np. detektor Geigera--Müllera, szum lamp
elektronowych, ruletka), ale błędem byłaby rezygnacja z odtwarzalności.
Poszukujemy zatem deterministycznej metody, która generuje sekwencje liczb,
które są w przybliżeniu losowe. Podstawową metodą do algorytmicznego generowania
liczb pseudolosowych jest tzw. _liniowy generator kongruentny_ (ang. _Linear
Congruential Generator, LCG_), który jest opisany zależnością rekurencyjną
$
  I_(j+1) = (a I_j + c) mod m quad,
$
gdzie $a, c, m$ to pewne ustalone dodatnie liczby całkowite, a $I_0$ to tzw.
ziarno (ang. _seed_). LCG generuje liczby całkowite, więc w dużym uproszczeniu
liczby zmiennoprzecinkowe z rozkładu $cal(U)(0, 1)$ otrzymujemy jako $I_j / m$
(trzeba tutaj jednak uwzględnić problemy wynikające z arytmetyki
zmiennoprzecinkowej).

== Metoda odwrotnej dystrybuanty

Mając już generator liczb z rozkładu jednostajnego $cal(U)(0, 1)$ i znając
jawny wzór na dystrybuantę $F(x)$ innego rozkładu jednowymiarowego możemy
generować liczby z tego rozkładu korzystając z tzw. _metody odwrotnej
dystrybuanty_. Istotnie, jeśli $U ~ cal(U)(0, 1)$, to $F^(-1)(U) ~ F$. Istotnie
$
  Pr(F^(-1)(U) <= x) = Pr(U <= F(x)) = F(x) quad.
$
Metoda ta ma jedną zasadniczą wadę --- musimy znać jawny wzór na dystrybuantę
$F$. W przypadku np. tak ważnych rozkładów, jak rozkład normalny, dystrybuanta
nie jest funkcją elementarną i metoda ta nie jest najlepsza.

== Metoda Boxa--Mullera

W przypadku rozkładu normalnego znacznie lepszą metodą jest tzw. _metoda
Boxa--Mullera_. Weźmy rozkład łączny dwóch niezależnych zmiennych losowych
$X, Y$ pochodzących ze standardowego rozkładu normalnego,
$
  p(x, y) = 1 / (2pi) exp(- 1 / 2 (x^2 + y^2)) quad.
$
Skorzystamy ze wzoru na transformację zmiennych losowych. Istotnie niech
$
  X = sqrt(Z) cos Phi quad, quad Y = sqrt(Z) sin Phi quad,
$
dla $0 < Z$ oraz $0 <= Phi < 2pi$, wówczas
$
  q(z, phi) = 1 / (4pi) exp(- z / 2) quad.
$
Zauważmy, że otrzymaliśmy sferycznie symetryczny rozkład wykładniczy. Możemy
zatem wylosować kąt $phi$ z rozkładu jednostajnego oraz wartość $z$ z rozkładu
wykładniczego korzystając z metody odwrotnej dystrybuanty. Wówczas wartości
$x = sqrt(z) cos phi$, $y = sqrt(z) sin phi$ będą pochodzić ze standardowego
rozkładu normalnego. Aby wygenerować próbki z ogólnego wielowymiarowego rozkładu
normalnego, korzystamy z definicji, tj. najpierw generujemy $n$ próbek ze
standardowego rozkładu normalnego, a następnie korzystamy z przekształcenia
afinicznego $bold(x) = bold(A) bold(z) + bold(mu)$, gdzie
$bold(Sigma) = bold(A) bold(A)^top$.

== Monte Carlo

Umiemy już generować próbki z wielowymiarowego rozkładu normalnego. Chcemy teraz
poznać metodę, która umożliwi generowanie próbek ze skomplikowanych,
wielowymiarowych rozkładów prawdopodobieństwa, których gęstość znamy jedynie z
dokładnością do stałej normalizującej, tj. znamy jedynie
$tilde(p)(bold(x)) = Z p(bold(x))$. Ograniczenie to wynika z chęci próbkowania
z posteriora $p(bold(x) | bold(y))$ w sytuacji, gdy znamy jedynie rozkład
łączny $p(bold(x), bold(y)) = p(bold(y) | bold(x)) p_bold(X)(bold(x))$. Okazuje
się, iż znajomość rozkładu jedynie z dokładnością do stałej normalizującej jest
wystarczająca do generowania próbek z tego rozkładu. Generowanie próbek z kolei
wystarcza, na mocy silnego prawa wielkich liczb, do szacowania wartości średnich
dowolnych funkcji zmiennej $bold(x)$. Przypomnijmy, iż na mocy silnego prawa
wielkich liczb ciąg średnich częściowych $(overline(bold(X))_n)$ ciągu zmiennych
losowych $(bold(X)_n)$ i.i.d. z rozkładu $bold(X) ~ cal(D)$ jest zbieżny z
prawdopodobieństwem $1$ do wartości oczekiwanej $EE[bold(X)]$, tj.
$
  Pr(lim_(n -> infinity) overline(bold(X))_n = EE[bold(X)]) = 1 quad.
$
Wartość oczekiwaną $EE[bold(X)]$ możemy zatem przybliżyć średnią
$overline(bold(X))_n$ z dużej ilości próbek. Poniżej przedstawimy dwa algorytmy
próbkowania: algorytm IS oraz Metropolisa--Hastingsa będący szczególną
realizacją całej rodziny algorytmów próbkowania zwanych Markov Chain Monte
Carlo (MCMC).

=== Importance sampling

Załóżmy, iż chcemy obliczyć wartość oczekiwaną pewnej funkcji zmiennej losowej
$bold(x)$ względem skomplikowanego rozkładu prawdopodobieństwa $p(bold(x))$,
który znamy jedynie z dokładnością do stałej normalizującej
$
  p(bold(x)) = 1 / Z_p tilde(p)(bold(x)) quad,
$
tj. szukamy
$
  EE_(bold(x) ~ p(bold(x)))[f(bold(x))] =
  integral f(bold(x)) p(bold(x)) dif bold(x) quad.
$
Jeśli umiemy generować próbki $bold(x)$ z innego (prostszego) rozkładu
$q(bold(x))$ (np. wielowymiarowego rozkładu normalnego), który nazywamy
rozkładem proponującym kandydatów (ang. _proposal distribution_), to możemy
zapisać
$
  EE_(bold(x) ~ p(bold(x)))[f(bold(x))]
  & = integral f(bold(x)) p(bold(x)) dif bold(x) \
  & = integral f(bold(x)) (p(bold(x))) / (q(bold(x))) q(bold(x)) dif bold(x) \
  & = EE_(bold(x) ~ q(bold(x)))[f(bold(x)) (p(bold(x))) / (q(bold(x)))] \
  & = Z_q / Z_p EE_q [f(bold(x)) (tilde(p)(bold(x))) / (tilde(q)(bold(x)))]
      quad.
$
Zakładamy tutaj, iż nośnik rozkładu $p$ zawiera się w nośniku $q$, tj.
$"supp" p subset.eq "supp" q$. Stosunek stałych $Z_p / Z_q$ również możemy
oszacować z próbek z $q$, gdyż mamy
$
  Z_p = integral tilde(p)(bold(x)) dif bold(x) =
  Z_q integral (tilde(p)(bold(x))) / (tilde(q)(bold(x))) q(bold(x)) dif bold(x) =
  Z_q EE_(bold(x) ~ q(bold(x)))[(tilde(p)(bold(x))) / (tilde(q)(bold(x)))]
  quad,
$
skąd ostatecznie
$
  EE_(bold(x) ~ p(bold(x)))[f(bold(x))] =
  (EE_(bold(x) ~ q(bold(x)))[f(bold(x)) (tilde(p)(bold(x))) / (tilde(q)(bold(x)))]) /
  (EE_(bold(x) ~ q(bold(x)))[(tilde(p)(bold(x))) / (tilde(q)(bold(x)))]) quad.
$
Jeśli z rozkładu $q$ wygenerowaliśmy próbki
$X = {bold(x)_1, ..., bold(x)_m}$, to na mocy silnego prawa wielkich liczb mamy
$
  EE_(bold(x) ~ p(bold(x)))[f(bold(x))] approx
  (sum_(i=1)^m f(bold(x)_i) (tilde(p)(bold(x)_i)) / (tilde(q)(bold(x)_i))) /
  (sum_(j=1)^m (tilde(p)(bold(x)_j)) / (tilde(q)(bold(x)_j))) =
  sum_(i=1)^m lambda_i f(bold(x)_i) quad,
$
gdzie
$
  lambda_i =
  (tilde(p)(bold(x)_i) / tilde(q)(bold(x)_i)) /
  (sum_(j=1)^m tilde(p)(bold(x)_j) / tilde(q)(bold(x)_j)) quad.
$
Algorytm Importance Sampling jest prostym algorytmem Monte Carlo, który ma
jeden zasadniczy problem. W jaki sposób mamy wybrać rozkład proponujący
kandydatów $q$? Pewną odpowiedź na to pytanie sugeruje analiza wariancji
statystyki
$
  overline(f)_m (bold(x)_1, ..., bold(x)_m) = 1 / m sum_(i=1)^m
  (f(bold(x)_i) p(bold(x)_i)) / (q(bold(x)_i)) quad.
$
Dla $bold(x)_i ~ q$ mamy
$
  VV[overline(f)_m]
  & = 1 / m VV_q [f(bold(x)) (p(bold(x))) / (q(bold(x)))] \
  & = 1 / m integral ((f(bold(x)) p(bold(x)) - mu_f q(bold(x)))^2) /
      (q(bold(x))) dif bold(x) quad.
$
Chcemy oczywiście, aby wariancja była jak najmniejsza, gdyż wówczas mała liczba
próbek da dobre przybliżenie wartości oczekiwanej. Rozkład proponujący
kandydatów powinien być zatem proporcjonalny do $f(bold(x)) p(bold(x))$, co może
być trudne do praktycznego zrealizowania.

=== Algorytm Metropolisa--Hastingsa

Cała klasa algorytmów próbkowania MCMC opiera się na idei wyrażenia generowania
próbek jako ewolucji pewnego łańcucha Markowa.

Łańcuchem Markowa nazwiemy ciąg zmiennych losowych $(bold(X)_t)$ o wartościach
w $RR^n$ taki, że spełnione jest _kryterium Markowa_
$
  forall A subset RR^n : quad
  & Pr(bold(X)_t in A | bold(X)_(t-1) = bold(x)_(t-1), ...,
    bold(X)_0 = bold(x)_0) \
  & = Pr(bold(X)_t in A | bold(X)_(t-1) = bold(x)_(t-1)) quad.
$
Elementy ciągu nazywamy stanami łańcucha.

Dany łańcuch jest zadany jednoznacznie przez podanie gęstości prawdopodobieństwa
przejścia łańcucha ze stanu $bold(x) -> bold(y)$, którą będziemy oznaczać przez
$pi(bold(y) | bold(x))$ (zakładamy, iż prawdopodobieństwo przejścia jest
niezależne od chwili $t$ --- łańcuch taki nazywamy jednorodnym). Funkcja $pi$
spełnia oczywiście warunek unormowania
$
  integral pi(bold(y) | bold(x)) dif bold(y) = 1 quad,
$
istotnie prawdopodobieństwo przejścia gdziekolwiek ze stanu $bold(x)$ jest równe
$1$. Będziemy zakładać dodatkowo, iż
$forall bold(x), bold(y) in RR^n : pi(bold(y) | bold(x)) > 0$. Rozkład
$p(bold(x))$ łańcucha Markowa (tj. rozkład prawdopodobieństwa, z którego
losujemy stan łańcucha w danej chwili $t$) z daną funkcją przejścia $pi$ nazwiemy
rozkładem stacjonarnym tego łańcucha, jeśli
$
  p(bold(y)) = integral pi(bold(y) | bold(x)) p(bold(x)) dif bold(x) quad.
$
Rozkład stacjonarny danego łańcucha oznaczymy przez $p^*(bold(x))$. Zauważmy,
iż jeśli stan początkowy łańcucha $bold(X)_0$ pochodzi z rozkładu
stacjonarnego $p^*$, to każdy kolejny stan $bold(X)_t$ również pochodzi z
rozkładu stacjonarnego. Jeśli z kolei stan początkowy pochodzi z jakiegoś
innego rozkładu $p_0$, to rozkład łańcucha w chwili $t$ jest dany przez relację
rekurencyjną
$
  p_t (bold(y)) = integral pi(bold(y) | bold(x)) p_(t-1)(bold(x)) dif bold(x)
  quad "dla" t > 1 quad.
$
Rozkładem granicznym łańcucha Markowa nazwiemy granicę w sensie zbieżności
punktowej
$
  lim_(t -> infinity) p_t (bold(x)) quad.
$
Przy podanych wyżej założeniach istnieje twierdzenie, które mówi, iż taki łańcuch
Markowa posiada jednoznaczny rozkład stacjonarny tożsamy z rozkładem
granicznym. Ponadto warunkiem wystarczającym, aby dany rozkład $p(bold(x))$ był
rozkładem stacjonarnym łańcucha Markowa jest
$
  forall bold(x), bold(y) in RR^n : quad
  pi(bold(y) | bold(x)) p(bold(x)) = pi(bold(x) | bold(y)) p(bold(y)) quad,
$
co wynika ze scałkowania powyższego równania. Kryterium to nazywamy _kryterium
lokalnego balansu_ (ang. _detailed balance condition_).

Podstawowa idea wykorzystania łańcuchów Markowa do generowania próbek ze
skomplikowanego rozkładu $p$ jest więc następująca: tworzymy łańcuch Markowa, dla
którego $p$ jest rozkładem stacjonarnym; wówczas rozpoczynając w dowolnym
dopuszczalnym stanie początkowym $bold(X)_0$ po wykonaniu dużej liczby kroków
(etap ten nazywamy okresem przejściowym, ang. _burn-in period_) stan $bold(X)_t$
(dla $t >> 1$) tego łańcucha będzie w przybliżeniu pochodził z rozkładu
granicznego $p$ (nie jest jednak prosto stwierdzić po jak długim okresie
przejściowym przybliżenie to jest wystarczająco dobre). Aby otrzymać z takiej
procedury próbki prawdziwie i.i.d., każda z próbek musiałaby pochodzić z
ponownego uruchomienia takiego łańcucha. Oczywiście jest to nieefektywne, więc w
praktyce generujemy próbki z jednego łańcucha po prostu odrzucając pewne z nich
tak, aby uniknąć znaczących korelacji. Pozostaje pytanie, jak skonstruować
funkcję przejścia $pi(bold(y) | bold(x))$ dla danego rozkładu granicznego
$p(bold(x))$. Podstawową konstrukcję podaje algorytm Metropolisa--Hastingsa.

#algorithm("Metropolis--Hastings")[
  *Wejście:* Rozkład docelowy $p(bold(x))$, rozkład proponujący
  $q(bold(y) | bold(x))$, liczba iteracji `max_iter` \
  *Wyjście:* Próbki z rozkładu docelowego

  Zainicjalizuj stan $bold(x)$ dowolną dopuszczalną wartością. \
  *dla* $i = 1, ..., #raw("max_iter")$ *wykonuj* \
  #pad(left: 1.2em)[
    Wylosuj kandydata $bold(y) ~ q(bold(y) | bold(x))$. \
    Oblicz współczynnik akceptacji:
    $
      r(bold(y) | bold(x)) = min{
        1, (p(bold(y)) q(bold(x) | bold(y))) /
        (p(bold(x)) q(bold(y) | bold(x)))
      } quad.
    $
    Zaakceptuj $bold(y)$ z prawdopodobieństwem $r(bold(y) | bold(x))$: \
    *jeśli* kandydat $bold(y)$ zaakceptowany *to* \
    #pad(left: 1.2em)[ustaw $bold(x) <- bold(y)$]
    *w przeciwnym razie* \
    #pad(left: 1.2em)[zachowaj obecny stan $bold(x)$]
  ]
]

Funkcja przejścia ma postać
$
  pi_"MH" (bold(y) | bold(x)) = q(bold(y) | bold(x)) r(bold(y) | bold(x)) quad,
$
gdzie
$
  r(bold(y) | bold(x)) = min{
    1, (p(bold(y)) q(bold(x) | bold(y))) / (p(bold(x)) q(bold(y) | bold(x)))
  } quad.
$
Pozostaje tylko wykazać, iż spełnione jest kryterium lokalnego balansu. Istotnie
mamy
$
  pi_"MH" (bold(y) | bold(x)) p(bold(x)) & = min{
    q(bold(y) | bold(x)) p(bold(x)), q(bold(x) | bold(y)) p(bold(y))
  } quad, \
  pi_"MH" (bold(x) | bold(y)) p(bold(y)) & = min{
    q(bold(x) | bold(y)) p(bold(y)), q(bold(y) | bold(x)) p(bold(x))
  } quad,
$
skąd $pi_"MH" (bold(y) | bold(x)) p(bold(x)) = pi_"MH" (bold(x) | bold(y)) p(bold(y))$.
Zauważmy, iż nie musimy znać $p(bold(x))$ z dokładnością do stałej
normalizującej, gdyż
$
  (p(bold(y))) / (p(bold(x))) =
  (tilde(p)(bold(y)) / Z_p) / (tilde(p)(bold(x)) / Z_p) =
  (tilde(p)(bold(y))) / (tilde(p)(bold(x))) quad.
$
Poza algorytmem Metropolisa--Hastingsa jest wiele innych algorytmów z rodziny
MCMC. Większość z nich implementuje konkretny sposób generowania (zostawiając
resztę struktury) tak, aby zmniejszyć korelację po okresie przejściowym i
przyspieszyć zbieżność. Standardowo wykorzystywanymi algorytmami z tej klasy są
algorytmy HMC (_Hamiltonian Monte Carlo_) oraz NUTS (_No U-Turn Sampler_).

= Drzewa decyzyjne, bagging, boosting

Drzewa decyzyjne (ang. _Classification and Regression Trees, CART_) to metoda
uczenia maszynowego, której zasadniczą ideą jest segmentacja przestrzeni
predyktorów na skończoną liczbę obszarów o prostej geometrii, typowo kostek. W
każdym z obszarów wartość przewidywana jest obliczana jako średnia (w przypadku
regresji) lub moda (w przypadku klasyfikacji) wartości odpowiedzi dla elementów
ze zbioru uczącego należących do tego obszaru.

Reguły podziału przestrzeni predyktorów są naturalnie reprezentowane w postaci
drzewa binarnego --- stąd nazwa metody. Poniżej przedstawiono standardowy
algorytm uczenia drzewa CART.

#algorithm("CART")[
  *Wejście:* Zbiór danych $cal(X) = {(bold(x)_i, y_i)}$ w $R$ \
  *Wyjście:* Drzewo decyzyjne (podział przestrzeni cech)

  Zainicjalizuj region $R = {bold(x)_i | (bold(x)_i, y_i) in cal(X)}$ jako
  całą przestrzeń cech. \
  *jeśli* spełniony warunek stopu w $R$ *to* \
  #pad(left: 1.2em)[*zwróć* liść z wartością $overline(y)_R$]
  *w przeciwnym razie* \
  #pad(left: 1.2em)[
    Znajdź cechę $k^* in {1, ..., p}$ i próg $s^*$ minimalizujące:
    $
      sum_(i: bold(x)_i in R_- (k, s)) (y_i - overline(y)_(R_- (k, s)))^2 +
      sum_(i: bold(x)_i in R_+ (k, s)) (y_i - overline(y)_(R_+ (k, s)))^2
      quad,
    $
    gdzie $R_- (k, s) = {bold(x) in R | x_k < s}$ oraz
    $R_+ (k, s) = {bold(x) in R | x_k >= s}$. \
    Rekurencyjnie twórz poddrzewa dla podregionów $R_- (k^*, s^*)$ i
    $R_+ (k^*, s^*)$.
  ]
]

Powyższy algorytm został przedstawiony dla zagadnienia regresji zmiennej
ciągłej. W przypadku zadania klasyfikacji przewidywana wartość w każdym regionie
to klasa najczęściej występująca. Natomiast przy dokonywaniu podziałów zamiast
RSS używa się innych miar --- najczęściej indeksu Giniego
$
  G = sum_(k=1)^K hat(p)_(m k) (1 - hat(p)_(m k))
$
lub entropii krzyżowej
$
  D = - sum_(k=1)^K hat(p)_(m k) log hat(p)_(m k) quad,
$
gdzie $hat(p)_(m k)$ jest proporcją obserwacji w regionie $R_m$, które należą
do klasy $k$.

== Przycinanie drzewa

Opisany proces prowadzi do modelu z małym błędem treningowym, ale silnie
zagrożonego przeuczeniem. Jedną z możliwości poradzenia sobie z tym problemem
jest zatrzymywanie podziału przy niezbyt dużym spadku RSS. Lepszą alternatywą
jest wyhodowanie dużego drzewa, a następnie jego przycięcie.

== Bagging

Bagging opiera się na prostej obserwacji: jeśli $Z_1, ..., Z_n$ jest prostą
próbą losową z rozkładu o wariancji $sigma^2$, to
$"Var"(overline(Z)) = sigma^2 / n$. Idea jest zatem następująca: z oryginalnego
zbioru uczącego $cal(X)$ tworzymy $B$ zbiorów uczących typu bootstrap (tj.
zbiorów zawierających tyle samo obserwacji co $cal(X)$, tworzonych poprzez
losowanie _ze zwracaniem_ z $cal(X)$). Na każdym z tych $B$ zbiorów trenujemy
drzewo decyzyjne _bez przycinania_ --- jest to więc drzewo o dużej wariancji,
ale małym obciążeniu. Finalny model jest tworzony jako średnia lub moda z
odpowiedzi modeli z zespołu, tj. w przypadku regresji
$
  hat(f)_"bag" (bold(x)) = 1 / B sum_(b=1)^B hat(f)_b (bold(x)) quad.
$
Można pokazać, iż zbiory typu bootstrap obejmują średnio $2/3$ dostępnych
obserwacji. Niewykorzystane obserwacje (tzw. _out-of-bag observations, OOB_)
mogą być użyte do estymacji błędu testowego poprzez uśrednienie błędów OOB
każdego z drzew. Bagging zwiększa dokładność predykcji kosztem
interpretowalności. W przypadku metody bagging można jednak wprowadzić tzw.
ważności cech (ang. _feature importances_) jako sumaryczne redukcje RSS (lub
indeksu Giniego, entropii) uzyskane przez podział względem tego predyktora,
uśrednione po $B$ drzewach.

== Lasy losowe

Lasy losowe są odmianą metody bagging, w której w trakcie budowania drzew, przy
każdym podziale, rozważa się tylko $m < p$ losowo wybranych predyktorów (typowo
dla zagadnień regresji $m approx sqrt(p)$, a dla klasyfikacji $m approx p / 3$).
Poprawka ta redukuje korelacje między drzewami będącą efektem dominacji
najważniejszych predyktorów.

Ani w metodzie bagging, ani w lasach losowych zwiększenie liczby drzew $B$ _nie
powoduje przeuczenia_.

== Boosting gradientowy

Boosting jest techniką ogólną stosowaną do różnych metod uczenia
statystycznego w celu istotnego zwiększenia dokładności. Pomysł uczenia
zespołowego jest podobny jak w baggingu i lasach losowych, jednak łączenie
wyników odbywa się w zupełnie inny sposób.

#algorithm("Proste stopniowe modelowanie addytywne")[
  *Wejście:* Zbiór danych ${(bold(x)_i, y_i)}_(i=1)^n$, funkcja straty
  $L(y, f(bold(x)))$, liczba iteracji $M$ \
  *Wyjście:* Model $f_M (bold(x))$

  Zainicjalizuj model: $f_0 (bold(x)) <- 0$. \
  *dla* $m = 1, ..., M$ *wykonuj* \
  #pad(left: 1.2em)[
    Znajdź parametry $(beta_m, gamma_m)$ minimalizujące:
    $
      sum_(i=1)^n L(y_i, f_(m-1)(bold(x)_i) + beta dot b(bold(x)_i; gamma))
      quad.
    $
    Zaktualizuj model:
    $
      f_m (bold(x)) <- f_(m-1)(bold(x)) + beta_m dot b(bold(x); gamma_m)
      quad.
    $
  ]
  *zwróć* $f_M (bold(x))$
]

W każdej iteracji szukamy optymalnej (dla danej funkcji kosztu $L$) funkcji
bazowej (z pewnej rodziny parametrycznej) i współczynnika, które tworzą wyraz
dodawany do aktualnego rozwinięcia funkcji $hat(f)$.

#algorithm("Boosting gradientowy dla drzew")[
  *Wejście:* Zbiór danych ${(bold(x)_i, y_i)}_(i=1)^n$, funkcja straty
  $L(y, f(bold(x)))$, liczba iteracji $M$ \
  *Wyjście:* Model $f_M (bold(x))$

  Zainicjalizuj model:
  $
    f_0 (bold(x)) = arg min_gamma sum_(i=1)^n L(y_i, gamma) quad.
  $
  *dla* $m = 1, ..., M$ *wykonuj* \
  #pad(left: 1.2em)[
    Oblicz pseudorezydua dla $i = 1, ..., n$:
    $
      r_(i m) = - nabla_f L(y_i, f_(m-1)(bold(x)_i)) quad.
    $
    Dopasuj regresyjne drzewo decyzyjne do ${(bold(x)_i, r_(i m))}$, uzyskując
    regiony terminalne $R_(j m)$ dla $j = 1, ..., J_m$. \
    Oblicz wagi dla $j = 1, ..., J_m$:
    $
      gamma_(j m) = arg min_gamma sum_(i: bold(x)_i in R_(j m))
      L(y_i, f_(m-1)(bold(x)_i) + gamma) quad.
    $
    Zaktualizuj model:
    $
      f_m (bold(x)) = f_(m-1)(bold(x)) + sum_(j=1)^(J_m) gamma_(j m) dot
      bold(1)_(R_(j m))(bold(x)) quad.
    $
  ]
  *zwróć* $f_M (bold(x))$
]

W przeciwieństwie do baggingu nadmierne zwiększanie liczby drzew $M$ prowadzi do
przeuczenia. Brak kontroli nad wielkością drzew $J_m$ może istotnie zdegradować
jakość predykcji. Aby uniknąć problemu silnie rozbudowanych drzew często
przyjmuje się wspólną, niewielką wartość $J_m = J$ wielkości drzew. Zamiast
$J$ można też użyć parametru zwanego głębokością interakcji $d = J - 1$
oznaczającego liczbę podziałów w drzewie (dla $d = 1$ finalny model jest
addytywny). Inne metody stosowane w celu uniknięcia przeuczenia to w
szczególności: early-stopping; użycie współczynnika spowalniającego
$nu in (0, 1]$, przez który mnożony jest dodawany człon; subsampling ---
hodowanie drzew w każdej iteracji na wylosowanym fragmencie zbioru uczącego
(tzw. stochastyczny boosting).

= Inne metody uczenia maszynowego

== KDE

W poprzednim rozdziale opisaliśmy, w jaki sposób mając (nieznormalizowaną)
funkcję gęstości prawdopodobieństwa $tilde(p)(bold(x))$ generować algorytmicznie
próbki z opisanego przez nią rozkładu. Teraz zajmiemy się problemem odwrotnym,
tj. mając realizację prostej próby losowej z pewnego rozkładu chcemy znaleźć
funkcję $hat(p)(bold(x))$, która estymuje gęstość rozkładu prawdopodobieństwa,
z którego pochodzą próbki. Opiszemy tutaj jedną z najprostszych metod zwaną
estymatorem jądrowym (ang. _Kernel Density Estimator, KDE_). Estymatorem
jądrowym gęstości funkcji $p$ nazywamy funkcję
$
  hat(p)(bold(x)) := 1 / n sum_(i=1)^n K_bold(H)(bold(x) - bold(x)_i) quad,
$
gdzie $bold(H)$ jest symetryczną i dodatnio określoną macierzą zwaną _bandwidth
matrix_, a funkcja $K_bold(H)$ ma postać
$
  K_bold(H)(bold(x)) = (det bold(H))^(-1/2) K(bold(H)^(-1/2) bold(x)) quad,
$
gdzie funkcja $K$ zwana jądrem (z ang. _kernel_) jest gęstością
prawdopodobieństwa pewnego sferycznie symetrycznego rozkładu wielowymiarowego.
Wybór funkcji $K$ nie jest kluczowy ze statystycznego punktu widzenia, więc
możemy bez problemu założyć, iż jest to gęstość wielowymiarowego rozkładu
normalnego, tj.
$
  K_bold(H)(bold(x)) = 1 / sqrt((2pi)^m det bold(H))
  exp(- 1 / 2 bold(x)^top bold(H)^(-1) bold(x)) quad,
$
gdzie zakładamy $bold(x) in RR^m$. Większym problemem w przypadku KDE jest wybór
odpowiedniego parametru $bold(H)$. Jednym z prostszych wyborów w przypadku
estymatora jest tzw. _reguła Silvermana_, która podaje następujący przepis na
macierz $bold(H)$,
$
  H_(alpha beta) = 0 quad, quad
  sqrt(H_(alpha alpha)) = (4 / (4 + m))^(1 / (m + 4)) n^(- 1 / (m + 4))
  sigma_alpha quad,
$
gdzie $sigma_alpha$ jest estymatorem wariancji $alpha$-tej współrzędnej
zmiennej $bold(X)$. Inną możliwością jest tzw. _reguła Scotta_,
$
  H_(alpha beta) = 0 quad, quad
  sqrt(H_(alpha alpha)) = n^(- 1 / (m + 4)) sigma_alpha quad.
$
KDE w praktycznych zastosowaniach często przyspiesza się za pomocą
odpowiednich struktur danych do wyszukiwania najbliższych sąsiadów w
przestrzeni $RR^m$, tj. zamiast sumować przyczynki od wszystkich punktów
$bold(x)_i$ dla danego $bold(x)$, znajdujemy jego $k$ najbliższych sąsiadów
$bold(x)$ ze zbioru ${bold(x)_i}_(i=1)^n$ (np. stosując _approximate nearest
neighbors_) i obliczamy przyczynki do $hat(p)(bold(x))$ tylko od nich.

== KNN

Metody oparte o sąsiedztwo to zbiór metod, które wykorzystują najbliższych (w
sensie pewnej metryki lub półmetryki) sąsiadów (ang. _nearest neighbors_) dla
danego nowego punktu. Zasadniczą ideą tych metod jest iż punkty leżące blisko
siebie w pewnej przestrzeni powinny mieć podobne własności, czyli taka
przestrzeń metryczna powinna być _semantycznie sensowna_.

Jednym z najprostszych algorytmów z tej dziedziny jest _k-nearest neighbors_
(KNN) używany najczęściej do klasyfikacji, ale możliwe jest również użycie go
do regresji. Załóżmy, iż mamy zbiór treningowy
$cal(X) = {t_i (bold(x)_i)}_(i=1)^n$, gdzie $bold(x)$ to wektor cech, a $t$ to
prawidłowa klasa. Chcąc przewidzieć klasę dla nowego wektora cech $bold(x)$,
znajdujemy $k$ najbliższych sąsiadów $bold(x)$ w zbiorze ${bold(x)_i}_(i=1)^n$
względem metryki $d$, zliczamy klasy najbliższych sąsiadów i zwracamy klasę
występującą najczęściej lub rozkład prawdopodobieństwa nad możliwymi klasami
jako stosunek liczby punktów z daną klasą do liczby sąsiadów,
$
  hat(t)(bold(x)) = arg max_(c in {1, ..., C}) 1 / k
  sum_(i: bold(x)_i in N_k (bold(x))) [t_i = c] quad.
$
W przypadku regresji zamiast zwracać klasę występującą najczęściej, zwracamy
średnią arytmetyczną wartości $t$ dla $k$ najbliższych sąsiadów (użycie średniej
powoduje, iż KNN w przypadku regresji potrafi tylko interpolować wartości),
$
  hat(t)(bold(x)) = 1 / k sum_(i: bold(x)_i in N_k (bold(x))) t_i quad.
$
Liczba sąsiadów $k$ jest hiperparametrem modelu KNN, który silnie wpływa na
jakość predykcji. Zasadniczo im większa wartość $k$, tym większy jest bias
modelu, natomiast im mniejsza, tym większa jest wariancja modelu. KNN jest
modelem nieliniowym i potrafi nauczyć się nietrywialnych granic decyzyjnych.
Jest również bardziej elastyczny w porównaniu do modeli liniowych (np. regresji
logistycznej). Standardowo wykorzystywane metryki to w szczególności metryka
euklidesowa, metryka manhattan, podobieństwo cosinusowe.

Często wykorzystywaną modyfikacją KNN jest tzw. ważenie sąsiadów. Opiera się ono
na prostej obserwacji, iż nie wszyscy najbliżsi sąsiedzi danego punktu są
jednakowo ważni, gdyż w rzadkich obszarach przestrzeni sąsiedzi ci mogą być
dosyć daleko. Rozwiązaniem jest ważenie sąsiadów odwrotnością odległości do
nich. Wówczas w przypadku klasyfikacji prawdopodobieństwa obliczamy jako
stosunek sumy wag danej klasy do sumy wszystkich wag, a w przypadku regresji
obliczamy średnią ważoną zamiast arytmetycznej.

W vanilla KNN etap treningu polega jedynie na zapamiętaniu zbioru danych i
dopiero na etapie predykcji znajdowani są najbliżsi sąsiedzi. Takie podejście
jest bardzo nieefektywne, złożoność obliczeniowa etapu predykcji to $O(k n)$.
W praktyce podczas treningu budowana jest pomocnicza struktura danych, która
pozwala efektywniej przeszukiwać punkty w celu znalezienia najbliższych
sąsiadów. Przykładami takich struktur są np. k-d tree, ball tree, quad tree,
octree. W przypadku k-d tree złożoność treningu (budowy struktury) wynosi
$O(n log n)$, natomiast wyszukania $k$ sąsiadów $O(k log n)$. W przypadku
zastosowania kNN do wyszukiwania taka złożoność jest niestety nadal za duża w
praktyce (chcemy wyszukiwać wśród setek milionów obiektów), dlatego powstały
również metody przybliżone (z ang. _Approximate Nearest Neighbors_). W
algorytmach przybliżonych zamiast znajdować dokładnych $k$ najbliższych sąsiadów
znajdujemy $k$ sąsiadów, którzy niekoniecznie muszą być rzeczywiście
najbliższymi, potrafimy to jednak zrobić znacznie szybciej.

== NBC

Mając zbiór uczący dla zadania klasyfikacji postaci
$cal(X) = {t_i (bold(x)_i)}_(i=1)^n$ możemy próbować estymować rozkłady
$p(bold(x) | k)$ i $p(k)$ dla klasy $k in {1, ..., K}$, a następnie korzystając
z twierdzenia Bayesa stworzyć klasyfikator zgodny z regułą MAP,
$
  hat(t)(bold(x)) = arg max_(k in {1, ..., K}) p(k | bold(x)) =
  arg max_(k in {1, ..., K}) p(bold(x) | k) p(k) quad.
$
W przypadku drugiego członu sprawa jest prosta --- estymatorem MLE jest
$
  p(k) = 1 / n sum_(i=1)^n [t_i = k] quad.
$
Problemem jest zwykle estymowanie rozkładu warunkowego $p(bold(x) | k)$,
zwłaszcza dla wektora cech o wielu predyktorach $p >> 1$ (klątwa wymiarowości).
Naiwny klasyfikator Bayesowski (ang. _Naive Bayesian Classifier, NBC_) czyni
(naiwne) założenie o warunkowej niezależności predyktorów względem klasy, tj.
$
  p(x_1, ..., x_p | k) = product_(i=1)^p p(x_i | k) quad.
$
Wówczas rozkłady warunkowe dla poszczególnych predyktorów $p(x_i | k)$
estymujemy niezależnie, albo zgodnie z przyjętym modelem zdarzeń (np.
przyjmując jakiś rozkład parametryczny i estymując jego parametry), albo
używając metod nieparametrycznych (np. jednowymiarowych KDE).

Zauważmy, że NBC zasadniczo różni się od modeli rozważanych wcześniej (regresja
liniowa, logistyczna itp.), w których bezpośrednio modelowaliśmy rozkład
warunkowy $p(y | bold(x))$. Tutaj zamiast rozkładu warunkowego estymujemy
rozkład łączny cech i odpowiedzi $p(y, bold(x))$. Model taki nazywa się
_modelem generatywnym_. Natomiast model, w którym wprost modelujemy rozkład
warunkowy, nazywa się _modelem dyskryminatywnym_.

== LDA i QDA

Modele LDA (ang. _Linear Discriminant Analysis_) i QDA (ang. _Quadratic
Discriminant Analysis_) są modelami generatywnymi, podobnymi do NBC. Zasadniczą
różnicą względem NBC jest to, że nie czynią założenia warunkowej niezależności.
Zamiast tego zakładają, że rozkład predyktorów w ramach danej klasy jest
wielowymiarowym rozkładem normalnym. W przypadku LDA mamy
$
  bold(x) | k ~ cal(N)(bold(mu)_k, bold(Sigma)) quad,
$
natomiast w przypadku QDA
$
  bold(x) | k ~ cal(N)(bold(mu)_k, bold(Sigma)_k) quad.
$
Modele LDA i QDA różnią się między sobą założeniem o równości macierzy
kowariancji między klasami. W przypadku LDA mamy tylko jedną macierz
kowariancji niezależną od klasy, natomiast w przypadku QDA mamy osobne macierze
dla każdej z klas. W obu przypadkach rozkład a priori $p(k)$ estymujemy
analogicznie jak w przypadku NBC, tj.
$
  p(k) = 1 / n sum_(i=1)^n [t_i = k] quad.
$
Właściwy klasyfikator jest również budowany zgodnie z bayesowską regułą MAP,
$
  hat(t)(bold(x)) & = arg max_k log p(k | bold(x)) \
                  & = arg max_k (log p(bold(x) | k) + log p(k)) quad.
$
Rozwijając wyrażenie pod operatorem $arg max$ otrzymujemy odpowiednio dla LDA
(pomijając człony stałe)
$
  delta_k (bold(x)) = bold(x)^top bold(Sigma)^(-1) bold(mu)_k -
  1 / 2 bold(mu)_k^top bold(Sigma)^(-1) bold(mu)_k + log p(k)
$
i QDA
$
  delta_k (bold(x)) & = - 1 / 2 log det bold(Sigma)_k -
                        1 / 2 bold(x)^top bold(Sigma)_k^(-1) bold(x) +
                        bold(x)^top bold(Sigma)_k^(-1) bold(mu)_k \
                    & quad - 1 / 2 bold(mu)_k^top bold(Sigma)_k^(-1) bold(mu)_k +
                        log p(k) quad.
$
Funkcję $delta_k$ nazywamy _funkcją dyskryminatora_. Widzimy również, skąd biorą
się nazwy modeli --- w przypadku LDA funkcja dyskryminatora jest funkcją
liniową względem predyktorów, natomiast w przypadku QDA ma ona postać formy
kwadratowej względem predyktorów. Uczenie modeli LDA i QDA polega na estymacji
parametrów rozkładów warunkowych: $bold(mu)_k, bold(Sigma)$ w przypadku LDA i
$bold(mu)_k, bold(Sigma)_k$ w przypadku QDA. Można pokazać, iż odpowiednimi
estymatorami są
$
  bold(mu)_k & = 1 / n_k sum_(i: t_i = k) bold(x)_i quad, \
  bold(Sigma) & = 1 / (n - K) sum_(k=1)^K sum_(i: t_i = k)
                  (bold(x)_i - bold(mu)_k)(bold(x)_i - bold(mu)_k)^top quad, \
  bold(Sigma)_k & = 1 / (n_k - 1) sum_(i: t_i = k)
                    (bold(x)_i - bold(mu)_k)(bold(x)_i - bold(mu)_k)^top quad.
$

== PCA

Analiza składowych głównych (ang. _Principal Component Analysis_) to liniowa
metoda redukcji wymiarowości, która może zostać wykorzystana zarówno w celach
wizualizacji wysokowymiarowych danych, jak i do zmniejszenia liczby wymiarów
celem ułatwionego ich późniejszego przetwarzania przez inne modele uczenia
maszynowego. Zasadnicza idea jest następująca: mamy macierz $bold(X)$ wymiaru
$n times d$, gdzie $n$ to liczba przykładów, a $d$ to liczba cech. Wiemy, że
dla każdej macierzy $bold(X)$ wymiaru $n times d$ ($n >= d$) istnieje jej
rozkład SVD,
$
  bold(X) = sigma_1 bold(u)_1 bold(v)_1^top + dots.c +
  sigma_r bold(u)_r bold(v)_r^top quad,
$
gdzie $r <= min{n, d}$ to rząd macierzy $bold(X)$,
$sigma_1 >= sigma_2 >= dots.c >= sigma_r >= 0$ to wartości osobliwe, natomiast
$bold(u)_i$ to ortonormalne wektory kolumnowe wymiaru $n$, a $bold(v)_i$ to
ortonormalne wektory kolumnowe wymiaru $d$. Możemy w takim razie przybliżyć
macierz $bold(X)$ za pomocą kilku pierwszych wyrażeń, w szczególności dwóch,
$
  bold(X) approx sigma_1 bold(u)_1 bold(v)_1^top +
  sigma_2 bold(u)_2 bold(v)_2^top quad.
$
Zauważmy jednak teraz, iż wektory $bold(u)_1$ i $bold(u)_2$ możemy potraktować
jako kolejne współrzędne 2-D naszego zbioru punktów.

== PDP

Wykresy PDP (ang. _Partial Dependence Plots_) to prosta i intuicyjna metoda do
wizualizacji wpływu danych predyktorów modelu uczenia maszynowego na jego
odpowiedź. Jest to wykres funkcji częściowej zależności
$
  f_S (bold(x)_S) = EE_(X_({1, ..., p} without S)) [
    f(bold(x)_S, X_({1, ..., p} without S))
  ] quad,
$
gdzie $S$ jest badanym podzbiorem predyktorów, natomiast $f$ to funkcja modelu.
Praktycznie stosowaną estymatę oblicza się uśredniając po zbiorze danych,
$
  hat(f)_S (bold(x)_S) = 1 / n sum_(i=1)^n
  f(bold(x)_S, bold(x)_({1, ..., p} without S)^((i))) quad,
$
przy czym $bold(x)_({1, ..., p} without S)^((i))$ są wartościami
nieinteresujących cech obiektów ze zbioru danych. Zaletami wykresów częściowej
zależności są w szczególności: intuicyjność, łatwość implementacji,
przejrzystość interpretacji (o ile predyktory nie są istotnie skorelowane) oraz
możliwa interpretacja przyczynowa. Ograniczenia PDP to m.in.:
- Nie da się zwizualizować PDP dla więcej niż $2$ cech jednocześnie.
- Jeśli predyktory są skorelowane, może występować uśrednianie po
  nierealistycznych danych.
- PDP mogą ukrywać efekty niejednorodne (np. uśrednienie powoduje wzajemne
  zniesienie efektów pochodzących od różnych części zbioru danych).

= Ewaluacja modeli

== Przygotowanie danych

Kluczem do uzyskania dobrych wyników przy korzystaniu z algorytmów uczenia
maszynowego jest odpowiednie przygotowanie danych (ang. _preprocessing_).
Typowo preprocessing składa się z:
- eksploracji danych oraz wstępnego czyszczenia, w szczególności usunięcia
  jawnych wartości odstających (ang. _outliers_) oraz cech posiadających zbyt
  dużo wartości brakujących;

- analizy rozkładu zmiennej docelowej oraz ewentualnej transformacji
  logarytmicznej, która poprawia stabilność numeryczną, gdy przewidywane
  wartości są dużymi dodatnimi liczbami rzeczywistymi, zmienia dziedzinę
  zmiennej objaśnianej z $RR_+$ na $RR$ oraz dodatkowo jest przykładem
  transformacji stabilizującej wariancję;

- _podziału zbioru na część treningową oraz testową_;

- dokonania skalowania i imputacji brakujących wartości cech (metody `.fit()`
  wywołujemy jedynie dla zbioru treningowego);

- usunięcia silnie skorelowanych cech;

- zakodowania wartości kategorycznych za pomocą tzw. _one-hot encoding_
  pamiętając o _dummy variable trap_ --- jedną z $k$ kategorii kodujemy za
  pomocą wektora _one-hot_ długości $k - 1$, aby uniknąć zależności liniowej
  między cechami (opcja `drop="first"` w `OneHotEncoder` w scikit-learn);

- wykonania feature engineering --- dodania wielomianów cech do naszych danych
  lub skonstruowania innych cech (np. cech określających miesiąc, dzień itp.).

Podział zbioru na część treningową i testową jest najważniejszym etapem
preprocessingu. Zbiór testowy wydzielamy, aby po wytrenowaniu modelu sprawdzić,
jak poradzi on sobie na nowych, niewidzianych wcześniej danych. Powinniśmy go
traktować jako dane, które będziemy w przyszłości dostawać po wdrożeniu modelu do
realnego systemu. Takie dane również będziemy musieli przeskalować, zakodować
itp., ale parametry potrzebne do wykonania tych transformacji możemy wziąć
jedynie z dostępnego wcześniej zbioru treningowego. Wykorzystanie danych
testowych w procesie treningu to _błąd wycieku danych_ (ang. _data leakage_).
Skutkuje on niepoprawnym, nadmiernie optymistycznym oszacowaniem jakości modelu.

== Metryki do oceny regresji i klasyfikacji

Zasadniczo, aby ocenić predykcje modelu, używamy odpowiednich metryk, których
wartości określają, jak dobry jest model.

W przypadku regresji najczęściej używanymi metrykami są RMSE (ang. _Root Mean
Squared Error_) oraz MAE (ang. _Mean Absolute Error_) zdefiniowane odpowiednio
jako
$
  "RMSE" & := sqrt(1 / n sum_(i=1)^n (y_i - hat(y)_i)^2) quad, \
  "MAE" & := 1 / n sum_(i=1)^n |y_i - hat(y)_i| quad.
$
Metryki te mają jednakową jednostkę jak predykcje. Jeśli chcielibyśmy mieć
liczbę względną określającą jakość modelu, to mamy do dyspozycji metryki MAPE
(ang. _Mean Absolute Percentage Error_) oraz SMAPE (ang. _Symmetric Mean
Absolute Percentage Error_) zdefiniowane odpowiednio jako
$
  "MAPE" & := 1 / n sum_(i=1)^n |(y_i - hat(y)_i) / y_i| quad, \
  "SMAPE" & := 1 / n sum_(i=1)^n (|y_i - hat(y)_i|) / (|y_i| + |hat(y)_i|)
            quad.
$
Obie te metryki mają zakres od $0$ do $1$, przy czym niższa wartość oznacza
lepszy model. Metryki te mają jednak szereg problemów, z których najpoważniejsze
to: problemy, gdy wartości są bliskie $0$, oraz asymetryczne traktowanie
predykcji za dużych oraz za małych. Z tych powodów znacznie lepszą względną
metryką jest MASE (ang. _Mean Absolute Scaled Error_),
$
  "MASE" := (sum_(i=1)^n |y_i - hat(y)_i|) /
  (sum_(i=1)^n |y_i - overline(y)|) quad,
$
gdzie $overline(y) = 1 / n sum_(i=1)^n y_i$. Metryka MASE jest zatem względnym
błędem MAE, jaki popełnia nasz model w stosunku do modelu naiwnego, który
przewiduje zawsze wartość średnią.

W przypadku zadania klasyfikacji binarnej naszym celem dla danego wektora cech
jest zwrócenie jednej z dwóch klas, które będziemy nazywać klasą pozytywną i
negatywną. O ile w przypadku regresji pomiar jakości modelu był całkiem prosty, o
tyle w przypadku klasyfikacji sytuacja jest nieco bardziej skomplikowana.
Zauważmy bowiem, iż mamy $4$ możliwości odpowiedzi klasyfikatora:
- _True Positive (TP)_ --- poprawnie zaklasyfikowaliśmy klasę pozytywną jako
  pozytywną,
- _True Negative (TN)_ --- poprawnie zaklasyfikowaliśmy klasę negatywną jako
  negatywną,
- _False Positive (FP)_ --- niepoprawnie zaklasyfikowaliśmy klasę negatywną jako
  pozytywną,
- _False Negative (FN)_ --- niepoprawnie zaklasyfikowaliśmy klasę pozytywną jako
  negatywną.

Na podstawie ilości TP, TN, FP i FN w zbiorze testowym możemy wykreślić tzw.
_macierz pomyłek_ (ang. _confusion matrix_) pokazującą ilość każdej z
możliwości. Następnie możemy obliczyć różne stosunki tych wartości, aby uzyskać
różne metryki. Najbardziej standardowymi są _accuracy_, _precision_ oraz
_recall_ (lub inaczej sensitivity) zdefiniowane jako
$
  "Accuracy" & := ("TP" + "TN") / n quad, \
  "Precision" & := "TP" / ("TP" + "FP") quad, \
  "Recall" & := "TP" / ("TP" + "FN") quad.
$
Wartość accuracy mówi po prostu, jaki stosunek przykładów został poprawnie
zaklasyfikowany (zauważmy tutaj, że $"TP" + "TN" + "FP" + "FN" = n$). Nie jest
to jednak dobra miara jakości, gdy nasz zbiór jest niezbalansowany, tj. zawiera
więcej przykładów określonej klasy.

Wartość precision określa, jak pewny jest klasyfikator przy wykrywaniu klasy
pozytywnej, natomiast recall mówi o tym, jak dobrze klasyfikator wyławia
przykłady pozytywne. Zauważmy jednak, iż nie możemy stosować żadnej z tych
metryk w odosobnieniu. Istotnie klasyfikator, który zwraca zawsze klasę
pozytywną ma maksymalny recall, a klasyfikator, który zwraca zawsze klasę
negatywną ma nieokreślony precision (i jest oczywiście beznadziejnym
klasyfikatorem). Musimy więc zawsze ewaluować model na obu tych metrykach i
jedynie dobry wynik obu z nich mówi o jakości klasyfikatora. Oczywiście czasami
chcielibyśmy określić jakość modelu za pomocą jednej liczby, a niekoniecznie
sprawdzać zawsze macierz pomyłek (choć jest to bardzo użyteczne) lub podawać
wartości dwóch metryk. Metryką, która łączy precision i recall jest
_$F_beta$-score_ zdefiniowany jako
$
  F_beta := (1 + beta^2) ("Precision" dot "Recall") /
  (beta^2 dot "Precision" + "Recall") quad,
$
gdzie $beta$ określa, ile razy bardziej ważny jest recall od precision. Typowo
używa się $F_1$-score,
$
  F_1 = 2 ("Precision" dot "Recall") / ("Precision" + "Recall") quad.
$

Wiele klasyfikatorów oprócz twardych predykcji zwraca również rozkład
prawdopodobieństwa nad klasami. W przypadku klasyfikacji binarnej jest to
oczywiście rozkład zero-jedynkowy z parametrem $p$ określającym prawdopodobieństwo
klasy pozytywnej dla danego wektora cech. Standardowo oczywiście twardą
predykcją jest ta z klas, która ma większe prawdopodobieństwo, czyli (co
równoważne) predykcją jest klasa pozytywna, jeśli $p > 0.5$. W niektórych
problemach chcemy jednak zmienić ten próg i dokonać tzw. _threshold tuning_.
Wykresem, który pozwala na dokonanie tuningu progu jest _krzywa ROC_ (ang.
_Receiver Operating Characteristic curve_), która jest krzywą parametryczną
wyznaczoną przez punkty $("FPR"("threshold"), "TPR"("threshold"))$ dla progów z
zakresu $[0, 1]$, gdzie
$
  "TPR" := "TP" / ("TP" + "FN") quad, quad
  "FPR" := "FP" / ("FP" + "TN") quad.
$
Metryką niezależną od wybranego progu jest tzw. _AUROC_ (ang. _Area under ROC
curve_) zdefiniowany jako pole powierzchni pod krzywą ROC dla danego
klasyfikatora. Zauważmy, że klasyfikator losowy, który zwraca zawsze klasę
pozytywną z prawdopodobieństwem równym wartości progu, ma wartość AUROC równą
$0.5$, natomiast idealny klasyfikator, który niezależnie od wartości progu
klasyfikuje wszystkie przykłady poprawnie, ma AUROC równy $1$.

Inną analogiczną metryką jest _AUPRC_, gdzie zamiast krzywej ROC stosujemy
krzywą _PRC_ (z ang. _Precision--Recall Curve_), w której zamiast TPR i FPR
używamy odpowiednio Precision i Recall. Metryka AUPRC jest często wykorzystywana
w przypadku klasyfikacji ekstremalnie niezbalansowanej, w której mamy bardzo
mało ($< 1\%$) klasy pozytywnej.

W przypadku klasyfikacji wieloklasowej używamy zasadniczo takich samych metryk
jak w klasyfikacji binarnej, ale wprowadzamy mikro- i makrouśrednianie (ang.
_micro/macro-averaging_). Przez $"TP"_k$ będziemy rozumieć liczbę prawidłowo
zaklasyfikowanych przykładów z klasy $k$, $"FP"_k$ to liczba przykładów z
innych klas, które zaklasyfikowaliśmy nieprawidłowo jako $k$-tą klasę, $"FN"_k$
to liczba przykładów z klasy $k$, które zaklasyfikowaliśmy jako inną klasę.
Wówczas odpowiednie metryki mają postać
$
  "MicroPrecision" & := (sum_k "TP"_k) / (sum_k "TP"_k + sum_k "FP"_k) quad, \
  "MacroPrecision" & := 1 / K sum_(k=1)^K ("TP"_k) / ("TP"_k + "FP"_k)
$
oraz
$
  "MicroRecall" & := (sum_k "TP"_k) / (sum_k "TP"_k + sum_k "FN"_k) quad, \
  "MacroRecall" & := 1 / K sum_(k=1)^K ("TP"_k) / ("TP"_k + "FN"_k) quad.
$
W przypadku klasyfikacji wieloklasowej macierz pomyłek jest macierzą wymiaru
$K times K$, gdzie $K$ jest liczbą klas.

== Tuning hiperparametrów i walidacja skrośna

Praktycznie wszystkie modele uczenia maszynowego mają hiperparametry, często
liczne, które w zauważalny sposób wpływają na wyniki, a szczególnie na
underfitting i overfitting. Ich wartości trzeba dobrać zatem dość dokładnie.
Proces doboru hiperparametrów nazywa się tuningiem hiperparametrów (ang.
_hyperparameter tuning_).

Istnieje na to wiele sposobów. Większość z nich polega na tym, że trenuje się
za każdym razem model z nowym zestawem hiperparametrów i wybiera się ten zestaw,
który pozwala uzyskać najlepsze wyniki. Metody głównie różnią się między sobą
sposobem doboru kandydujących zestawów hiperparametrów. Najprostsze i
najpopularniejsze to:
- pełne przeszukiwanie (ang. _grid search_) --- definiujemy możliwe wartości dla
  różnych hiperparametrów, a metoda sprawdza ich wszystkie możliwe kombinacje
  (czyli siatkę),

- losowe przeszukiwanie (ang. _randomized search_) --- definiujemy możliwe
  wartości jak w pełnym przeszukiwaniu, ale sprawdzamy tylko ograniczoną liczbę
  losowo wybranych kombinacji.

Jak ocenić, jak dobry jest jakiś zestaw hiperparametrów? Nie możemy sprawdzić
tego na zbiorze treningowym --- wyniki byłyby zbyt optymistyczne. Nie możemy
wykorzystać zbioru testowego --- mielibyśmy wyciek danych, bo wybieralibyśmy
model explicite pod nasz zbiór testowy. Trzeba zatem osobnego zbioru, na którym
będziemy na bieżąco sprawdzać jakość modeli dla różnych hiperparametrów. Jest to
zbiór walidacyjny (ang. _validation set_). Zbiór taki wycina się ze zbioru
treningowego.

Jednorazowy podział zbioru na części nazywa się _split validation_ lub
_holdout_. Używamy go, gdy mamy sporo danych, i $10$--$20\%$ zbioru jako dane
walidacyjne czy testowe to dość dużo, żeby mieć przyzwoite oszacowanie. Zbyt
mały zbiór walidacyjny czy testowy da nam mało wiarygodne wyniki --- nie da się
nawet powiedzieć, czy zbyt pesymistyczne, czy optymistyczne. W praktyce niestety
często mamy mało danych. Trzeba zatem jakiejś metody, która stworzy nam więcej
zbiorów walidacyjnych z tej samej ilości danych. Taką metodą jest walidacja
skrośna (ang. _cross validation_, CV). Polega na tym, że dzielimy zbiór
treningowy na $K$ równych podzbiorów, tzw. foldów. Każdy podzbiór po kolei
staje się zbiorem walidacyjnym, a pozostałe łączymy w zbiór treningowy.
Trenujemy zatem $K$ modeli dla tego samego zestawu hiperparametrów i każdy
testujemy na zbiorze walidacyjnym. Mamy $K$ wyników dla zbiorów walidacyjnych,
które możemy uśrednić (i ewentualnie obliczyć odchylenie standardowe). Takie
wyniki są znacznie bardziej wiarygodne.

Walidacja krzyżowa bez jednego (ang. _Leave-One-Out Cross-Validation_, LOOCV)
jest metodą iteracyjną, której kroki wyglądają następująco:
- wybieramy kolejny element zbioru obserwacji $(bold(x)_i, y_i)$;
- zbiorem walidacyjnym jest ${(bold(x)_i, y_i)}$, a zbiorem uczącym reszta
  obserwacji;
- metodą zbioru walidacyjnego wyliczamy błąd walidacyjny $E_i$.

Na koniec obliczamy estymatę błędu testowego,
$
  "CV"_((n)) = 1 / n sum_(i=1)^n E_i quad.
$
Korzyściami z zastosowania LOOCV jest redukcja obciążenia --- uczenie modelu
korzysta w każdym kroku z $n - 1$ obserwacji --- w konsekwencji ewentualne
przeszacowanie błędu treningowego jest nieznaczne. Dodatkowo metoda jest
_deterministyczna_ --- wielokrotne uruchomienie daje ten sam wynik.

_Bootstrap_ to metoda statystyczna stosowana do oszacowania niepewności
związanej z danym estymatorem lub metodą uczenia statystycznego. Łatwo stosuje
się w sytuacjach, w których nie ma innych --- lepiej uzasadnionych teoretycznie
--- metod oszacowania zmienności. Mamy do dyspozycji zbiór danych $cal(X)$ o
wielkości $n$, przy pomocy którego wyznaczamy estymatę $hat(alpha)$ pewnej
statystyki $alpha$. Zadanie polega na estymowaniu błędu standardowego
$hat(alpha)$, tzn. $sigma(hat(alpha))$, przy braku możliwości uzyskania nowych
danych. Konstruujemy zbiory danych bootstrap $cal(X)_1, ..., cal(X)_B$ o
wielkości $n$ przez _losowanie ze zwracaniem_ z $cal(X)$ dla pewnego dużego
$B$ i na każdym z $cal(X)_b$ obliczamy estymatę $hat(alpha)_b$. Ostatecznie
błąd standardowy (tzw. _błąd typu bootstrap_) ma postać
$
  m(hat(alpha)) & = 1 / B sum_(b=1)^B hat(alpha)_b quad, \
  sigma(hat(alpha)) & = sqrt(1 / (B - 1) sum_(b=1)^B
                      (hat(alpha)_b - m(hat(alpha)))^2) quad.
$
