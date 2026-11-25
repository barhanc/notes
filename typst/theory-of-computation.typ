// =============================================================================
// Teoria obliczeń
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
#show emph: it => {
  show regex("\S+"): w => box(skew(ax: -12deg, w))
  it.body
}

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

#let redm = $scripts(<=)_m$
#let redmp = $scripts(<=)_m^p$
#let nredmp = $scripts(lt.eq.not)_m^p$

#let machine(title, body) = block(
  width: 100%,
  breakable: false,
  above: 0.9em,
  below: 0.9em,
  inset: (y: 6pt),
  stroke: (top: 0.8pt, bottom: 0.8pt),
)[
  #set par(justify: false, leading: 0.6em)
  *Maszyna:* #title
  #v(-0.4em)
  #line(length: 100%, stroke: 0.4pt)
  #v(-0.1em)
  #body
]

#let def(body) = block(
  width: 100%,
  above: 0.85em,
  below: 0.85em,
  inset: (left: 8pt, y: 1.5pt),
  stroke: (left: 1.3pt + luma(165)),
)[
  *Definicja.* #body
]

#let thm(title: none, body) = block(
  width: 100%,
  breakable: false,
  above: 0.95em,
  below: 0.95em,
  inset: (left: 8pt, right: 6pt, y: 5pt),
  fill: luma(248),
  stroke: (left: 1.8pt + black),
)[
  #if title != none [*Twierdzenie (#title).*] else [*Twierdzenie.*] #body
]

#let proof(body) = block(
  width: 100%,
  above: 0.6em,
  below: 1.0em,
)[
  _Dowód._ #body #h(1fr) $square.stroked$
]

// --- Vector diagram helpers --------------------------------------------------

#let arrow-up(x, y-bottom, y-top) = {
  place(top + left, line(start: (x, y-bottom), end: (x, y-top + 1.6mm), stroke: 0.7pt))
  place(top + left, polygon(
    fill: black,
    (x, y-top),
    (x - 1.1mm, y-top + 2.2mm),
    (x + 1.1mm, y-top + 2.2mm),
  ))
}

#let turing-tape-diagram() = align(center)[
  #block(width: 76mm, height: 26mm, breakable: false)[
    #let cw = 9mm
    #let ch = 8.5mm
    #let sy = 1mm
    #let syms = ($a$, $b$, $a$, $c$, $square.stroked$, $square.stroked$, $square.stroked$)
    #for (i, s) in syms.enumerate() {
      let x = i * cw
      place(top + left, dx: x, dy: sy, rect(
        width: cw,
        height: ch,
        fill: if i == 2 { luma(238) } else { none },
        stroke: 0.65pt,
      )[#align(center + horizon)[#s]])
    }
    #let rx = syms.len() * cw
    #place(top + left, dx: rx, dy: sy, line(start: (0mm, 0mm), end: (11mm, 0mm), stroke: 0.65pt))
    #place(top + left, dx: rx, dy: sy + ch, line(start: (0mm, 0mm), end: (11mm, 0mm), stroke: 0.65pt))
    #place(top + left, dx: rx + 2.5mm, dy: sy + 2.2mm)[$dots.c$]
    #let hx = 2.5 * cw
    #arrow-up(hx, 17mm, sy + ch + 0.6mm)
    #let bw = 18mm
    #let bh = 7.5mm
    #place(top + left, dx: hx - bw / 2, dy: 17mm, rect(
      width: bw,
      height: bh,
      stroke: 0.65pt,
      radius: 1pt,
    )[])
    #place(top + left, dx: hx, dy: 17mm, line(start: (0mm, 0mm), end: (0mm, bh), stroke: 0.65pt))
    #place(top + left, dx: hx - bw / 2, dy: 17mm, box(width: bw / 2, height: bh)[#align(center + horizon)[$q$]])
    #place(top + left, dx: hx, dy: 17mm, box(width: bw / 2, height: bh)[#align(center + horizon)[$delta$]])
  ]
]

