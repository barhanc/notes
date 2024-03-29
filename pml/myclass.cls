\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

%**** Article One column ****
\LoadClass[12pt]{article}
\RequirePackage[a4paper]{geometry}

% Custom symbols
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand{\linesep}{\noindent\rule{\columnwidth}{1pt}}

% Custom environments
\RequirePackage{amsthm}
\theoremstyle{definition}
\newtheorem{definition}{Def}[section]
\theoremstyle{definition}
\newtheorem{theorem}{Tw}[section]

% Coloring
\RequirePackage[]{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    filecolor=blue,      
    urlcolor=blue,
    }

% Packages
\usepackage{amssymb}
\usepackage{amsmath, amsfonts, enumerate, graphicx, 
            mathrsfs, physics, wasysym, xcolor}

% Additional packages and commands depending on project:
\usepackage{lipsum, enumitem, tikz, caption, subcaption, tcolorbox}
\usetikzlibrary{arrows.meta}

\newcommand{\oper}[1]{\boldsymbol{\mathsf{#1}}}
\newcommand{\diag}[0]{\text{diag}}
\DeclareFontFamily{U}{wncy}{}
\DeclareFontShape{U}{wncy}{m}{n}{<->wncyr10}{}
\DeclareSymbolFont{mcy}{U}{wncy}{m}{n}
\DeclareMathSymbol{\sh}{\mathord}{mcy}{"78} 
% \newcommand{\oper}[1]{\hat{#1}}