// =============================================================================
// Theory of Computation
// =============================================================================

#set page(paper: "a5", margin: (x: 18mm, top: 22mm, bottom: 20mm), numbering: "1")
#set text(font: "Concrete Math", lang: "en")
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
  *Machine:* #title
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
  *Definition.* #body
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
  #if title != none [*Theorem (#title).*] else [*Theorem.*] #body
]

#let proof(body) = block(
  width: 100%,
  above: 0.6em,
  below: 1.0em,
)[
  _Proof._ #body #h(1fr) $square.stroked$
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
      #align(center + horizon)[#text(9pt)[or]]
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
  #text(16pt, strong("Theory of Computation"))
]
#v(0.8em)

#outline()

= Preliminaries

#def[A decision problem is a pair $Pi = (D_Pi, Y_Pi)$, where $D_Pi$ is the set
of problem instances and $Y_Pi subset.eq D_Pi$ is the set of "YES" instances.]

#def[An alphabet $Sigma$ is any finite, non-empty set of symbols. In particular,
if $|Sigma| = 1$, we call the alphabet *unary*.]

#def[A word (or string) over an alphabet $Sigma$ is any finite sequence of
symbols from $Sigma$. In particular, we denote the empty word by $epsilon$.]

#def[A language $L$ over an alphabet $Sigma$ is any set of words over $Sigma$.]

If $A$ and $B$ are languages, then:
- $A union B = {x | x in A or x in B}$ is the union of languages,
- $A inter B = {x | x in A and x in B}$ is the intersection of languages,
- $A B = {x y | x in A and y in B}$ is the concatenation of languages,
- $A^* = {epsilon} union A union A^2 union dots.c$ is the Kleene closure (star)
  of $A$.

In particular, $Sigma^*$ denotes the set of all words over $Sigma$. We also
define $Sigma^+ := Sigma Sigma^*$ and write $L' := Sigma^* backslash L$ for the
complement of a language $L$.

Every language $L$ defines a decision problem of the form: _does $x in Sigma^*$
belong to $L$?_ Conversely, every "reasonable" decision problem defines a
language, assuming there is an "effective" encoding function
$chevron.l dot.c chevron.r$ mapping problem instances to strings over $Sigma$.

= Computability Theory

== Turing Machines

#def[A Turing Machine $M$ is a tuple
$(Sigma, Gamma, Q, delta, q_S, q_Y, q_N, square.stroked)$, where:
- $Sigma$ --- input alphabet,
- $Gamma$ --- tape alphabet, with $Sigma subset.eq Gamma$,
- $square.stroked$ --- special blank symbol, assuming $square.stroked in Gamma$
  and $square.stroked in.not Sigma$,
- $Q$ --- finite, non-empty set of states,
- $q_S in Q$ --- start state,
- $q_Y in Q$ --- accepting state,
- $q_N in Q$ --- rejecting state ($q_Y != q_N$),
- $delta: Gamma times (Q backslash {q_Y, q_N}) -> Gamma times Q times {<-, ->}$
  --- transition function.]

We can picture a Turing Machine as consisting of a tape infinite to the right,
divided into cells, together with a read/write head holding a state $q$ that
reads and writes symbols from $Gamma$ at the cell it currently points to.
Initially, the input word $w in Sigma^*$ is written at the beginning of the
tape, and all remaining cells contain the blank symbol $square.stroked$. When
the head is in state $q$ and reads $a in Gamma$, it writes $b$, transitions to
state $q'$, and moves left or right according to
$delta(a, q) = (b, q', <- "or" ->)$.

#v(0.4em)
#turing-tape-diagram()
#v(0.4em)

#def[A configuration of a machine $M$ is any string of the form $alpha q beta$,
where $alpha in Gamma^*$, $q in Q$, and $beta in Gamma^+$, omitting the
infinitely many trailing blank symbols in $beta$. This notation means that the
head points to the first symbol of $beta = b_1 dots.c b_k$, to the left of
which the tape holds $alpha = a_1 dots.c a_n$, and the machine is in state $q$.]

#v(0.4em)
#turing-config-diagram()
#v(0.4em)

#def[We say that a machine $M$ accepts a word $x = x_1 dots.c x_n in Sigma^*$
if and only if there exists a finite sequence of configurations starting with
$epsilon q_S x$ (or $epsilon q_S square.stroked$ when $x = epsilon$), ending
with $alpha q_Y beta$ for some $alpha in Gamma^*$ and $beta in Gamma^+$, such
that for every step $t$ the machine can transition from configuration $k_t$ to
$k_(t+1)$ in a single step. If $M$ neither accepts nor enters $q_N$ on $x$, we
say that $M$ rejects $x$ by looping forever.]