#let turing-config-diagram() = align(center)[
  #block(width: 89mm, height: 32mm, breakable: false)[
    #let cw = 9.5mm
    #let ch = 8.5mm
    #let sy = 7mm
    #let syms = ($a_1$, $a_2$, $dots.c$, $a_n$, $b_1$, $b_2$, $dots.c$, $b_k$)
    #place(top + left, dx: 0.6mm, dy: 4.2mm, line(start: (0mm, 1.5mm), end: (0mm, 0mm), stroke: 0.5pt))
    #place(top + left, dx: 0.6mm, dy: 4.2mm, line(start: (0mm, 0mm), end: (4 * cw - 1.2mm, 0mm), stroke: 0.5pt))
    #place(top + left, dx: 4 * cw - 0.6mm, dy: 4.2mm, line(start: (0mm, 0mm), end: (0mm, 1.5mm), stroke: 0.5pt))
    #place(top + left, dx: 0mm, dy: 0mm, box(width: 4 * cw)[#align(center)[#text(9pt)[$alpha$]]])

    #place(top + left, dx: 4 * cw + 0.6mm, dy: 4.2mm, line(start: (0mm, 1.5mm), end: (0mm, 0mm), stroke: 0.5pt))
    #place(top + left, dx: 4 * cw + 0.6mm, dy: 4.2mm, line(start: (0mm, 0mm), end: (4 * cw - 1.2mm, 0mm), stroke: 0.5pt))
    #place(top + left, dx: 8 * cw - 0.6mm, dy: 4.2mm, line(start: (0mm, 0mm), end: (0mm, 1.5mm), stroke: 0.5pt))
    #place(top + left, dx: 4 * cw, dy: 0mm, box(width: 4 * cw)[#align(center)[#text(9pt)[$beta$]]])

    #for (i, s) in syms.enumerate() {
      let x = i * cw
      place(top + left, dx: x, dy: sy, rect(
        width: cw,
        height: ch,
        fill: if i == 4 { luma(238) } else { none },
        stroke: 0.65pt,
      )[#align(center + horizon)[#text(9.5pt)[#s]]])
    }
    #let rx = syms.len() * cw
    #place(top + left, dx: rx, dy: sy, line(start: (0mm, 0mm), end: (11mm, 0mm), stroke: 0.65pt))
    #place(top + left, dx: rx, dy: sy + ch, line(start: (0mm, 0mm), end: (11mm, 0mm), stroke: 0.65pt))
    #place(top + left, dx: rx + 2.5mm, dy: sy + 2.2mm)[$dots.c$]
    #let hx = 4.5 * cw
    #arrow-up(hx, 23mm, sy + ch + 0.6mm)
    #let bw = 18mm
    #let bh = 7.5mm
    #place(top + left, dx: hx - bw / 2, dy: 23mm, rect(
      width: bw,
      height: bh,
      stroke: 0.65pt,
      radius: 1pt,
    )[])
    #place(top + left, dx: hx, dy: 23mm, line(start: (0mm, 0mm), end: (0mm, bh), stroke: 0.65pt))
    #place(top + left, dx: hx - bw / 2, dy: 23mm, box(width: bw / 2, height: bh)[#align(center + horizon)[$q$]])
    #place(top + left, dx: hx, dy: 23mm, box(width: bw / 2, height: bh)[#align(center + horizon)[$delta$]])
  ]
]

#let arithmetical-hierarchy-diagram() = align(center)[
  #block(width: 102mm, height: 50mm, breakable: false)[
    #place(top + left, dx: 1mm, dy: 2mm, rect(
      width: 100mm,
      height: 46mm,
      radius: 10pt,
      stroke: (paint: luma(140), thickness: 0.55pt, dash: "dashed"),
    ))
    #place(top + left, dx: 9mm, dy: 8mm, rect(
      width: 70mm,
      height: 34mm,
      radius: 8pt,
      fill: luma(248),
      stroke: (paint: black, thickness: 0.65pt, dash: "densely-dashed"),
    ))
    #place(top + left, dx: 23mm, dy: 8mm, rect(
      width: 70mm,
      height: 34mm,
      radius: 8pt,
      fill: rgb(0, 0, 0, 8),
      stroke: 0.65pt,
    ))
    #place(top + left, dx: 27mm, dy: 15mm, rect(
      width: 33mm,
      height: 20mm,
      radius: 6pt,
      fill: rgb(0, 0, 0, 10),
      stroke: (paint: black, thickness: 0.65pt, dash: "densely-dashed"),
    ))
    #place(top + left, dx: 42mm, dy: 15mm, rect(
      width: 33mm,
      height: 20mm,
      radius: 6pt,
      fill: rgb(0, 0, 0, 10),
      stroke: 0.65pt,
    ))
    #place(top + left, dx: 42mm, dy: 15mm, rect(
      width: 18mm,
      height: 20mm,
      radius: 5pt,
      fill: luma(230),
      stroke: 0.75pt,
    )[#align(center + horizon)[#text(9.5pt)[$"R"$]]])

    #place(top + left, dx: 27mm, dy: 15mm, box(width: 15mm, height: 20mm)[
      #align(center + horizon)[#text(8.5pt)[$"coRE"$ \ $Pi_1$]]
    ])
    #place(top + left, dx: 60mm, dy: 15mm, box(width: 15mm, height: 20mm)[
      #align(center + horizon)[#text(8.5pt)[$"RE"$ \ $Sigma_1$]]
    ])
    #place(top + left, dx: 10mm, dy: 8mm, box(width: 13mm, height: 34mm)[
      #align(center + horizon)[#text(9pt)[$Pi_2$]]
    ])
    #place(top + left, dx: 79mm, dy: 8mm, box(width: 13mm, height: 34mm)[
      #align(center + horizon)[#text(9pt)[$Sigma_2$]]
    ])
    #place(top + left, dx: 2.2mm, dy: 22.5mm)[#text(9pt)[$dots.c$]]
    #place(top + left, dx: 94.5mm, dy: 22.5mm)[#text(9pt)[$dots.c$]]
  ]
]

