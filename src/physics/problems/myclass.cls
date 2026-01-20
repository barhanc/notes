\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

\LoadClass[twocolumn]{article}

% Formatowanie strony
\RequirePackage[a4paper, total={7in, 9in}]{geometry}
%\RequirePackage[a4paper, total={6in, 9in}]{geometry}
\setlength{\columnseprule}{0pt}
\setlength{\columnsep}{1.5cm}

% Customowe symbole
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{%
  \mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}%
}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}

% Kolorowanie linków
\RequirePackage[]{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    filecolor=blue,      
    urlcolor=blue,
    }

% Packages
\usepackage{amsmath, amsfonts, enumerate, graphicx, hyperref, 
            mathrsfs, physics, wasysym, MnSymbol, xcolor}

% Additional packages depending on project:
\usepackage{lipsum}
\usepackage{lipsum}
\usepackage{tikz}
\usepackage{circuitikz}
\usepackage{tkz-euclide}
\usepackage{csquotes}