#def[We say that a machine $M$ accepts (recognizes) a language $L$ if and only
if for every $x in Sigma^*$, $M$ accepts $x$ if and only if $x in L$.]

#def[We say that a machine $M$ decides a language $L$ if and only if $M$
accepts $L$ and halts on every input word.]

== Language Classes

For a given machine $M$, let $L(M)$ denote the language accepted by $M$. We
define the following classes of languages:
- $"R" := {L subset.eq Sigma^* | exists M : M "decides" L}$,
- $"RE" := {L subset.eq Sigma^* | exists M : M "accepts" L}$,
- $"coRE" := {L' | L in "RE"}$.

Languages in $"RE"$ are called _recursively enumerable_ (or _recognizable_),
and languages in $"R"$ are called _decidable_ (or _recursive_). Notice that
every finite language $L = {x_1, dots.c, x_n}$ is decidable, since we can build a
Turing Machine that decides it:

#machine[$M(x)$ for a finite language $L = {x_1, dots.c, x_n}$][
  *if* $x = x_1$: *accept* \
  *elif* $x = x_2$: *accept* \
  $dots.v$ \
  *elif* $x = x_n$: *accept* \
  *else*: *reject*
]

Note that this construction fails when $L$ is infinite, because the finite
description of the Turing Machine could not list infinitely many words.

#thm[$"RE" inter "coRE" = "R"$.]

#proof[Let $L subset.eq Sigma^*$ be any language over $Sigma$. First suppose
that $L in "RE" inter "coRE"$. By definition, there exist machines $M_L$ and
$M_(L')$ accepting $L$ and $L'$, respectively. We construct a machine $M$ that
decides $L$:

#machine[$M(x)$ deciding $L in "RE" inter "coRE"$][
  *for* $k = 1, 2, dots.c$:
  #pad(left: 1.2em)[
    *if* $M_L (x)$ accepts in at most $k$ steps: *accept* \
    *if* $M_(L') (x)$ accepts in at most $k$ steps: *reject*
  ]
]

Every word $x in Sigma^*$ is accepted by exactly one of $M_L$ and $M_(L')$.
Hence, for sufficiently large $k$, exactly one condition holds and $M$ halts
with the correct answer, accepting $x$ if and only if $x in L$. Thus
$forall L subset.eq Sigma^* : L in "RE" inter "coRE" ==> L in "R"$.

Conversely, suppose that $L in "R"$, so there exists a machine $M$ that decides
$L$. We construct machines $M_L$ and $M_(L')$ accepting $L$ and $L'$:

#machine[$M_L (x)$ and $M_(L') (x)$ for $L in "R"$][
  $M_L (x)$:
  #pad(left: 1.2em)[
    *if* $M(x)$ accepts: *accept* \
    *else*: *reject*
  ]
  #v(0.2em)
  $M_(L') (x)$:
  #pad(left: 1.2em)[
    *if* $M(x)$ accepts: *reject* \
    *else*: *accept*
  ]
]

Since $M$ halts on every input $x$ and accepts exactly the words in $L$, $M_L$
accepts $L$ and $M_(L')$ accepts $L'$. Therefore
$forall L subset.eq Sigma^* : L in "R" ==> L in "RE" and L in "coRE" <==> L in "RE" inter "coRE"$,
completing the proof.]

== Church--Turing Thesis

#block(
  width: 100%,
  above: 0.6em,
  below: 0.6em,
  inset: (left: 8pt, right: 6pt, y: 5pt),
  fill: luma(248),
  stroke: (left: 1.8pt + black),
)[
  *The formal notion of a Turing Machine is equivalent to the intuitive notion
  of an algorithm.*
]

== Universal Turing Machine

A Universal Turing Machine $U$ takes as input an encoded machine $M$ together
with an input word $x$, written $chevron.l M, x chevron.r$, and simulates the
execution of $M$ on $x$. It is the theoretical model of a stored-program
computer. Fixing the alphabet $Sigma = {0, 1, "#"} $, we can encode $M$ as
$
  chevron.l M chevron.r = chevron.l Gamma chevron.r "#" chevron.l Q chevron.r "#" chevron.l delta chevron.r "##" quad,
