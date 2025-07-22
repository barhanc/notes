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
\newcommand{\Ebb}{\mathbb{E}}
\newcommand{\tpose}{\intercal}
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand{\mc}[1]{\mathcal{#1}}
\newcommand{\onehalf}{\frac{1}{2}}
\newcommand{\threehalves}{\frac{3}{2}}

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
            mathrsfs, physics, wasysym, xcolor, bm}

% Additional packages and commands depending on project:
\usepackage{lipsum, listings}
\usepackage[linesnumbered,ruled,vlined]{algorithm2e}

\definecolor{classcolor}{rgb}{0.8, 0.0, 0.0}
\definecolor{keywordcolor}{rgb}{0.0, 0.0, 0.6}
\definecolor{commentcolor}{rgb}{0.0, 0.5, 0.0}
\definecolor{stringcolor}{rgb}{0.58, 0.0, 0.82}

\lstset{
    language=Python,
    basicstyle=\ttfamily\tiny,
    keywordstyle=\color{keywordcolor}\bfseries,
    commentstyle=\color{commentcolor}\itshape,
    stringstyle=\color{stringcolor},
    showstringspaces=false,
    breaklines=true,
    frame=single,
    captionpos=b,
    numbers=left,
    numberstyle=\tiny\color{gray},
    morekeywords={reshape, indices, arange, take, ravel_multi_index},
    emph={np, NDArray},
    emphstyle=\color{classcolor}
}

\DeclareEmphSequence{\bfseries\itshape}
\DeclareMathOperator*{\argmin}{arg\,min} 
\DeclareMathOperator*{\argmax}{arg\,max} 

