\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

% Article One column
% \LoadClass[]{article}
% \RequirePackage[a4paper, total={6in, 9in}]{geometry}

% Article Two column
\LoadClass[twocolumn]{article}
\RequirePackage[a4paper, total={7in, 9in}]{geometry}

\setlength{\columnseprule}{0pt}
\setlength{\columnsep}{1.5cm}

% Custom symbols
\newcommand{\Rbb}{\mathbb{R}}
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand\mc[1]{\mathcal{#1}}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}

% Colouring
\RequirePackage[]{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    filecolor=blue,      
    urlcolor=blue,
    }

% Packages
\usepackage{amssymb}
\usepackage{amsmath, amsfonts, enumerate, graphicx, hyperref, 
            mathrsfs, physics, wasysym, xcolor, bm}

% Additional packages and commands depending on project:
\usepackage{lipsum}