$
where $chevron.l Gamma chevron.r = chevron.l |Gamma| chevron.r$ and
$chevron.l Q chevron.r = chevron.l |Q| chevron.r$ are binary encodings of the
tape-alphabet size and the number of states, and
$
  chevron.l delta chevron.r = chevron.l & "sequence of encoded transitions" chevron.l delta(a, q) chevron.r \
                                        & "for" q in Q backslash {q_Y, q_N}, a in Gamma chevron.r quad.
$

== The Halting Problem and Reductions

We define the halting problem as the language
$
  H := {chevron.l M, x chevron.r | M "halts on" x}
$
(similarly, the acceptance problem $A_"TM" := {chevron.l M, x chevron.r | M "accepts" x}$
shares the same decidability and completeness properties below).

#thm[The halting problem is undecidable, $H in.not "R"$.]

#thm(title: "Rice's Theorem")[Let $cal(L) subset.eq "RE"$ be a subset of
$"RE"$. We say that a language $L in "RE"$ has property $cal(L)$ if and only if
$L in cal(L)$. Whenever $cal(L) != emptyset$ and $cal(L) != "RE"$, the language
$
  B_cal(L) := {chevron.l M chevron.r | L(M) in cal(L)}
$
is undecidable.]

This theorem states that every non-trivial semantic property of the language
recognized by a Turing Machine is undecidable.

#def[Let $f: Sigma^* -> Sigma^*$. We say that $f$ is computable if and only if
there exists a Turing Machine $M$ that, on every input $x in Sigma^*$, halts
with $f(x)$ written on the tape starting at the head (configuration
$epsilon q_Y f(x)$, or $epsilon q_Y square.stroked$ when $f(x) = epsilon$).]

#def[We say that a language $A$ reduces to a language $B$, written $A redm B$,
if and only if there exists a computable function $f$ such that
$
  forall x in Sigma^* : x in A <==> f(x) in B quad.
$]

The subscript $m$ denotes a _many-to-one_ reduction, meaning multiple (even all)
words from $A$ may map to the same word in $B$. If $A redm B$, then $A$ is no
harder than $B$: any solver for $B$ immediately yields a solver for $A$ by first
applying $f$. Key properties of reductions:
- if $A redm B$ and $B in "R"$, then $A in "R"$,
- if $A redm B$ and $B in "RE"$, then $A in "RE"$,
- if $A redm B$ and $A in.not "R"$, then $B in.not "R"$.

#def[A language $B$ is $"RE"$-hard if and only if $A redm B$ for every language
$A in "RE"$.]

#def[A language $B$ is $"RE"$-complete if and only if it is $"RE"$-hard and
$B in "RE"$.]

#thm[The halting language $H$ is $"RE"$-complete, $H in "RE-com"$.]

The standard template for proving that a language $C$ is $"RE"$-complete is
therefore:
- take a known $"RE"$-complete language $B in "RE-com"$,
- show that $C in "RE"$,
- show that $B redm C$; by transitivity of $redm$, for every $A in "RE"$ we
  have $A redm B redm C$, which together with $C in "RE"$ establishes
  $C in "RE-com"$.

#thm[A language $A$ belongs to $"RE"$ if and only if there exists a decidable
language $B in "R"$ such that
$
  A = {x | exists y in Sigma^* : chevron.l x, y chevron.r in B} quad.
$]

== The Arithmetical Hierarchy

#def[A language $A subset.eq Sigma^*$ belongs to the class $Sigma_i$ for
$i >= 1$ if and only if there exists $B in "R"$ such that
$
  A = {x | exists y_1 : forall y_2 : dots.c : Q_i y_i : chevron.l x, y_1, dots.c, y_i chevron.r in B} quad,
$
where $Q_i = exists$ if $i$ is odd and $Q_i = forall$ if $i$ is even.
Furthermore, $A$ belongs to $Pi_i$ if and only if $A' in Sigma_i$.]

From this definition and the preceding theorem it follows that $Sigma_1 = "RE"$
and $Pi_1 = "coRE"$. These classes form an infinite hierarchy satisfying
$
  Sigma_(i-1) subset.eq Sigma_i inter Pi_i quad, quad
  Pi_(i-1) subset.eq Sigma_i inter Pi_i quad,
$
where $i >= 1$ and $Sigma_0 = Pi_0 = "R"$.

#v(0.4em)
#arithmetical-hierarchy-diagram()
#v(0.4em)

= Computational Complexity Theory

== Deterministic Classes

