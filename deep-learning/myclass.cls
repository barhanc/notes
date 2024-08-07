\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

\LoadClass[a5paper]{article}
\RequirePackage[total={4.5in, 6.75in}]{geometry}

% ******* Packages *******
\usepackage{amssymb, amsmath, amsfonts, amsthm, 
            mathrsfs, physics, xcolor, lipsum,
            csquotes, graphicx, fancyhdr, ulem, 
            bm}
\usepackage[breakable]{tcolorbox}
\usepackage{pgfplots}

% ******* Page style *******
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\rfoot{\thepage} 

% ******* Custom symbols *******
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand\mc{\mathcal}
\let\oldemptyset\emptyset
\let\emptyset\varnothing

% ******* Coloring *******
\RequirePackage{hyperref}
\hypersetup{colorlinks=true}

% ******* Proof Environments *******
\theoremstyle{definition}
\newtheorem{definition}{Definicja}[section]
\tcolorboxenvironment{definition}{colframe=white,breakable,before skip=10pt,after skip=10pt }

\theoremstyle{definition}
\newtheorem{theorem}{Twierdzenie}[section]
\tcolorboxenvironment{theorem}{colframe=black,boxrule=0.5pt,colback=white,breakable,before skip=10pt,after skip=10pt }