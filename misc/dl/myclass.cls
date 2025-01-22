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
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
\renewcommand{\emph}[1]{\textbf{#1}}

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
            mathrsfs, physics, wasysym, xcolor, bm, algorithm}

% Additional packages and commands depending on project:
\usepackage{lipsum}

% Commands
\newcommand\mc{\mathcal}
\newcommand\mb{\mathbb}