#def[Let $M$ be a Turing Machine. The time complexity of $M$ is the function
$f: NN -> NN$ giving the maximum number of steps taken by $M$ over all inputs
$x$ of length $|x| = n$.]

#def[Let $M$ be a Turing Machine. The space complexity of $M$ is the function
$f: NN -> NN$ giving the maximum number of tape cells visited by $M$ over all
inputs $x$ of length $|x| = n$.]

#def[$"TIME"(t(n))$ is the set of languages $L$ for which there exists a Turing
Machine $M$ deciding $L$ in time $O(t(n))$.]

#def[$"SPACE"(s(n))$ is the set of languages $L$ for which there exists a
Turing Machine $M$ deciding $L$ in space $O(s(n))$.]

From these definitions we construct the standard deterministic complexity
classes:
$
  "P" & = union.big_(k=0)^oo "TIME"(n^k) quad, \
  "EXP" & = union.big_(k=0)^oo "TIME"(2^(n^k)) quad, \
  "PSPACE" & = union.big_(k=0)^oo "SPACE"(n^k) quad, \
  "EXPSPACE" & = union.big_(k=0)^oo "SPACE"(2^(n^k)) quad.
$

== Nondeterministic Turing Machines

#def[A Nondeterministic Turing Machine (NTM) is a tuple
$(Sigma, Gamma, Q, delta, q_S, q_Y, q_N, square.stroked)$, defined identically
to a deterministic Turing Machine except that $delta$ is now a transition
relation
$
  delta subset.eq (Gamma times (Q backslash {q_Y, q_N})) times (Gamma times Q times {<-, ->}) quad.
$]

Reading a symbol in a given state, an NTM may:
- have exactly one valid transition,
- have more than one valid transition,
- have no valid transition (treated as a rejecting configuration).

#def[An NTM $M$ accepts a word $x$ in at most $k$ steps if and only if:
- every computation branch on $x$ takes at most $k$ steps,
- at least one branch accepts in at most $k$ steps.]

#def[An NTM $M$ rejects a word $x$ in at most $k$ steps if and only if:
- every computation branch on $x$ takes at most $k$ steps,
- every branch rejects in at most $k$ steps.]

#def[Let $f: NN -> NN$. An NTM $M$ decides $L$ in time $f(n)$ if and only if
$M$ accepts $x in Sigma^*$ if and only if $x in L$, and for every
$x in Sigma^*$ all computation branches of $M$ on $x$ have length at most
$f(|x|)$.]

#def[$"NTIME"(t(n))$ is the set of languages $L$ for which there exists an NTM
$M$ deciding $L$ in time $O(t(n))$.]

Analogously to the deterministic classes, we define:
$
  "NP" & = union.big_(k=0)^oo "NTIME"(n^k) quad, \
  "NEXP" & = union.big_(k=0)^oo "NTIME"(2^(n^k)) quad.
$

== Sparse Languages and the Structure of NP

#def[A language $L$ is _sparse_ if and only if there exists a polynomial $p$
such that $forall n in NN : |L^(<= n)| <= p(n)$, where
$L^(<= n) = {x in L | |x| <= n}$.]

#def[A language $L$ is _unary_ if and only if $L subset.eq {0}^*$.]

#thm[Every unary language is sparse.]

#thm(title: "Mahaney, 1982")[If there exists a sparse language that is
$"NP"$-hard under polynomial-time many-to-one reductions ($redmp$), then
$"P" = "NP"$.]

The inclusions among the main complexity classes are summarized below:

#v(0.4em)
#complexity-hierarchy-diagram()
#v(0.4em)

In particular, the internal structure of $"NP"$ can only look like one of the
following two pictures:

#v(0.4em)
#np-possible-diagram()
#v(0.4em)

and cannot look like this:

#v(0.4em)
#np-impossible-diagram()
#v(0.4em)

#thm[If $"P" != "NP"$, then there exists a language $A$ such that $A in "NP"$,
$A in.not "P"$, and $A in.not "NP-com"$.]

#thm[If $"P" = "NP"$, then $"EXP" = "NEXP"$.]

#thm(title: "Ladner, 1975")[For every decidable language $B in "R" backslash "P"$,
there exists a language $A in "P"$ such that:
- $A inter B in.not "P"$,
- $A inter B redmp B$,
- $B nredmp A inter B$.]

Here $redmp$ denotes a polynomial-time many-to-one reduction, i.e., a
many-to-one reduction whose reducing function is computable in polynomial time.