#let complexity-hierarchy-diagram() = align(center)[
  #block(width: 104mm, height: 58mm, breakable: false)[
    #place(top + left, dx: 0mm, dy: 0mm, rect(
      width: 104mm,
      height: 58mm,
      radius: 7pt,
      fill: luma(252),
      stroke: 0.7pt,
    ))
    #place(top + left, dx: 88mm, dy: 0mm, box(width: 15mm, height: 58mm)[
      #align(center + horizon)[#text(8.5pt)[$"NEXP"$]]
    ])
    #place(top + left, dx: 4mm, dy: 4mm, rect(
      width: 83mm,
      height: 50mm,
      radius: 6pt,
      fill: luma(247),
      stroke: 0.65pt,
    ))
    #place(top + left, dx: 74mm, dy: 4mm, box(width: 12mm, height: 50mm)[
      #align(center + horizon)[#text(8.5pt)[$"EXP"$]]
    ])
    #place(top + left, dx: 8mm, dy: 8mm, rect(
      width: 65mm,
      height: 42mm,
      radius: 5pt,
      fill: luma(241),
      stroke: 0.65pt,
    ))
    #place(top + left, dx: 8mm, dy: 41.5mm, box(width: 65mm, height: 7.5mm)[
      #align(center + horizon)[#text(8pt)[$"PSPACE" = "NPSPACE"$]]
    ])
    #place(top + left, dx: 12mm, dy: 12mm, rect(
      width: 34mm,
      height: 27mm,
      radius: 5pt,
      fill: rgb(0, 0, 0, 8),
      stroke: (paint: black, thickness: 0.65pt, dash: "densely-dashed"),
    ))
    #place(top + left, dx: 35mm, dy: 12mm, rect(
      width: 34mm,
      height: 27mm,
      radius: 5pt,
      fill: rgb(0, 0, 0, 8),
      stroke: 0.65pt,
    ))
    #place(top + left, dx: 36.5mm, dy: 18.5mm, rect(
      width: 8mm,
      height: 14mm,
      radius: 3pt,
      fill: luma(222),
      stroke: 0.75pt,
    )[#align(center + horizon)[#text(8.5pt)[$"P"$]]])

    #place(top + left, dx: 12mm, dy: 12mm, box(width: 23mm, height: 27mm)[
      #align(center + horizon)[#text(8.5pt)[$"coNP"$]]
    ])
    #place(top + left, dx: 46mm, dy: 12mm, box(width: 23mm, height: 27mm)[
      #align(center + horizon)[#text(8.5pt)[$"NP"$]]
    ])
  ]
]

#let np-possible-diagram() = align(center)[
  #block(width: 96mm, height: 34mm, breakable: false)[
    #place(top + left, dx: 4mm, dy: 6mm, rect(
      width: 26mm,
      height: 22mm,
      radius: 7pt,
      fill: luma(236),
      stroke: 0.7pt,
    )[#align(center + horizon)[#text(9pt)[$"P" = "NP"$]]])

    #place(top + left, dx: 31mm, dy: 6mm, box(width: 14mm, height: 22mm)[
      #align(center + horizon)[#text(9pt)[lub]]
    ])

    #place(top + left, dx: 46mm, dy: 1mm, rect(
      width: 46mm,
      height: 32mm,
      radius: 7pt,
      fill: luma(250),
      stroke: 0.7pt,
    ))
    #place(top + left, dx: 82mm, dy: 2.5mm)[#text(8pt)[$"NP"$]]
    #place(top + left, dx: 51mm, dy: 5mm, rect(
      width: 26mm,
      height: 9mm,
      radius: 4pt,
      fill: luma(234),
      stroke: 0.65pt,
    )[#align(center + horizon)[#text(8.5pt)[$"NP-com"$]]])
    #place(top + left, dx: 55mm, dy: 20mm, rect(
      width: 18mm,
      height: 9mm,
      radius: 4pt,
      fill: luma(234),
      stroke: 0.65pt,
    )[#align(center + horizon)[#text(8.5pt)[$"P"$]]])
  ]
]

