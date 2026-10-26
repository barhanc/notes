#let title = ""
#let authors = ("Bartosz Hanc",)

#set page(paper: "a5", numbering: "1")
#set text(font: "Concrete Math")
#set par(justify: true)
#set heading(numbering: "1.")


#show math.equation: set text(font: "Concrete Math")

#align(center, text(size: 17pt, strong(title)))

= Introduction

The purpose of this document is two-fold. First, I want to argue that the stable
core of modern Deep Learning theory is incredibly simple and most complexity
comes from heuristics bolted on top which were verified to work in numerical
experiments but have otherwise no solid theoretical grounding (which is
sometimes admitted upfront and sometimes ). Second, is too look, in some detail,
into the most important topic (and perhaps the only unviersally useful) in
today's AI industry, namely LLMs -- their architecture, training algorithm and
data used, and ponder what their core mechanism is, and if they can be improved
even further.

= Deep Learning in Only Few Words

$
  bold(v)_i =: bold(F)^i ({bold(v)^j_t | j in P_i}; theta^i)
$

$
  (partial L) / (partial f^i_p) &= sum_(j in N_i) sum_q (partial L) / (partial f_q^j)  (partial f_q^j) / (partial f_p^i) \
  (partial L) / (partial theta^i_p) &= sum_q (partial L) / (partial f^i_q) (partial f^i_q) / (partial theta^i_p)
$
