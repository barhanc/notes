\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

%**** Article One column ****
\LoadClass[12pt]{article}
\RequirePackage[a4paper]{geometry}

%**** Article Two column ****
%\LoadClass[twocolumn]{article}
%\RequirePackage[a4paper, total={7in, 9in}]{geometry}
%\setlength{\columnseprule}{0pt}
%\setlength{\columnsep}{1.5cm}

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
\usepackage{lipsum, enumitem, tikz, quantikz}

\newcommand{\oper}[1]{\boldsymbol{\mathsf{#1}}}
\newcommand{\gatesym}[1]{\text{#1}}
% \newcommand{\oper}[1]{\hat{#1}}