#let np-impossible-diagram() = align(center)[
  #block(width: 56mm, height: 26mm, breakable: false)[
    #place(top + left, dx: 5mm, dy: 3mm, rect(
      width: 46mm,
      height: 20mm,
      radius: 5pt,
      fill: luma(244),
      stroke: 0.7pt,
    ))
    #place(top + left, dx: 25mm, dy: 3mm, line(start: (0mm, 0mm), end: (0mm, 20mm), stroke: 0.7pt))
    #place(top + left, dx: 5mm, dy: 3mm, box(width: 20mm, height: 20mm)[
      #align(center + horizon)[#text(9pt)[$"P"$]]
    ])
    #place(top + left, dx: 25mm, dy: 3mm, box(width: 26mm, height: 20mm)[
      #align(center + horizon)[#text(9pt)[$"NP-com"$]]
    ])
    #place(top + left, dx: 52.5mm, dy: 4mm)[#text(8pt)[$"NP"$]]
    #place(top + left, line(start: (3mm, 1.5mm), end: (53mm, 24.5mm), stroke: (paint: luma(120), thickness: 0.6pt, dash: "dashed")))
    #place(top + left, line(start: (3mm, 24.5mm), end: (53mm, 1.5mm), stroke: (paint: luma(120), thickness: 0.6pt, dash: "dashed")))
  ]
]

#align(center)[
  #text(16pt, strong("Teoria Obliczeń"))
]
#v(0.8em)

#outline()

= Podstawowe pojęcia

#def[Problem decyzyjny to para $Pi = (D_Pi, Y_Pi)$, gdzie $D_Pi$ to zbiór
"egzemplarzy" problemu, a $Y_Pi subset.eq D_Pi$ to zbiór "egzemplarzy" z
odpowiedzią "TAK".]

#def[Alfabet $Sigma$ to dowolny skończony i niepusty zbiór symboli. W
szczególności jeśli $|Sigma| = 1$, to alfabet nazwiemy *unarnym*.]

#def[Słowo nad alfabetem $Sigma$ to dowolny skończony ciąg symboli. W
szczególności przez $epsilon$ będziemy oznaczać słowo puste.]

#def[Język $L$ nad alfabetem $Sigma$ to dowolny zbiór słów nad $Sigma$.]

Jeśli $A$, $B$ są językami, to:
- $A union B = {x | x in A or x in B}$ nazywamy sumą języków,
- $A inter B = {x | x in A and x in B}$ nazywamy przecięciem języków,
- $A B = {x y | x in A and y in B}$ nazywamy konkatenacją języków,
- $A^* = {epsilon} union A union A^2 union dots.c$ nazywamy domknięciem języka
  (inaczej domknięciem Kleenego).

W szczególności $Sigma^*$ oznacza zbiór wszystkich słów nad $Sigma$. Dodatkowo
wprowadzamy oznaczenie $Sigma^+ := Sigma Sigma^*$.

Każdy język $L$ definiuje problem decyzyjny postaci: _czy $x in Sigma^*$ należy
do $L$?_ Jednocześnie każdy "sensowny" problem decyzyjny definiuje pewien język,
przy założeniu, iż istnieje "efektywna" funkcja $chevron.l dot.c chevron.r$
kodująca problem w danym alfabecie $Sigma$.

= Teoria obliczeń

== Maszyna Turinga

#def[Maszyna Turinga $M$ to krotka $(Sigma, Gamma, Q, delta, q_S, q_Y, q_N, square.stroked)$, gdzie:
- $Sigma$ --- alfabet wejściowy,
- $Gamma$ --- alfabet roboczy, taki że $Sigma subset.eq Gamma$,
- $square.stroked$ --- specjalny symbol pusty (zwany _blankiem_), o którym
  zakładamy, iż $square.stroked in Gamma$ i $square.stroked in.not Sigma$,
- $Q$ --- skończony i niepusty zbiór stanów,
- $q_S$ --- stan początkowy, $q_S in Q$,
- $q_Y$ --- stan akceptujący, $q_Y in Q$,
- $q_N$ --- stan odrzucający, $q_N in Q$,
- $delta: Gamma times Q -> Gamma times Q times {<-, ->}$ --- funkcja przejścia.]

