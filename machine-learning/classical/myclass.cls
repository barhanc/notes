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

\lstdefinestyle{mystyle}{ 
    basicstyle=\ttfamily\footnotesize,
    breakatwhitespace=false,         
    breaklines=true,                 
    captionpos=b,                    
    keepspaces=true,                 
    numbers=left,
    tabsize=2
}
\lstset{style=mystyle}

\DeclareEmphSequence{\bfseries\itshape}
\DeclareMathOperator*{\argmin}{arg\,min} 
\DeclareMathOperator*{\argmax}{arg\,max} 