\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myclass}

\LoadClass[11pt]{article}
\RequirePackage{geometry}
\geometry{
    papersize={7in,9in},
    bottom=3pc,
    top=5pc,
    left=5pc,
    right=5pc,
    bmargin=4.5pc,
    footskip=18pt,
    headsep=25pt}


% ******* Packages *******
\usepackage{amssymb}
\usepackage{amsmath, amsfonts, amsthm, enumerate, 
            mathrsfs, physics, wasysym, xcolor,
            csquotes, graphicx, fancyhdr}

% ******* Additional packages *******
\usepackage{lipsum}

% ******* Fancy header *******
\fancyhf{} \lhead{\leftmark} \rhead{\thepage} 
\pagestyle{fancy}

% ******* Custom symbols *******
\newcommand{\e}{\mathrm{e}}
\newcommand{\im}{\mathrm{i}}
\newcommand{\arcangle}{\mathord{<\mspace{-9mu}\mathrel{)}\mspace{2mu}}}
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