Maszynę Turinga możemy wyobrażać sobie jako składającą się z nieskończonej w
prawo taśmy podzielonej na komórki oraz głowicy przechowującej stan $q$, która
może czytać oraz pisać symbole z alfabetu roboczego do komórki, na którą w danym
momencie wskazuje. Początkowo na taśmie zapisane jest słowo wejściowe
$w in Sigma^*$ i zakładamy, iż pozostałe komórki zawierają symbol blank
$square.stroked$. Głowica będąc w stanie $q$ i czytając z komórki taśmy symbol
$a in Gamma$ wpisuje do tej komórki symbol $b$, zmienia stan na $q'$ i przechodzi
w prawo lub lewo zgodnie z wartością funkcji przejścia
$delta(a, q) = (b, q', <- "lub" ->)$.

#v(0.4em)
#turing-tape-diagram()
#v(0.4em)

#def[Konfiguracją maszyny $M$ nazywamy dowolny napis postaci $alpha q beta$,
gdzie $alpha in Gamma^*$, $q in Q$ i $beta in Gamma^+$, przy czym w zapisie
słowa $beta$ pomijamy nieskończenie wiele symboli blank. Zapis taki oznacza, iż
głowica maszyny wskazuje na pierwszy symbol słowa $beta = b_1 dots.c b_k$, po
lewej stronie którego zapisane na taśmie jest słowo $alpha = a_1 dots.c a_n$, a
maszyna znajduje się w stanie $q$.]

#v(0.4em)
#turing-config-diagram()
#v(0.4em)

#def[Mówimy, że maszyna $M$ akceptuje słowo $x = x_1 dots.c x_n in Sigma^*$
wtedy i tylko wtedy, gdy istnieje skończony ciąg konfiguracji, takich że
pierwszym elementem ciągu jest $epsilon q_S x_1 dots.c x_n$, ostatnim ---
$alpha q_Y beta$ dla pewnych $alpha in Gamma^*$, $beta in Gamma^+$ oraz dla
dowolnej konfiguracji $k_t$ będącej elementem ciągu maszyna może w jednym kroku
przejść z konfiguracji $k_t$ do konfiguracji $k_(t+1)$. Jeśli $M$ nie akceptuje i
nie odrzuca wprost słowa $x$, to mówimy, że $M$ odrzuca $x$ przez działanie w
nieskończoność.]

#def[Mówimy, że maszyna $M$ akceptuje język $L$ wtedy i tylko wtedy, gdy dla
każdego $x in Sigma^*$, $M$ akceptuje $x$ wtedy i tylko wtedy, gdy $x in L$.]

#def[Mówimy, że maszyna $M$ rozstrzyga o języku $L$ wtedy i tylko wtedy, gdy
akceptuje język $L$ oraz kończy działanie na każdym słowie.]

== Klasy języków

Dla danej maszyny $M$ przez $L(M)$ oznaczymy język akceptowany przez $M$.
Definiujemy następujące klasy języków:
- $"R" := {L subset.eq Sigma^* | exists M : M "rozstrzyga o" L}$,
- $"RE" := {L subset.eq Sigma^* | exists M : M "akceptuje" L}$,
- $"coRE" := {L' | L in "RE"}$.

Języki należące do klasy $"RE"$ nazywamy rekurencyjnie przeliczalnymi, a języki
należące do klasy $"R"$ --- rozstrzygalnymi. Zauważmy, że każdy język skończony
$L = {x_1, dots.c, x_n}$ jest rozstrzygalny, gdyż możemy skonstruować maszynę
Turinga, która o nim rozstrzyga:

#machine[$M(x)$ dla skończonego języka $L = {x_1, dots.c, x_n}$][
  *if* $x = x_1$: *accept* \
  *elif* $x = x_2$: *accept* \
  $dots.v$ \
  *elif* $x = x_n$: *accept* \
  *else*: *reject*
]

Zauważmy, iż taka konstrukcja nie działa, gdy język jest nieskończony, gdyż
wówczas "kod" maszyny Turinga byłby nieskończony.

#thm[$"RE" inter "coRE" = "R"$.]

