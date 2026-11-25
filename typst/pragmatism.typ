// =============================================================================
// On Pragmatism
// =============================================================================

#set page(paper: "a5", margin: (x: 18mm, top: 22mm, bottom: 20mm), numbering: "1")
#set text(font: "Concrete Math")
#set par(justify: true, leading: 0.65em)
#show heading.where(level: 1): set text(13pt)
#show heading.where(level: 2): set text(11pt)
#show heading: set block(above: 1.8em, below: 1.2em)
#show math.equation: set text(font: "Concrete Math")
#show math.equation.where(block: false): box
#show emph: it => {
  show regex("\S+"): w => box(skew(ax: -12deg, w))
  it.body
}

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

#align(center)[
  #text(16pt, strong("On Pragmatism")) \
  #v(0.4em)
  #text(9pt, emph("Written with the help of AI."))
]
#v(0.5em)

= Equality and Capability

In Book I of the Elements#footnote[Euclid, Elements, Book I, Common Notion 4 (c. 300 BCE).],
Euclid states a simple rule for equality, noting that magnitudes which
coincide---which can be interchanged---are equal. Later, Leibniz#footnote[G. W.
Leibniz, Non inelegans specimen demonstrandi in abstractis (1687), "Eadem sunt,
quorum unum potest substitui alteri salva veritate."] stated the same idea more
generally in logic, defining two things as the same if one can be substituted
for the other without changing the truth of any statement (_salva veritate_).

In practice, we often compare two positions, $X$ and $Y$ (such as claims,
models, rules, or norms). Following the substitution principle above, we can
build a framework for analyzing them with respect to a given _agent_ $A$---any
entity acting in the physical world---by comparing $A$ operating under $X$
against $A$ operating under $Y$. Instead of asking what $A$ feels, believes, or
merely happens to choose, we ask what $A$ _can reliably achieve in the physical
world_.

Suppose that, with respect to $A$, replacing $X$ with $Y$ leaves everything $A$
can reliably achieve in the physical world unchanged. In that case, we treat
$X$ and $Y$ as equivalent for $A$ (written $X tilde^A Y$). They belong to the
same equivalence class and are interchangeable with respect to $A$'s
capabilities.

= Comparison Across Scales

The main advantage of this approach is that it provides a concrete, operational
way of comparing positions. Instead of leaving a disagreement at the level of
abstract definitions or intuition, it reduces any comparison between two
positions $X$ and $Y$ to whether $A$ operating under $X$ versus $Y$ changes
what $A$ can reliably achieve in the physical world.

Asking this question is productive regardless of the answer:

- If a difference appears ($X tilde.not^A Y$), the framework forces us to name
  it explicitly---what becomes reliably achievable or unachievable for $A$
  under $X$ compared to $Y$. This turns an imprecise debate into a concrete
  problem that can be analyzed, tested, and acted on.

- If no difference appears ($X tilde^A Y$), we reach a clear conclusion that
  there is no difference between $X$ and $Y$ with respect to $A$. This avoids
  treating purely verbal variations as competing positions, and keeps analysis
  focused on distinctions that change $A$'s capabilities.

A second strength of the framework is that it applies uniformly across scales
of agency, from an individual to an organization or a society. Because
capabilities depend on the agent, two positions can be equivalent for one agent
($X tilde^A Y$) and distinct for another ($X tilde.not^B Y$). In this way, the
framework stays grounded in outcomes in a shared physical world while capturing
distinctions that only emerge at larger scales.
