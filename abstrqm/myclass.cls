\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

%**** Article One column ****
\LoadClass[]{article}

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
\newenvironment{textbox}
    {\begin{center}
    \begin{tabular}{|p{0.9\textwidth}|}
    \hline\\
    }
    { 
    \\\\\hline
    \end{tabular} 
    \end{center}
    }
%

\RequirePackage{amsthm}
\theoremstyle{definition}
\newtheorem{definition}{Def}[section]
\theoremstyle{definition}
\newtheorem{theorem}{Tw}[section]

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
\usepackage{amsmath, amsfonts, enumerate, graphicx, 
            mathrsfs, physics, wasysym, xcolor}

% Additional packages and commands depending on project:
\usepackage{lipsum, enumitem}

\newcommand{\oper}[1]{\boldsymbol{\mathsf{#1}}}