#proof[Niech $L subset.eq Sigma^*$ będzie dowolnym językiem nad alfabetem
$Sigma$. Załóżmy wpierw, iż $L in "RE" inter "coRE"$; wówczas z definicji klas
$"RE"$ i $"coRE"$ istnieją maszyny $M_L$ i $M_(L')$ takie, że $M_L$ akceptuje
$L$ i $M_(L')$ akceptuje $L'$. Skonstruujemy maszynę $M$ rozstrzygającą o $L$:

#machine[$M(x)$ rozstrzygająca o $L in "RE" inter "coRE"$][
  *for* $k = 1, 2, dots.c$:
  #pad(left: 1.2em)[
    *if* $M_L (x)$ akceptuje w co najwyżej $k$ krokach: *accept* \
    *if* $M_(L') (x)$ akceptuje w co najwyżej $k$ krokach: *reject*
  ]
]

Zauważmy, że każde słowo $x in Sigma^*$ jest akceptowane przez dokładnie jedną z
maszyn $M_L$, $M_(L')$, zatem dla wystarczająco dużej liczby kroków $k$
dokładnie jeden z warunków będzie prawdziwy i maszyna $M$ rozstrzygnie o słowie
$x$, przy czym zaakceptuje je wtedy i tylko wtedy, gdy $x in L$. W takim razie
pokazaliśmy, iż $forall L subset.eq Sigma^* : L in "RE" inter "coRE" ==> L in "R"$.

Załóżmy teraz natomiast, iż $L in "R"$; wówczas z definicji istnieje maszyna
$M$, która rozstrzyga o $L$. Skonstruujemy maszyny $M_L$ i $M_(L')$ akceptujące
odpowiednio języki $L$ i $L'$:

#machine[$M_L (x)$ oraz $M_(L') (x)$ dla $L in "R"$][
  $M_L (x)$:
  #pad(left: 1.2em)[
    *if* $M(x)$ akceptuje: *accept* \
    *else*: *reject*
  ]
  #v(0.2em)
  $M_(L') (x)$:
  #pad(left: 1.2em)[
    *if* $M(x)$ akceptuje: *reject* \
    *else*: *accept*
  ]
]

Oczywiście maszyna $M$ kończy działanie dla każdego wejścia $x$ i akceptuje
tylko słowa z języka $L$. Maszyna $M_L$ akceptuje zatem język $L$, a maszyna
$M_(L')$ nie akceptuje żadnego słowa z języka $L$ i akceptuje każde inne słowo,
czyli akceptuje język $L'$. W takim razie
$forall L subset.eq Sigma^* : L in "R" ==> L in "RE" and L in "coRE" <==> L in "RE" inter "coRE"$.
Z powyższego otrzymujemy tezę.]

== Teza Churcha--Turinga

#block(
  width: 100%,
  above: 0.6em,
  below: 0.6em,
  inset: (left: 8pt, right: 6pt, y: 5pt),
  fill: luma(248),
  stroke: (left: 1.8pt + black),
)[
  *Pojęcie maszyny Turinga jest równoważne intuicyjnemu pojęciu algorytmu.*
]

== Uniwersalna Maszyna Turinga

Uniwersalna Maszyna Turinga $U$, mając na wejściu zakodowaną maszynę $M$ oraz
słowo $x$, tj. $chevron.l M, x chevron.r$, symuluje działanie maszyny $M$ dla
wejścia $x$. Jest to model komputera z programem przechowywanym w pamięci.
Ustalmy alfabet $Sigma = {0, 1, "#"} $. Kodowanie maszyny $M$ możemy
przedstawić jako
$
  chevron.l M chevron.r = chevron.l Gamma chevron.r "#" chevron.l Q chevron.r "#" chevron.l delta chevron.r "##" quad,
$
gdzie $chevron.l Gamma chevron.r = chevron.l |Gamma| chevron.r$ i
$chevron.l Q chevron.r = chevron.l |Q| chevron.r$ to kodowania binarne liczby
symboli w alfabecie roboczym i liczby stanów, natomiast
$
  chevron.l delta chevron.r = chevron.l & "ciąg kolejnych napisów postaci" chevron.l delta(a, q) chevron.r \
                                        & "dla" q in Q, a in Gamma chevron.r quad.
$

== Problem stopu i redukcje

Problem stopu definiujemy jako język
$
  H := {chevron.l M, x chevron.r | M "akceptuje" x} quad.
$

#thm[Problem stopu jest nierozstrzygalny, $H in.not "R"$.]

#thm(title: "Rice'a")[Niech $cal(L) subset.eq "RE"$ będzie pewnym podzbiorem
klasy $"RE"$. Mówimy, że język $L in "RE"$ ma własność $cal(L)$ wtedy i tylko
wtedy, gdy $L in cal(L)$. Jeśli $cal(L) != emptyset$ i $cal(L) != "RE"$, to język
$
  B_cal(L) := {chevron.l M chevron.r | L(M) in cal(L)}
$
jest nierozstrzygalny.]

Twierdzenie to mówi, iż niemal każdy język dotyczący własności języków
akceptowanych przez maszynę Turinga jest nierozstrzygalny.

#def[Niech $f: Sigma^* -> Sigma^*$. Mówimy, że funkcja $f$ jest obliczalna wtedy
i tylko wtedy, gdy istnieje maszyna Turinga $M$ taka, że dla każdego słowa
$x in Sigma^*$, $M$ kończy działanie w konfiguracji $epsilon q_Y f(x)$.]

