\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

\LoadClass[a5paper]{article}
\RequirePackage[total={4.5in, 6.75in}]{geometry}

% ******* Packages *******
\usepackage{amssymb, amsmath, amsfonts, amsthm, 
            mathrsfs, physics, xcolor, lipsum,
            csquotes, graphicx, fancyhdr, ulem, 
            bm}

% ******* Page style *******
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\rfoot{\thepage} 

% ******* Custom symbols *******
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\let\oldint\int
\let\int\varint
\let\oldemptyset\emptyset
\let\emptyset\varnothing

% ******* Coloring *******
\RequirePackage{hyperref}
\hypersetup{colorlinks=true}

% ******* Proof Environments *******
\theoremstyle{definition}
\newtheorem{definition}{Definition}[section]
\theoremstyle{theorem}
\newtheorem{theorem}{Theorem}[section]