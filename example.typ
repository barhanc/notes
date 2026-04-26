#let title = "A Fluid Dynamic Model for Glacier Flow"
#let authors = ("Bartosz Hanc",)

#set par(justify: true)
#set page(paper: "a5", numbering: "1")
#set text(font: "Concrete Math")
#set heading(numbering: "1.")

#show math.equation: set text(font: "Concrete Math")

#align(center, text(size: 17pt, strong(title)))
#for author in authors { align(center, text(author)) }
#outline()

= Introduction
#line(length: 100%)

In the case of glaciers, fluid dynamics principles can be used to understand how
the movement and behaviour of the ice is influenced by factors such as
temperature, pressure, and the presence of other fluids (such as water).

== Governing Equations

#lorem(80)

$ f(x) = sum_(i=1)^n g_i (x) = limits(integral)_0^infinity f(x) dif x $

#lorem(30)

== Boundary Conditions

#lorem(100)

$ 
beta &= Lambda dot sum_(i=1)^n lambda_i (x) \
     &= sin(alpha) / tan(beta) dot limits(integral)_0^infinity sigma(x) dif x
$


#lorem(40)
