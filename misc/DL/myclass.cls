\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}


% Article Two column
\LoadClass[twocolumn]{article}
\RequirePackage[a4paper, total={7in, 9in}]{geometry}

\setlength{\columnseprule}{0pt}
\setlength{\columnsep}{1.5cm}


% Custom symbols
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand{\Rbb}{\mathbb{R}}
\newcommand{\Nbb}{\mathbb{N}}
\newcommand{\Ebb}{\mathbb{E}}
\newcommand{\mc}[1]{\mathcal{#1}}
\newcommand{\tpose}{\intercal}
\newcommand{\x}{\times}

\renewcommand{\thefootnote}{\fnsymbol{footnote}}


% Coloring
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
            mathrsfs, physics, wasysym, xcolor, bm, cleveref}

% Additional packages and commands depending on project:
\usepackage{lipsum}
