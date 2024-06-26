\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

\LoadClass{article}

% ******* Packages *******
\usepackage{amssymb}
\usepackage{amsmath, amsfonts, enumerate, graphicx, 
            mathrsfs, physics, wasysym, xcolor}

% ******* Additional packages *******
\usepackage{lipsum, csquotes, amsthm}

% ******* Custom symbols *******
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
\newcommand{\linesep}{\noindent\rule{\columnwidth}{1pt}}
\let\oldemptyset\emptyset
\let\emptyset\varnothing

% ******* Coloring *******
\RequirePackage[]{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor= blue,
    filecolor=blue,      
    urlcolor=blue,
    }

% ******* Proof Environments *******
\newtheorem{definition}{Definicja}[section]
\newtheorem{theorem}{Twierdzenie}[section]