#def[Mówimy, że język $A$ redukuje się do języka $B$, co zapisujemy jako
$A redm B$, wtedy i tylko wtedy, gdy istnieje obliczalna funkcja $f$ taka, że
$
  forall x in Sigma^* : x in A <==> f(x) in B quad.
$]

Indeks dolny $m$ określa redukcję _many-to-one_, tzn. wiele (nawet wszystkie)
słów z języka $A$ może być odwzorowywanych do jednego słowa z języka $B$. Jeśli
$A redm B$, to możemy mówić, iż $A$ jest nietrudniejszy (inaczej co najwyżej tak
trudny) niż $B$. Istotnie, jeśli umiemy rozwiązać problem $B$, to umiemy
rozwiązać problem $A$ przez odwzorowanie słowa z tego języka do słowa z języka
$B$. Własności redukcji:
- jeśli $A redm B$ oraz $B in "R"$, to $A in "R"$,
- jeśli $A redm B$ oraz $B in "RE"$, to $A in "RE"$,
- jeśli $A redm B$ oraz $A in.not "R"$, to $B in.not "R"$.

#def[Mówimy, że język $B$ jest $"RE"$-trudny wtedy i tylko wtedy, gdy dla
każdego języka $A in "RE"$ zachodzi $A redm B$.]

#def[Mówimy, że język $B$ jest $"RE"$-zupełny wtedy i tylko wtedy, gdy jest
$"RE"$-trudny i $B in "RE"$.]

#thm[Język $H$ jest $"RE"$-zupełny, $H in "RE-com"$.]

Ogólną technikę dowodzenia $"RE"$-zupełności możemy zatem zapisać następująco:
- mamy dany język $C$, o którym chcemy udowodnić, iż jest $"RE-com"$,
- wiemy, że język $B$ jest $"RE-com"$,
- pokazujemy, że $C in "RE"$,
- pokazujemy, że $B redm C$; wówczas z przechodniości relacji $redm$ mamy, iż
  dla każdego $A in "RE"$, $A redm B redm C$, co wraz z punktem wyżej dowodzi
  $C in "RE-com"$.

#thm[Język $A in "RE"$ wtedy i tylko wtedy, gdy istnieje język $B in "R"$ taki, że
$
  A = {x | exists y in Sigma^* : chevron.l x, y chevron.r in B} quad.
$]

== Hierarchia arytmetyczna

#def[Powiemy, iż język $A subset.eq Sigma^*$ należy do klasy $Sigma_i$ dla
$i >= 1$ wtedy i tylko wtedy, gdy istnieje język $B in "R"$ taki, że
$
  A = {x | exists y_1 : forall y_2 : dots.c : Q_i y_i : chevron.l x, y_1, dots.c, y_i chevron.r in B} quad,
$
gdzie $Q_i = exists$ jeśli $i$ nieparzyste i $Q_i = forall$ jeśli $i$ parzyste.
Dodatkowo powiemy, iż język $A$ należy do klasy $Pi_i$ wtedy i tylko wtedy, gdy
$A' in Sigma_i$.]

Zauważmy, że z definicji tej i poprzedniego twierdzenia wynika, iż
$Sigma_1 = "RE"$ oraz $Pi_1 = "coRE"$. Zdefiniowane klasy tworzą nieskończoną
hierarchię, w której
$
  Sigma_(i-1) subset.eq Sigma_i inter Pi_i quad, quad
  Pi_(i-1) subset.eq Sigma_i inter Pi_i quad,
$
gdzie $i >= 1$ oraz $Sigma_0 = Pi_0 = "R"$.

#v(0.4em)
#arithmetical-hierarchy-diagram()
#v(0.4em)

= Teoria złożoności obliczeniowej

== Klasy deterministyczne

#def[Niech $M$ będzie maszyną Turinga. Złożoność czasowa $M$ to funkcja
$f: NN -> NN$ taka, że maksymalna liczba kroków $M$ na wejściu $x$ wynosi
$f(|x|)$.]

#def[Niech $M$ będzie maszyną Turinga. Złożoność pamięciowa $M$ to funkcja
$f: NN -> NN$ taka, że maksymalna liczba wykorzystanych komórek pamięci $M$ na
wejściu $x$ wynosi $f(|x|)$.]

#def[$"TIME"[t(n)]$ to zbiór języków $L$, dla których istnieje maszyna $M$
rozstrzygająca o $L$ w czasie $O(t(n))$.]

#def[$"SPACE"[s(n)]$ to zbiór języków $L$, dla których istnieje maszyna $M$
rozstrzygająca o $L$ w pamięci $O(s(n))$.]

Na podstawie powyższych pojęć definiujemy klasy złożoności:
$
  "P" & = union.big_(k=0)^oo "TIME"(n^k) quad, \
  "EXP" & = union.big_(k=0)^oo "TIME"(2^(n^k)) quad, \
  "PSPACE" & = union.big_(k=0)^oo "SPACE"(n^k) quad, \
  "EXPSPACE" & = union.big_(k=0)^oo "SPACE"(2^(n^k)) quad.
$

== Niedeterministyczna Maszyna Turinga

#def[Niedeterministyczna Maszyna Turinga (NMT) to krotka
$(Sigma, Gamma, Q, delta, q_S, q_Y, q_N, square.stroked)$, gdzie wszystkie
elementy są takie jak w Standardowej Maszynie Turinga (SMT) poza $delta$, która
teraz jest relacją
$
  delta subset.eq (Gamma times Q backslash {q_Y, q_N}) times (Gamma times Q times {<-, ->}) quad.
$]

Widząc dany symbol i będąc w danym stanie, NMT może:
- mieć dokładnie jedną drogę kontynuowania obliczeń,
- mieć więcej niż jedną drogę kontynuowania obliczeń,
- nie mieć żadnego możliwego ruchu (przyjmujemy, że jest to konfiguracja
  odrzucająca).

#def[Mówimy, iż NMT $M$ akceptuje słowo $x$ w $k$ krokach wtedy i tylko wtedy, gdy:
- każda ścieżka obliczeń na $x$ wymaga najwyżej $k$ kroków,
- co najmniej jedna ścieżka akceptuje w $k$ krokach.]

#def[Mówimy, iż NMT $M$ odrzuca słowo $x$ w $k$ krokach wtedy i tylko wtedy, gdy:
- każda ścieżka obliczeń na $x$ wymaga najwyżej $k$ kroków,
- wszystkie ścieżki odrzucają w $k$ krokach.]

#def[Niech $f: NN -> NN$. Mówimy, że NMT $M$ rozstrzyga o $L$ w czasie $f(n)$
wtedy i tylko wtedy, gdy $M$ akceptuje $x in Sigma^*$ wtedy i tylko wtedy, gdy
$x in L$ oraz dla wszystkich $x in Sigma^*$ wszystkie ścieżki obliczeniowe $M$
na $x$ mają najwyżej $f(|x|)$ kroków.]

#def[$"NTIME"[t(n)]$ to zbiór języków $L$, dla których istnieje NMT $M$
rozstrzygająca o $L$ w czasie $O(t(n))$.]

Analogicznie do klas deterministycznych definiujemy:
$
  "NP" & = union.big_(k=0)^oo "NTIME"(n^k) quad, \
  "NEXP" & = union.big_(k=0)^oo "NTIME"(2^(n^k)) quad.
$

== Języki rzadkie i struktura klasy NP

#def[Mówimy, że język $L$ jest rzadki wtedy i tylko wtedy, gdy istnieje
wielomian $p$ taki, że $forall n in NN : |L^(<= n)| <= p(n)$.]

#def[Mówimy, że język $L$ jest unarny wtedy i tylko wtedy, gdy
$L subset.eq {0}^*$.]

#thm[Każdy język unarny jest rzadki.]

#thm(title: "Mahaney, 1982")[Jeśli istnieje $"NP"$-trudny język rzadki, to
$"P" = "NP"$.]

Zależności między podstawowymi klasami złożoności obliczeniowej ilustruje
poniższy diagram:

#v(0.4em)
#complexity-hierarchy-diagram()
#v(0.4em)

W szczególności wnętrze klasy $"NP"$ może wyglądać tylko w jeden z dwóch
sposobów:

#v(0.4em)
#np-possible-diagram()
#v(0.4em)

a nie może wyglądać tak:

#v(0.4em)
#np-impossible-diagram()
#v(0.4em)

#thm[Jeśli $"P" != "NP"$, to istnieje język $A$ taki, że $A in "NP"$,
$A in.not "P"$, $A in.not "NP-com"$.]

#thm[Jeśli $"P" = "NP"$, to $"EXP" = "NEXP"$.]

#thm(title: "Ladner")[Dla każdego języka $B in.not "P"$ istnieje język
$A in "P"$ taki, że:
- $A inter B in.not "P"$,
- $A inter B redmp B$,
- $B nredmp A inter B$.]

Symbol $redmp$ oznacza redukcję wiele-do-jeden w czasie wielomianowym, tzn. do
własności obliczalności funkcji redukującej dorzucamy jeszcze wymóg, aby była
obliczalna w czasie wielomianowym.
