%% =====================================================================
%%  enemebook.cls — Coleção "Escala TRI" · Matemática para o ENEM
%%  Classe LaTeX (compilar com LuaLaTeX) para os três volumes do ebook.
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{enemebook}[2026/10/04 Colecao Escala TRI - Matematica ENEM]

\newcommand\ebook@vol{1}
\DeclareOption{v1}{\renewcommand\ebook@vol{1}}
\DeclareOption{v2}{\renewcommand\ebook@vol{2}}
\DeclareOption{v3}{\renewcommand\ebook@vol{3}}
\newif\ifebook@draft \ebook@draftfalse
\DeclareOption{rascunho}{\ebook@drafttrue}
\ProcessOptions\relax
\LoadClass[11pt,oneside,openany]{book}

%% ---------------------------------------------------------------------
%% Pacotes
%% ---------------------------------------------------------------------
\RequirePackage[a4paper,top=25mm,bottom=27mm,left=21mm,right=31mm,
  headheight=14pt,headsep=8mm,footskip=13mm]{geometry}
\RequirePackage{iftex}
\RequireLuaTeX
\pdfvariable minorversion=7
\RequirePackage{amsmath,amssymb,mathtools}
\RequirePackage{fontspec}
\RequirePackage[math-style=ISO,bold-style=ISO]{unicode-math}
\RequirePackage[brazilian]{babel}
\RequirePackage{icomma}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{calc,ifthen,etoolbox,xstring}
\RequirePackage{array,booktabs,tabularx,multirow,colortbl,longtable}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning,shapes.geometric,arrows.meta,patterns,
  decorations.pathreplacing,angles,quotes,intersections,fadings,shadows,shadings}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\usepgfplotslibrary{fillbetween}
\RequirePackage[most]{tcolorbox}
\RequirePackage{fontawesome5}
\RequirePackage{fancyhdr}
\RequirePackage[explicit]{titlesec}
\RequirePackage{etoc}
\RequirePackage{eso-pic}
\RequirePackage{lastpage}
\RequirePackage{fancyvrb}
\RequirePackage{siunitx}
\RequirePackage{caption}
\RequirePackage{xurl}
\RequirePackage{needspace}
\RequirePackage{microtype}

%% ---------------------------------------------------------------------
%% Fontes: Fira Sans (texto), Fira Math (matemática), Montserrat (títulos)
%% ---------------------------------------------------------------------
\directlua{
  luaotfload.add_fallback("ebookfallback", {
    "FiraMath-Regular.otf:mode=node;",
    "STIXTwoMath-Regular.otf:mode=node;",
    "DejaVuSans.ttf:mode=node;",
  })
}
\setmainfont{FiraSans}[
  Extension=.otf,
  UprightFont=*-Book, ItalicFont=*-BookItalic,
  BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic,
  RawFeature={fallback=ebookfallback}, Numbers={Lining}]
\setsansfont{FiraSans}[
  Extension=.otf,
  UprightFont=*-Book, ItalicFont=*-BookItalic,
  BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic,
  RawFeature={fallback=ebookfallback}]
\newfontfamily\ebook@fira{FiraSans}[Extension=.otf,
  UprightFont=*-Regular, BoldFont=*-Bold, ItalicFont=*-Italic,
  RawFeature={fallback=ebookfallback}]
\newfontfamily\ebook@firalight{FiraSans}[Extension=.otf,
  UprightFont=*-Light, BoldFont=*-Medium, ItalicFont=*-LightItalic]
\newfontfamily\titlefont{Montserrat}[Extension=.otf,
  UprightFont=*-Bold, BoldFont=*-ExtraBold, ItalicFont=*-BoldItalic,
  RawFeature={fallback=ebookfallback}]
\newfontfamily\titlefontblack{Montserrat}[Extension=.otf,
  UprightFont=*-Black, BoldFont=*-Black]
\newfontfamily\titlefontsemi{Montserrat}[Extension=.otf,
  UprightFont=*-SemiBold, BoldFont=*-Bold, ItalicFont=*-SemiBoldItalic]
\newfontfamily\titlefontlight{Montserrat}[Extension=.otf,
  UprightFont=*-Light, BoldFont=*-Medium]
\setmathfont{FiraMath-Regular.otf}
\setmathfont{STIXTwoMath-Regular.otf}[range={\mathbb,\mathcal,\mathscr,"2205}]
\linespread{1.12}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.55em plus 0.2em minus 0.1em}
\frenchspacing
\emergencystretch=2em
\sisetup{output-decimal-marker={,}, group-separator={\,}, group-minimum-digits=4,
  per-mode=symbol, list-final-separator={ e }, list-pair-separator={ e },
  range-phrase={ a }, exponent-product=\cdot}
\captionsetup{font={small,sf}, labelfont={bf,color=ebookPrim}, labelsep=period}

%% ---------------------------------------------------------------------
%% Cores
%% ---------------------------------------------------------------------
\definecolor{ebookText}{HTML}{1E293B}
\definecolor{ebookMuted}{HTML}{64748B}
\definecolor{ebookLine}{HTML}{CBD5E1}
\definecolor{ebookPaper}{HTML}{F8FAFC}
\definecolor{nivelA}{HTML}{16A34A}
\definecolor{nivelB}{HTML}{CA8A04}
\definecolor{nivelC}{HTML}{EA580C}
\definecolor{nivelD}{HTML}{DC2626}
\definecolor{dicaC}{HTML}{15803D}\definecolor{dicaBG}{HTML}{F0FDF4}
\definecolor{maceteC}{HTML}{7E22CE}\definecolor{maceteBG}{HTML}{FAF5FF}
\definecolor{atencaoC}{HTML}{B91C1C}\definecolor{atencaoBG}{HTML}{FEF2F2}
\definecolor{exemploC}{HTML}{334155}\definecolor{exemploBG}{HTML}{F8FAFC}
\definecolor{contextoC}{HTML}{0369A1}\definecolor{contextoBG}{HTML}{F0F9FF}
\ifcase\ebook@vol\or
  \definecolor{ebookPrim}{HTML}{0F766E}\definecolor{ebookDark}{HTML}{134E4A}
  \definecolor{ebookLight}{HTML}{CCFBF1}\definecolor{ebookSoft}{HTML}{F0FDFA}
  \definecolor{ebookAcc}{HTML}{F59E0B}\definecolor{ebookGradA}{HTML}{0F766E}
  \definecolor{ebookGradB}{HTML}{0E4F63}
\or
  \definecolor{ebookPrim}{HTML}{4338CA}\definecolor{ebookDark}{HTML}{312E81}
  \definecolor{ebookLight}{HTML}{E0E7FF}\definecolor{ebookSoft}{HTML}{EEF2FF}
  \definecolor{ebookAcc}{HTML}{F43F5E}\definecolor{ebookGradA}{HTML}{4338CA}
  \definecolor{ebookGradB}{HTML}{1E1B4B}
\or
  \definecolor{ebookPrim}{HTML}{C2410C}\definecolor{ebookDark}{HTML}{7C2D12}
  \definecolor{ebookLight}{HTML}{FFEDD5}\definecolor{ebookSoft}{HTML}{FFF7ED}
  \definecolor{ebookAcc}{HTML}{2563EB}\definecolor{ebookGradA}{HTML}{C2410C}
  \definecolor{ebookGradB}{HTML}{6B1D3A}
\fi
\AtBeginDocument{\color{ebookText}}

%% ---------------------------------------------------------------------
%% Metadados do volume e dos capítulos
%% ---------------------------------------------------------------------
\newcommand\colecao{Escala TRI}
\newcommand\ebook@voltitle{}
\newcommand\ebook@volshort{}
\newcounter{ebook@nchap}
% \capdef{id}{vol}{num}{título}{escopo}
\newcommand\capdef[5]{%
  \expandafter\gdef\csname cap@#1@vol\endcsname{#2}%
  \expandafter\gdef\csname cap@#1@num\endcsname{#3}%
  \expandafter\gdef\csname cap@#1@tit\endcsname{#4}%
  \expandafter\gdef\csname cap@#1@esc\endcsname{#5}%
  \expandafter\gdef\csname capnum@#2@#3\endcsname{#1}%
  \ifnum#2=\ebook@vol\relax\stepcounter{ebook@nchap}\fi}
% \voldef{vol}{título}{título curto}
\newcommand\voldef[3]{%
  \expandafter\gdef\csname vol@#1@tit\endcsname{#2}%
  \expandafter\gdef\csname vol@#1@short\endcsname{#3}}
% \capstats{id}{total}{fácil}{média}{difícil}{muito difícil}{habilidades}
\newcommand\capstats[7]{%
  \expandafter\gdef\csname cap@#1@stats\endcsname{{#2}{#3}{#4}{#5}{#6}}%
  \expandafter\gdef\csname cap@#1@hab\endcsname{#7}}
% \enemdef{id}{ano}{questão}{caderno}{habilidade}{a}{b}{c}{gabarito}
\newcommand\enemdef[9]{%
  \expandafter\gdef\csname enem@#1@ano\endcsname{#2}%
  \expandafter\gdef\csname enem@#1@q\endcsname{#3}%
  \expandafter\gdef\csname enem@#1@cad\endcsname{#4}%
  \expandafter\gdef\csname enem@#1@hab\endcsname{#5}%
  \expandafter\gdef\csname enem@#1@a\endcsname{#6}%
  \expandafter\gdef\csname enem@#1@b\endcsname{#7}%
  \expandafter\gdef\csname enem@#1@c\endcsname{#8}%
  \expandafter\gdef\csname enem@#1@gab\endcsname{#9}}
% \enemniv{id}{nível}{pontos}
\newcommand\enemniv[3]{%
  \expandafter\gdef\csname enem@#1@niv\endcsname{#2}%
  \expandafter\gdef\csname enem@#1@pts\endcsname{#3}}
\InputIfFileExists{dados/capitulos.tex}{}{}
\InputIfFileExists{dados/enem-meta.tex}{}{}
\InputIfFileExists{dados/estatisticas.tex}{}{}
\edef\ebook@voltitle{\csname vol@\ebook@vol @tit\endcsname}
\edef\ebook@volshort{\csname vol@\ebook@vol @short\endcsname}
\let\numvolume\ebook@vol
\let\titulovolume\ebook@voltitle

\graphicspath{{oficial/}{../cache/oficial/}{figuras/}}

%% ---------------------------------------------------------------------
%% Hyperlinks e metadados do PDF
%% ---------------------------------------------------------------------
\RequirePackage[pdfusetitle,bookmarksnumbered,bookmarksopen,bookmarksopenlevel=1,
  linktoc=all,unicode,pdfpagelabels,pdfdisplaydoctitle,pdfpagemode=UseOutlines,
  pdfstartview=FitH]{hyperref}
\RequirePackage{bookmark}
\hypersetup{colorlinks=true, linkcolor=ebookPrim, urlcolor=contextoC,
  citecolor=ebookPrim, filecolor=ebookPrim,
  pdftitle={Matemática para o ENEM — Volume \ebook@vol: \ebook@voltitle},
  pdfauthor={Coleção Escala TRI},
  pdfsubject={Matemática e suas Tecnologias — ENEM},
  pdfkeywords={ENEM, Matemática, TRI, questões resolvidas, vestibular},
  pdfcreator={LuaLaTeX — Coleção Escala TRI}}
\urlstyle{same}

%% ---------------------------------------------------------------------
%% Utilidades gráficas
%% ---------------------------------------------------------------------
% chip arredondado: \chip[cor texto]{cor fundo}{texto}
\DeclareRobustCommand\chip[3][white]{%
  \tikz[baseline=(c.base)]\node[fill=#2,text=#1,rounded corners=2.6pt,
    inner xsep=4.2pt,inner ysep=2.2pt,font=\sffamily\scriptsize\bfseries](c){\strut #3};}
\DeclareRobustCommand\chipborda[3][ebookText]{%
  \tikz[baseline=(c.base)]\node[draw=#2,line width=.6pt,text=#1,rounded corners=2.6pt,
    inner xsep=4pt,inner ysep=2pt,font=\sffamily\scriptsize\bfseries](c){\strut #3};}
\newcommand\nivelnome[1]{\ifcase#1 \or Fácil\or Média\or Difícil\or Muito difícil\fi}
\newcommand\nivelcor[1]{\ifcase#1 ebookMuted\or nivelA\or nivelB\or nivelC\or nivelD\fi}
% medidor de dificuldade com 4 barras
\DeclareRobustCommand\medidor[1]{%
  \begin{tikzpicture}[baseline=-0.6ex]
    \foreach \i in {1,...,4}{
      \pgfmathsetmacro\h{0.9+0.45*\i}
      \ifnum\i>#1\relax
        \fill[ebookLine,rounded corners=.4pt] (0.17*\i,-0.08) rectangle ++(0.11,\h*0.1);
      \else
        \fill[\nivelcor{#1},rounded corners=.4pt] (0.17*\i,-0.08) rectangle ++(0.11,\h*0.1);
      \fi}
  \end{tikzpicture}}
\DeclareRobustCommand\selonivel[1]{%
  \tikz[baseline=(c.base)]\node[draw=\nivelcor{#1},fill=white,line width=.7pt,text=\nivelcor{#1},
    rounded corners=2.6pt,inner xsep=4pt,inner ysep=2pt,font=\sffamily\scriptsize\bfseries]
    (c){\strut\medidor{#1}\,\MakeUppercase{\nivelnome{#1}}};}
% número formatado com vírgula
\newcommand\virgula[1]{\StrSubstitute{#1}{.}{,}}
% fonte de um texto-base
\newcommand\fonte[1]{\par{\raggedleft\footnotesize\color{ebookMuted}#1\par}}
% imagem de questão oficial: \enemfig{largura cm}{arquivo}
\newcommand\enemfig[2]{\par\smallskip{\centering
  \includegraphics[width=\dimexpr\ifdim#1cm>\linewidth\linewidth\else#1cm\fi\relax]{#2}\par}\smallskip}
\newcommand\enemfiginline[2]{\raisebox{-.3\height}{\includegraphics[height=#1cm]{#2}}}
% recorte vetorial do caderno oficial: \enemseg{id}{trecho}{escala}
\newcommand\enemseg[3]{\par\vspace{2pt}{\centering
  \includegraphics[page=#2,scale=#3]{#1.pdf}\par}\vspace{2pt}}

%% ---------------------------------------------------------------------
%% Cabeçalho, rodapé e navegação
%% ---------------------------------------------------------------------
\newcommand\ebook@navbtn[3]{% {alvo}{ícone}{rótulo}
  \hyperlink{#1}{\tikz[baseline=(b.base)]\node[fill=ebookSoft,draw=ebookLight,
    rounded corners=3pt,inner xsep=5pt,inner ysep=2.4pt,text=ebookPrim,
    font=\sffamily\scriptsize\bfseries](b){\strut#2\hspace{3pt}#3};}}
\newif\ifebook@emcapitulo \ebook@emcapitulofalse
\pagestyle{fancy}
\fancyhf{}
\renewcommand\headrulewidth{0pt}
\renewcommand\chaptermark[1]{\markboth{#1}{#1}}
\renewcommand\sectionmark[1]{}
\fancyhead[L]{\sffamily\scriptsize\color{ebookMuted}%
  \textbf{\color{ebookPrim}MATEMÁTICA ENEM}\enspace·\enspace VOLUME \ebook@vol\enspace·\enspace\ebook@volshort}
\fancyhead[R]{\sffamily\scriptsize\color{ebookMuted}%
  \ifebook@emcapitulo\textbf{Cap.~\thechapter}\enspace\leftmark\else\leftmark\fi}
\fancyfoot[L]{\ebook@navbtn{sumario}{\faHome}{Sumário}\hspace{4pt}%
  \ifebook@emcapitulo
    \ebook@navbtn{cap-\thechapter}{\faBookOpen}{Início do cap. \thechapter}\hspace{4pt}%
    \ebook@navbtn{res-\thechapter}{\faCheckCircle}{Resoluções}\hspace{4pt}%
  \fi
  \ebook@navbtn{gabarito-geral}{\faListOl}{Gabarito geral}}
\fancyfoot[R]{\sffamily\small\color{ebookMuted}\textbf{\color{ebookPrim}\thepage}\,/\,\pageref*{LastPage}}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[R]{\sffamily\small\color{ebookMuted}%
  \textbf{\color{ebookPrim}\thepage}\,/\,\pageref*{LastPage}}%
  \fancyfoot[L]{\ebook@navbtn{sumario}{\faHome}{Sumário}}}
\fancypagestyle{vazio}{\fancyhf{}}

%% ---------------------------------------------------------------------
%% Abas laterais clicáveis (índice de dedo)
%% ---------------------------------------------------------------------
\newif\ifebook@abas \ebook@abasfalse
\newlength\ebook@tabh
\newcommand\ebook@desenhaabas{%
  \ifebook@abas
    \setlength\ebook@tabh{\dimexpr(\paperheight-100mm)/\value{ebook@nchap}\relax}%
    \foreach \k in {1,...,\value{ebook@nchap}}{%
      \ifnum\k=\value{chapter}\relax
        \put(\LenToUnit{\paperwidth-11mm},\LenToUnit{\paperheight-70mm-\k\ebook@tabh+0.6mm}){%
          \hyperlink{cap-\k}{\tikz{\fill[ebookPrim,rounded corners=2.5pt]
            (0,0) rectangle (13mm,\ebook@tabh-1.2mm);
            \node[text=white,font=\titlefont\small,anchor=center] at (4.6mm,\ebook@tabh/2-.6mm) {\k};}}}%
      \else
        \put(\LenToUnit{\paperwidth-7mm},\LenToUnit{\paperheight-70mm-\k\ebook@tabh+0.6mm}){%
          \hyperlink{cap-\k}{\tikz{\fill[ebookLight,rounded corners=2.5pt]
            (0,0) rectangle (9mm,\ebook@tabh-1.2mm);
            \node[text=ebookPrim,font=\titlefontsemi\scriptsize,anchor=center] at (3.2mm,\ebook@tabh/2-.6mm) {\k};}}}%
      \fi}%
  \fi}
\AddToShipoutPictureBG{\ebook@desenhaabas}

%% ---------------------------------------------------------------------
%% Títulos: capítulos e seções
%% ---------------------------------------------------------------------
\titleformat{\chapter}[block]{}{}{0pt}{\ebook@chapterhead{#1}}
\titleformat{name=\chapter,numberless}[block]{}{}{0pt}{\ebook@chapterheadnn{#1}}
\titlespacing*{\chapter}{0pt}{-12mm}{6mm}
\newcommand\ebook@chapterhead[1]{%
  \begin{tikzpicture}[remember picture,overlay]
    \shade[left color=ebookGradA,right color=ebookGradB] (current page.north west) rectangle
      ([yshift=-62mm]current page.north east);
    \begin{scope}[opacity=.10,white,line width=.7pt]
      \foreach \x in {0,8,...,220}{\draw ([xshift=\x mm]current page.north west) -- ++(0,-62mm);}
      \foreach \y in {0,8,...,60}{\draw ([yshift=-\y mm]current page.north west) -- ++(\paperwidth,0);}
    \end{scope}
    \begin{scope}[opacity=.22,white,line width=1.4pt]
      \draw ([xshift=-70mm,yshift=-58mm]current page.north east) parabola bend
        ([xshift=-40mm,yshift=-8mm]current page.north east) ([xshift=-10mm,yshift=-58mm]current page.north east);
      \draw ([xshift=-30mm,yshift=-40mm]current page.north east) circle (17mm);
    \end{scope}
    \node[anchor=north west,text=white,font=\titlefontsemi\small,inner sep=0pt]
      at ([xshift=21mm,yshift=-12mm]current page.north west)
      {\MakeUppercase{Volume \ebook@vol\enspace·\enspace\ebook@volshort}};
    \node[anchor=north west,text=white,font=\titlefontblack\fontsize{64}{64}\selectfont,inner sep=0pt,opacity=.95]
      at ([xshift=19mm,yshift=-20mm]current page.north west) {\twodigit{\value{chapter}}};
    \node[anchor=north west,text=white,font=\titlefont\fontsize{24}{27}\selectfont,inner sep=0pt,
      text width=\textwidth-36mm,align=left]
      at ([xshift=58mm,yshift=-25mm]current page.north west) {\hyphenpenalty=10000\exhyphenpenalty=10000 #1};
    \node[anchor=south west,text=white,font=\sffamily\scriptsize,inner sep=0pt,text width=\textwidth-36mm,opacity=.9]
      at ([xshift=58mm,yshift=-56mm]current page.north west) {\ebook@capesc};
  \end{tikzpicture}%
  \vspace*{30mm}}
\newcommand\ebook@chapterheadnn[1]{%
  \begin{tikzpicture}[remember picture,overlay]
    \shade[left color=ebookGradA,right color=ebookGradB] (current page.north west) rectangle
      ([yshift=-40mm]current page.north east);
    \begin{scope}[opacity=.10,white,line width=.7pt]
      \foreach \x in {0,8,...,220}{\draw ([xshift=\x mm]current page.north west) -- ++(0,-40mm);}
      \foreach \y in {0,8,...,40}{\draw ([yshift=-\y mm]current page.north west) -- ++(\paperwidth,0);}
    \end{scope}
    \node[anchor=south west,text=white,font=\titlefont\fontsize{26}{30}\selectfont,inner sep=0pt]
      at ([xshift=21mm,yshift=-31mm]current page.north west) {#1};
  \end{tikzpicture}%
  \vspace*{12mm}}
\newcommand\twodigit[1]{\ifnum#1<10 0\fi\number#1}
\newcommand\ebook@capesc{}

\titleformat{\section}[hang]{\titlefont\Large\color{ebookDark}}%
  {\tikz[baseline=(n.base)]\node[fill=ebookPrim,text=white,rounded corners=3pt,inner sep=4pt,
    font=\titlefont\normalsize](n){\thesection};}{8pt}{#1}
\titlespacing*{\section}{0pt}{16pt plus 4pt}{8pt}
\titleformat{\subsection}[hang]{\titlefontsemi\large\color{ebookPrim}}%
  {}{0pt}{\textcolor{ebookAcc}{\rule[-1pt]{3pt}{1em}}\hspace{6pt}#1}
\titlespacing*{\subsection}{0pt}{12pt plus 3pt}{5pt}
\titleformat{\subsubsection}[runin]{\sffamily\bfseries\color{ebookDark}}{}{0pt}{#1.}
\titlespacing*{\subsubsection}{0pt}{8pt}{6pt}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{1}

%% ---------------------------------------------------------------------
%% Sumário
%% ---------------------------------------------------------------------
\etocsetstyle{chapter}{}{}{%
  \par\addvspace{5pt}\noindent
  \begin{tikzpicture}[baseline=(t.base)]
    \node[fill=ebookPrim,text=white,rounded corners=3pt,minimum width=9mm,minimum height=7mm,
      font=\titlefont\normalsize](n){\etocifnumbered{\etocnumber}{\faStar}};
    \node[anchor=west,font=\titlefontsemi\normalsize,text=ebookDark,text width=\linewidth-30mm](t) at ([xshift=4pt]n.east) {\etocname};
  \end{tikzpicture}\hfill{\titlefont\color{ebookPrim}\etocpage}\par}{}
\etocsetstyle{section}{}{}{%
  \par\noindent\hspace*{13mm}{\small\color{ebookMuted}\etocnumber\quad}%
  {\small\etocname}\nobreak{\color{ebookLine}\leaders\hbox to .8em{\hss.\hss}\hfill}
  \nobreak{\small\color{ebookMuted}\etocpage}\par}{}
\etocsettocstyle{}{}

% sumário local (abertura de capítulo)
\newcommand\ebook@localtoc{%
  \begingroup
  \etocsetstyle{section}{}{}{%
    \noindent{\color{ebookPrim}\faAngleRight}\hspace{5pt}{\small\etocnumber\quad\etocname}%
    \nobreak{\color{ebookLine}\leaders\hbox to .8em{\hss.\hss}\hfill}\nobreak{\small\color{ebookMuted}\etocpage}\par}{}
  \etocsettocstyle{}{}
  \etocsetnexttocdepth{section}%
  \localtableofcontents
  \endgroup}

%% ---------------------------------------------------------------------
%% \capitulo{id}: abre um capítulo
%% ---------------------------------------------------------------------
\newcounter{questao}[chapter]
\newcounter{ebook@resnum}[chapter]
\newcommand\ebook@reslist{}
\newcommand\ebook@gablist{}
\newcommand\ebook@gabglobal{}
\newcommand\ebook@curid{}
\newcommand\ebook@curcap{}
\newif\ifebook@capaberto \ebook@capabertofalse

\newcommand\capitulo[1]{%
  \ifebook@capaberto\fimcapitulo\fi
  \ifcsname cap@#1@tit\endcsname\else
    \ClassError{enemebook}{Capítulo desconhecido: #1}{Verifique dados/capitulos.tex}\fi
  \clearpage
  \gdef\ebook@curcap{#1}%
  \global\ebook@abastrue
  \global\ebook@emcapitulotrue
  \global\ebook@capabertotrue
  \renewcommand\ebook@capesc{\csname cap@#1@esc\endcsname}%
  \setcounter{chapter}{\numexpr\csname cap@#1@num\endcsname-1\relax}%
  \chapter[\csname cap@#1@tit\endcsname]{\csname cap@#1@tit\endcsname}%
  \hypertarget{cap-\thechapter}{}\label{cap:#1}%
  \gdef\ebook@reslist{}\gdef\ebook@gablist{}%
  \ebook@abertura{#1}}

% abertura: sumário do capítulo + o que cai + progresso
\newcommand\ebook@abertura[1]{%
  \noindent
  \begin{minipage}[t]{0.56\linewidth}
    {\titlefontsemi\small\color{ebookPrim}\MakeUppercase{Neste capítulo}}\par\smallskip
    \ebook@localtoc
    \noindent{\color{ebookPrim}\faAngleRight}\hspace{5pt}{\small\hyperlink{res-\thechapter}{Resoluções comentadas e gabarito}}%
  \end{minipage}\hfill
  \begin{minipage}[t]{0.40\linewidth}
    \begin{tcolorbox}[enhanced,colback=ebookSoft,colframe=ebookLight,arc=4pt,boxrule=.6pt,
      left=6pt,right=6pt,top=5pt,bottom=5pt]
      {\titlefontsemi\small\color{ebookPrim}\MakeUppercase{O que cai no ENEM}}\par\smallskip
      \ebook@statsbox{#1}
    \end{tcolorbox}
    \begin{tcolorbox}[enhanced,colback=white,colframe=ebookLight,arc=4pt,boxrule=.6pt,
      left=6pt,right=6pt,top=5pt,bottom=5pt]
      {\titlefontsemi\small\color{ebookPrim}\MakeUppercase{Meu progresso}}\par\smallskip
      \small\ebook@check{\thechapter-teoria}{Li a teoria e os exemplos}\par
      \ebook@check{\thechapter-dicas}{Revisei dicas e macetes}\par
      \ebook@check{\thechapter-enem}{Resolvi as questões do ENEM}\par
      \ebook@check{\thechapter-ineditas}{Resolvi as questões inéditas}\par
      \ebook@check{\thechapter-revisao}{Refiz as que errei}
    \end{tcolorbox}
  \end{minipage}\par\medskip}
\newcommand\ebook@check[2]{%
  \raisebox{-1.5pt}{\CheckBox[name=prog-v\ebook@vol-#1,width=9pt,height=9pt,
    bordercolor={0.06 0.46 0.43},backgroundcolor={1 1 1},borderwidth=0.8pt,
    checkboxsymbol=\ding{52}]{}}\hspace{5pt}#2}
\newcommand\ebook@statsbox[1]{%
  \ifcsname cap@#1@stats\endcsname
    \expandafter\expandafter\expandafter\ebook@statsdraw\csname cap@#1@stats\endcsname
    \par\smallskip
    {\scriptsize\color{ebookMuted}Habilidades da Matriz mais cobradas:}\par
    \csname cap@#1@hab\endcsname
  \else
    {\small Estatísticas indisponíveis.}
  \fi}
\newcommand\ebook@statsdraw[5]{%
  {\small\textbf{#1} questões oficiais (\anosbanco) cobraram este conteúdo como foco principal.}\par\smallskip
  \ifnum#1>0
  \begin{tikzpicture}[x=\dimexpr(\linewidth-1pt)/#1\relax]
    \pgfmathsetmacro\xa{#2}\pgfmathsetmacro\xb{#2+#3}\pgfmathsetmacro\xc{#2+#3+#4}
    \fill[nivelA] (0,0) rectangle (\xa,.32);
    \fill[nivelB] (\xa,0) rectangle (\xb,.32);
    \fill[nivelC] (\xb,0) rectangle (\xc,.32);
    \fill[nivelD] (\xc,0) rectangle (#1,.32);
  \end{tikzpicture}\par
  {\scriptsize
   \textcolor{nivelA}{\faSquare}\,Fácil #2\enspace
   \textcolor{nivelB}{\faSquare}\,Média #3\enspace
   \textcolor{nivelC}{\faSquare}\,Difícil #4\enspace
   \textcolor{nivelD}{\faSquare}\,Muito difícil #5\par}
  \fi}
\newcommand\habchip[1]{\chip{ebookPrim}{H#1}\hspace{1pt}}

%% ---------------------------------------------------------------------
%% Caixas de teoria
%% ---------------------------------------------------------------------
\tcbset{ebookbase/.style={enhanced,breakable,arc=5pt,boxrule=0pt,leftrule=3.5pt,
  left=10pt,right=10pt,top=8pt,bottom=8pt,before skip=10pt,after skip=10pt,
  fonttitle=\titlefontsemi\small,coltitle=#1,
  attach title to upper={\par\smallskip},
  colframe=#1}}
\newtcolorbox{definicao}[1][]{ebookbase=ebookPrim,colback=ebookSoft,
  title={\faBook\hspace{6pt}\MakeUppercase{Conceito}\ifstrempty{#1}{}{\,·\,#1}}}
\newtcolorbox{dica}[1][]{ebookbase=dicaC,colback=dicaBG,
  title={\faLightbulb\hspace{6pt}\MakeUppercase{Dica ENEM}\ifstrempty{#1}{}{\,·\,#1}}}
\newtcolorbox{macete}[1][]{ebookbase=maceteC,colback=maceteBG,
  title={\faBolt\hspace{6pt}\MakeUppercase{Macete}\ifstrempty{#1}{}{\,·\,#1}}}
\newtcolorbox{atencao}[1][]{ebookbase=atencaoC,colback=atencaoBG,
  title={\faExclamationTriangle\hspace{6pt}\MakeUppercase{Pegadinha}\ifstrempty{#1}{}{\,·\,#1}}}
\newtcolorbox{contexto}[1][]{ebookbase=contextoC,colback=contextoBG,
  title={\faGlobeAmericas\hspace{6pt}\MakeUppercase{No mundo real}\ifstrempty{#1}{}{\,·\,#1}}}
\newtcolorbox{resumo}[1][]{enhanced,breakable,arc=6pt,boxrule=.8pt,colframe=ebookPrim,
  colback=white,left=10pt,right=10pt,top=8pt,bottom=8pt,before skip=12pt,after skip=12pt,
  title={\faClipboardList\hspace{6pt}\MakeUppercase{Resumo para a prova}\ifstrempty{#1}{}{\,·\,#1}},
  fonttitle=\titlefontsemi\small,colbacktitle=ebookPrim,coltitle=white}
\newtcolorbox{exemplo}[1][]{enhanced,breakable,arc=5pt,boxrule=.6pt,colframe=ebookLine,
  colback=white,left=10pt,right=10pt,top=8pt,bottom=8pt,before skip=10pt,after skip=10pt,
  segmentation style={dashed,ebookLine,line width=.6pt},
  title={\faPencil*\hspace{6pt}\MakeUppercase{Exemplo resolvido}\ifstrempty{#1}{}{\,·\,#1}},
  fonttitle=\titlefontsemi\small,coltitle=exemploC,attach title to upper={\par\smallskip},
  colupper=ebookText,collower=ebookText}
\newcommand\solucao{\tcblower{\sffamily\bfseries\color{ebookPrim}Solução.}\enspace}
\tcbset{ebookformula/.style={enhanced,arc=5pt,boxrule=0pt,colback=ebookLight!55,
  left=10pt,right=10pt,top=6pt,bottom=6pt,before skip=8pt,after skip=8pt,halign=center}}
\NewDocumentEnvironment{formula}{o}
  {\IfValueTF{#1}
    {\begin{tcolorbox}[ebookformula,title={#1},attach boxed title to top left={xshift=8pt,yshift=-6pt},
      boxed title style={colback=ebookPrim,arc=3pt,boxrule=0pt},fonttitle=\sffamily\scriptsize\bfseries,top=11pt]}
    {\begin{tcolorbox}[ebookformula]}}
  {\end{tcolorbox}}

%% ---------------------------------------------------------------------
%% Alternativas
%% ---------------------------------------------------------------------
\DeclareRobustCommand\ebook@letra[1]{\tikz[baseline=(l.base)]\node[circle,draw=ebookPrim,line width=.7pt,
  text=ebookPrim,font=\sffamily\footnotesize\bfseries,inner sep=0pt,minimum size=1.35em](l){#1};}
\newlist{alternativas}{enumerate}{1}
\setlist[alternativas]{label=\ebook@letra{\Alph*},ref=\Alph*,leftmargin=2.3em,labelsep=.6em,
  itemsep=3pt,topsep=4pt,parsep=0pt}
% alternativas em colunas: \begin{alternativas*}[3]
\NewDocumentEnvironment{alternativas*}{O{2}}
  {\setlength\columnsep{1.5em}\begin{multicols}{#1}\begin{alternativas}}
  {\end{alternativas}\end{multicols}}
\newcommand\comando[1]{\par\smallskip{#1}\par}

%% ---------------------------------------------------------------------
%% Questões
%% ---------------------------------------------------------------------
\newcommand\secaoenem{%
  \section{Questões de edições anteriores}
  \begin{tcolorbox}[enhanced,colback=ebookSoft,colframe=ebookSoft,arc=5pt,left=8pt,right=8pt,top=6pt,bottom=6pt]
  \small\faChartLine\hspace{5pt}As questões a seguir são \textbf{oficiais}, aplicadas pelo INEP, e estão em
  \textbf{ordem crescente de dificuldade}, segundo o \textbf{parâmetro $b$ da TRI} divulgado nos
  microdados do ENEM. O selo mostra o nível e a posição aproximada do item na escala de notas
  ($500 + 100b$). Tente resolver antes de clicar em \textit{Resolução}.
  \end{tcolorbox}}
\newcommand\secaoineditas{%
  \section{Questões inéditas}
  \begin{tcolorbox}[enhanced,colback=ebookSoft,colframe=ebookSoft,arc=5pt,left=8pt,right=8pt,top=6pt,bottom=6pt]
  \small\faFeather*\hspace{5pt}Questões \textbf{originais}, escritas no estilo do ENEM e organizadas
  \textbf{da mais fácil para a mais difícil}. O nível indicado é uma \textbf{estimativa} pedagógica
  calibrada pelas questões oficiais do capítulo.
  \end{tcolorbox}}

\newtcolorbox{ebook@qbox}[2]{enhanced,breakable,arc=6pt,boxrule=.8pt,colframe=#1,colback=white,
  left=11pt,right=11pt,top=9pt,bottom=7pt,before skip=12pt,after skip=10pt,
  title={#2},fonttitle=\sffamily,colbacktitle=#1!8!white,coltitle=ebookText,
  toptitle=4pt,bottomtitle=4pt,titlerule=.6pt,
  borderline west={3pt}{0pt}{#1}}

\newcommand\ebook@qheadenem[1]{%
  \hypertarget{q-\thechapter-\thequestao}{}\label{q:\thechapter:\thequestao}%
  {\titlefont\color{ebookDark}QUESTÃO \thequestao}\hspace{6pt}%
  \chip{ebookDark}{\faUniversity\, ENEM \csname enem@#1@ano\endcsname}\hspace{2pt}%
  \chipborda{ebookMuted}{Q\csname enem@#1@q\endcsname\,·\,Caderno \csname enem@#1@cad\endcsname}\hspace{2pt}%
  \chip{ebookPrim}{H\csname enem@#1@hab\endcsname}\hfill
  \selonivel{\csname enem@#1@niv\endcsname}\par\vspace{1pt}%
  {\scriptsize\color{ebookMuted}TRI (INEP):\enspace $a=\virgula{\csname enem@#1@a\endcsname}$\enspace
   $b=\virgula{\csname enem@#1@b\endcsname}$\enspace $c=\virgula{\csname enem@#1@c\endcsname}$\enspace
   \faArrowRight\enspace item posicionado em \textbf{\csname enem@#1@pts\endcsname} na escala do ENEM}}

\newcommand\ebook@bolha[1]{\hspace{3pt}\textbf{#1}\hspace{1.5pt}\raisebox{-1.6pt}{%
  \CheckBox[name=resp-v\ebook@vol-\thechapter-\thequestao-#1,width=8pt,height=8pt,
    bordercolor={0.58 0.64 0.72},backgroundcolor={1 1 1},borderwidth=0.6pt,
    checkboxsymbol=\ding{108},color={0.06 0.46 0.43}]{}}}
\newcommand\ebook@qfoot{%
  \par\smallskip
  {\sffamily\scriptsize\color{ebookMuted}\faEdit\hspace{3pt}Cartão-resposta:\hspace{2pt}%
   \ebook@bolha{A}\ebook@bolha{B}\ebook@bolha{C}\ebook@bolha{D}\ebook@bolha{E}}%
  \hfill
  \hyperref[r:\thechapter:\thequestao]{\tikz[baseline=(b.base)]\node[fill=ebookPrim,text=white,
    rounded corners=3pt,inner xsep=6pt,inner ysep=2.5pt,font=\sffamily\scriptsize\bfseries](b)
    {\strut Resolução comentada \faArrowRight\ p.\,\pageref*{r:\thechapter:\thequestao}};}}

% \questaoenem{id}: insere o enunciado oficial (arquivo enem/<id>.tex)
\newcommand\questaoenem[1]{%
  \ifcsname enem@#1@ano\endcsname\else
    \ClassError{enemebook}{Questão ENEM desconhecida: #1}{Verifique dados/enem-meta.tex}\fi
  \ebook@checkpend
  \refstepcounter{questao}%
  \gdef\ebook@curid{#1}%
  \xdef\ebook@curniv{\csname enem@#1@niv\endcsname}%
  \xdef\ebook@curtipo{ENEM \csname enem@#1@ano\endcsname}%
  \global\ebook@pendtrue
  \bookmark[dest=q-\thechapter-\thequestao,level=2]{Questão \thequestao\ (ENEM \csname enem@#1@ano\endcsname)}%
  \begin{ebook@qbox}{\nivelcor{\csname enem@#1@niv\endcsname}}{\ebook@qheadenem{#1}}
    \input{enem/#1.tex}%
    \ebook@qfoot
  \end{ebook@qbox}}

% \begin{questaoinedita}{nível 1-4}{habilidade}
\newenvironment{questaoinedita}[2]{%
  \ebook@checkpend
  \refstepcounter{questao}%
  \gdef\ebook@curid{}%
  \xdef\ebook@curniv{#1}%
  \gdef\ebook@curtipo{Inédita}%
  \global\ebook@pendtrue
  \bookmark[dest=q-\thechapter-\thequestao,level=2]{Questão \thequestao\ (inédita)}%
  \begin{ebook@qbox}{\nivelcor{#1}}{%
    \hypertarget{q-\thechapter-\thequestao}{}\label{q:\thechapter:\thequestao}%
    {\titlefont\color{ebookDark}QUESTÃO \thequestao}\hspace{6pt}%
    \chip{ebookAcc}{\faFeather*\, INÉDITA}\hspace{2pt}%
    \chip{ebookPrim}{H#2}\hfill\selonivel{#1}\par\vspace{1pt}%
    {\scriptsize\color{ebookMuted}Nível estimado pelos autores, com base nas questões oficiais de mesmo tema.}}}
  {\ebook@qfoot\end{ebook@qbox}}

%% ---------------------------------------------------------------------
%% Resoluções (guardadas e impressas no fim do capítulo)
%% ---------------------------------------------------------------------
\newif\ifebook@pend \ebook@pendfalse
\newcommand\ebook@checkpend{\ifebook@pend
  \ClassError{enemebook}{A questão \thequestao\ do capítulo \thechapter\ está sem resolução}{Escreva o ambiente resolucao logo após a questão.}\fi}
\newcommand\ebook@resfile{\jobname-res-\thechapter-\thequestao.tex}
\newenvironment{resolucao}[1]{%
  \ifebook@pend\else
    \ClassError{enemebook}{Resolução sem questão correspondente (cap. \thechapter)}{}\fi
  \global\ebook@pendfalse
  \ifx\ebook@curid\@empty\else
    \edef\ebook@tmpgab{\csname enem@\ebook@curid @gab\endcsname}%
    \edef\ebook@tmpres{#1}%
    \ifx\ebook@tmpgab\ebook@tmpres\else
      \ClassError{enemebook}{GABARITO DIVERGENTE na questão ENEM \ebook@curid:
        resolução indica #1, gabarito oficial é \ebook@tmpgab}{Corrija a resolução.}%
    \fi
  \fi
  \xdef\ebook@tmpentry{\noexpand\ebook@resitem{\thequestao}{#1}{\ebook@curniv}{\ebook@curtipo}{\ebook@curid}}%
  \expandafter\g@addto@macro\expandafter\ebook@reslist\expandafter{\ebook@tmpentry}%
  \VerbatimEnvironment
  \begin{VerbatimOut}{\ebook@resfile}}
  {\end{VerbatimOut}}

\newcommand\ebook@resitem[5]{% {n}{gab}{nível}{tipo}{id}
  \begin{tcolorbox}[enhanced,breakable,arc=6pt,boxrule=.6pt,colframe=ebookLine,colback=white,
    left=11pt,right=11pt,top=8pt,bottom=8pt,before skip=10pt,after skip=8pt,
    borderline west={3pt}{0pt}{\nivelcor{#3}},
    title={\phantomsection\hypertarget{r-\thechapter-#1}{}\label{r:\thechapter:#1}%
      {\titlefont\color{ebookDark}RESOLUÇÃO · QUESTÃO #1}\hspace{6pt}%
      {\scriptsize\color{ebookMuted}#4}\hfill
      \hyperref[q:\thechapter:#1]{\chipborda[ebookPrim]{ebookPrim}{\faUndo\ Voltar à questão (p.\,\pageref*{q:\thechapter:#1})}}\hspace{4pt}%
      \tikz[baseline=(g.base)]\node[fill=\nivelcor{#3},text=white,rounded corners=3pt,inner xsep=6pt,inner ysep=2.5pt,
        font=\titlefont\small](g){Gabarito: #2};},
    fonttitle=\sffamily,colbacktitle=ebookPaper,coltitle=ebookText,toptitle=4pt,bottomtitle=4pt,titlerule=.5pt]
    \input{\jobname-res-\thechapter-#1.tex}
  \end{tcolorbox}}

% análise das alternativas incorretas
\newenvironment{distratores}{%
  \par\smallskip{\sffamily\small\bfseries\color{ebookPrim}\faSearch\hspace{4pt}Por que as outras alternativas estão erradas?}\par
  \begin{itemize}[leftmargin=2.1em,itemsep=1pt,topsep=2pt,label={}]\small}
  {\end{itemize}}
\newcommand\alt[1]{\item[\ebook@letra{#1}]}
\newcommand\passo[1]{\par\smallskip{\sffamily\bfseries\color{ebookPrim}#1}\enspace}
\newcommand\resposta[1]{\par\smallskip\textbf{\color{ebookPrim}\faCheck\ Resposta:} #1}

\newcommand\fimcapitulo{%
  \ebook@checkpend
  \ifebook@capaberto
  \clearpage
  \section*{Resoluções comentadas}%
  \phantomsection\hypertarget{res-\thechapter}{}%
  \bookmark[dest=res-\thechapter,level=1]{Resoluções comentadas}%
  \addcontentsline{toc}{section}{\protect\numberline{}Resoluções comentadas}%
  \ebook@gabaritorapido
  \ebook@reslist
  \global\ebook@capabertofalse
  \fi}

% tabela de gabarito rápido do capítulo
\newcommand\ebook@gabaritorapido{%
  \begingroup
  \def\ebook@resitem##1##2##3##4##5{%
    \hyperref[r:\thechapter:##1]{\tikz[baseline=(x.base)]{\node[draw=ebookLine,rounded corners=3pt,
      minimum width=12.5mm,inner sep=3pt,font=\sffamily\footnotesize,text=ebookText](x)
      {\textcolor{ebookMuted}{##1}\,\textbf{\textcolor{\nivelcor{##3}}{##2}}};}}\hspace{2pt}\allowbreak}%
  \begin{tcolorbox}[enhanced,colback=ebookSoft,colframe=ebookLight,arc=5pt,boxrule=.6pt,left=8pt,right=8pt]
    {\titlefontsemi\small\color{ebookPrim}\faListOl\hspace{5pt}\MakeUppercase{Gabarito rápido do capítulo \thechapter}}\par\smallskip
    {\raggedright\ebook@reslist\par}
    \smallskip{\scriptsize\color{ebookMuted}Clique no número para abrir a resolução. A cor indica o nível de dificuldade.}
  \end{tcolorbox}
  \endgroup
  \xdef\ebook@tmpcap{\thechapter}%
  \expandafter\g@addto@macro\expandafter\ebook@gabglobal\expandafter{%
    \expandafter\ebook@gabcap\expandafter{\ebook@tmpcap}}%
  \expandafter\g@addto@macro\expandafter\ebook@gabglobal\expandafter{\expandafter{\ebook@reslist}}}

% gabarito geral do volume
\newcommand\gabaritogeral{%
  \ifebook@capaberto\fimcapitulo\fi
  \clearpage
  \global\ebook@abasfalse
  \global\ebook@emcapitulofalse
  \chapter*{Gabarito geral}\markboth{Gabarito geral}{}%
  \hypertarget{gabarito-geral}{}%
  \addcontentsline{toc}{chapter}{Gabarito geral}%
  Clique em qualquer resposta para ir direto à resolução comentada.\par\medskip
  \begingroup
  \ebook@gabglobal
  \endgroup}
\newcommand\ebook@gabcap[2]{%
  \begingroup
  \def\ebook@resitem##1##2##3##4##5{%
    \hyperref[r:#1:##1]{\tikz[baseline=(x.base)]{\node[draw=ebookLine,rounded corners=3pt,
      minimum width=11.5mm,inner sep=2.5pt,font=\sffamily\scriptsize,text=ebookText](x)
      {\textcolor{ebookMuted}{##1}\,\textbf{\textcolor{\nivelcor{##3}}{##2}}};}}\hspace{1.5pt}\allowbreak}%
  \needspace{3\baselineskip}%
  \noindent\hyperlink{cap-#1}{\chip{ebookPrim}{Cap. #1}}\hspace{4pt}%
  {\sffamily\small\bfseries\csname cap@\csname capnum@\ebook@vol @#1\endcsname @tit\endcsname}\par\smallskip
  {\raggedright #2\par}\medskip
  \endgroup}


%% ---------------------------------------------------------------------
%% Páginas iniciais e finais (pré-textuais)
%% ---------------------------------------------------------------------
\newcommand\capitulofrontal[2]{% {título}{alvo}
  \chapter*{#1}\markboth{#1}{}%
  \hypertarget{#2}{}%
  \addcontentsline{toc}{chapter}{#1}}
\newcommand\secaofrontal[1]{%
  \section*{#1}\addcontentsline{toc}{section}{#1}}
% link para um capítulo de qualquer volume: \caplink{vol}{núm}
\newcommand\caplink[2]{%
  \ifnum#1=\ebook@vol\relax
    \hyperlink{cap-#2}{\chip{ebookPrim}{V#1 · Cap.~#2}}%
  \else
    \href{ENEM-Matematica-Volume-#1.pdf\#cap-#2}{\chipborda[ebookPrim]{ebookPrim}{V#1 · Cap.~#2 \faExternalLink*}}%
  \fi}
% linha da tabela de habilidades
\newcommand\habitem[2]{%
  \textbf{\color{ebookPrim}H#1} & #2 &
  \tikz[baseline=-0.6ex]{\fill[ebookLight] (0,-.12) rectangle (2.2,.12);
    \fill[ebookPrim] (0,-.12) rectangle ({2.2*\csname habfreq@#1\endcsname/35},.12);}%
  \hspace{3pt}{\scriptsize\csname habfreq@#1\endcsname}\\}
% painel "raio-x": barras empilhadas por capítulo do volume atual
\newcommand\raioxvolume{%
  \begin{tikzpicture}[x=0.95mm,y=1mm]
    \def\ebook@max{0}%
    \foreach \k in {1,...,\value{ebook@nchap}}{%
      \edef\ebook@cid{\csname capnum@\ebook@vol @\k\endcsname}%
      \expandafter\expandafter\expandafter\ebook@raioxlinha\csname cap@\ebook@cid @stats\endcsname{\k}}
    \draw[ebookLine] (0,0.5) -- (0,{-8.2*\value{ebook@nchap}+1});
  \end{tikzpicture}}
\newcommand\ebook@raioxlinha[6]{% {total}{f}{m}{d}{md}{k}
  \pgfmathsetmacro\ya{-8.2*#6+3}%
  \node[anchor=east,font=\sffamily\footnotesize,text width=58mm,align=right,inner sep=2pt] at (-1,\ya+1.6)
    {\hyperlink{cap-#6}{\textcolor{ebookPrim}{\textbf{\twodigit{#6}}}\enspace\csname cap@\csname capnum@\ebook@vol @#6\endcsname @tit\endcsname}};
  \pgfmathsetmacro\xa{#2}\pgfmathsetmacro\xb{#2+#3}\pgfmathsetmacro\xc{#2+#3+#4}\pgfmathsetmacro\xd{#1}%
  \fill[nivelA] (0,\ya) rectangle (\xa,\ya+3.4);
  \fill[nivelB] (\xa,\ya) rectangle (\xb,\ya+3.4);
  \fill[nivelC] (\xb,\ya) rectangle (\xc,\ya+3.4);
  \fill[nivelD] (\xc,\ya) rectangle (\xd,\ya+3.4);
  \node[anchor=west,font=\sffamily\scriptsize\bfseries,text=ebookText] at (\xd+0.5,\ya+1.7) {#1};}

%% ---------------------------------------------------------------------
%% Capa
%% ---------------------------------------------------------------------
\newcommand\ebook@capalista{%
  \foreach \k in {1,...,\value{ebook@nchap}}{%
    \edef\ebook@cid{\csname capnum@\ebook@vol @\k\endcsname}%
    \par\noindent\hangindent=8mm\hangafter=1\raggedright
    \hyperlink{cap-\k}{\makebox[8mm][l]{\titlefont\color{ebookAcc}\twodigit{\k}}%
      \titlefontsemi\color{white}\csname cap@\ebook@cid @tit\endcsname}\par\vspace{1.6mm}}}
\newcommand\ebook@cartao[3]{%
  \node[anchor=south west,fill=white,fill opacity=.10,text opacity=1,rounded corners=4pt,
    minimum height=17mm,inner sep=3mm,text=white,text width=34mm,font=\sffamily\footnotesize]
    at ([xshift=20mm+#1*43.3mm,yshift=66mm]current page.south west)
    {{\Large\color{ebookAcc}#2}\par\vspace{1mm}\textbf{#3}};}
\newcommand\capa{%
  \thispagestyle{vazio}%
  \begin{tikzpicture}[remember picture,overlay]
    \shade[upper left=ebookGradA,lower right=ebookGradB,upper right=ebookGradA!70!ebookGradB,
      lower left=ebookGradB!80!ebookGradA] (current page.south west) rectangle (current page.north east);
    \begin{scope}[opacity=.07,white,line width=.5pt]
      \foreach \x in {0,6,...,216}{\draw ([xshift=\x mm]current page.south west) -- ++(0,\paperheight);}
      \foreach \y in {0,6,...,300}{\draw ([yshift=\y mm]current page.south west) -- ++(\paperwidth,0);}
    \end{scope}
    \begin{scope}[shift={([xshift=-58mm,yshift=-95mm]current page.north east)},opacity=.16,white,line width=2pt]
      \draw (-50mm,-40mm) parabola bend (0,30mm) (50mm,-40mm);
      \draw (0,-5mm) circle (34mm);
      \draw (-45mm,-20mm) -- (35mm,-20mm) -- (-10mm,40mm) -- cycle;
      \draw[domain=-5.5:5.5,samples=60,smooth,x=1cm,y=1cm] plot (\x,{1.2*sin(\x*100)});
    \end{scope}
    \node[anchor=north west,inner sep=0pt] at ([xshift=20mm,yshift=-22mm]current page.north west)
      {\color{ebookAcc}\rule{14mm}{2.2mm}};
    \node[anchor=north west,inner sep=0pt,text=white,font=\titlefontsemi\large]
      at ([xshift=38mm,yshift=-20.5mm]current page.north west) {COLEÇÃO \textls[200]{ESCALA TRI}};
    \node[anchor=north west,inner sep=0pt,text=white,font=\titlefontblack\fontsize{60}{60}\selectfont]
      at ([xshift=18mm,yshift=-40mm]current page.north west) {\fontsize{50}{50}\selectfont MATEMÁTICA};
    \node[anchor=north west,inner sep=0pt,text=white,font=\titlefontlight\fontsize{34}{36}\selectfont]
      at ([xshift=19mm,yshift=-64mm]current page.north west) {PARA O \textbf{ENEM}};
    \node[circle,fill=ebookAcc,minimum size=34mm,inner sep=0pt,anchor=center]
      (vol) at ([xshift=-38mm,yshift=-96mm]current page.north east) {};
    \node[text=ebookDark,font=\titlefontsemi\small,anchor=south] at ([yshift=4mm]vol.center) {VOLUME};
    \node[text=ebookDark,font=\titlefontblack\fontsize{50}{50}\selectfont,anchor=north] at ([yshift=6mm]vol.center) {\ebook@vol};
    \node[anchor=north west,inner sep=0pt,text=white,font=\titlefont\fontsize{19}{23}\selectfont,text width=150mm]
      at ([xshift=20mm,yshift=-84mm]current page.north west) {\ebook@voltitle};
    \node[anchor=north west,inner sep=0pt,text=white,font=\sffamily\small,text width=95mm,opacity=.92]
      at ([xshift=20mm,yshift=-100mm]current page.north west)
      {Teoria completa, dicas, macetes, questões oficiais do ENEM \anosbanco\ ordenadas pela
       \textbf{dificuldade real da TRI} e questões inéditas do fácil ao muito difícil — todas
       com resolução comentada.};
    \node[anchor=north west,inner sep=0pt,text width=172mm]
      at ([xshift=20mm,yshift=-130mm]current page.north west)
      {{\titlefontsemi\small\color{ebookAcc}NESTE VOLUME}\par\vspace{3mm}\small
       \setlength\columnsep{10mm}\begin{multicols}{2}\ebook@capalista\end{multicols}};
    % destaques
    \ebook@cartao{0}{\faBookOpen}{Teoria, dicas\newline e macetes}
    \ebook@cartao{1}{\faUniversity}{Questões oficiais\newline com selo TRI}
    \ebook@cartao{2}{\faFeather*}{Inéditas: do fácil\newline ao muito difícil}
    \ebook@cartao{3}{\faCheckCircle}{Resoluções\newline comentadas}
    % escala TRI
    \begin{scope}[shift={([xshift=20mm,yshift=40mm]current page.south west)}]
      \node[anchor=south west,text=white,font=\titlefontsemi\small,inner sep=0pt] at (0,13mm)
        {ESCALA DE DIFICULDADE DO ENEM (TRI)};
      \fill[nivelA] (0,0) rectangle (56.67mm,6mm);
      \fill[nivelB] (56.67mm,0) rectangle (85mm,6mm);
      \fill[nivelC] (85mm,0) rectangle (113.33mm,6mm);
      \fill[nivelD] (113.33mm,0) rectangle (170mm,6mm);
      \foreach \v/\x in {400/0,500/28.33,600/56.67,700/85,800/113.33,900/141.67,1000/170}{
        \draw[white,line width=.6pt] (\x mm,0) -- (\x mm,-1.5mm);
        \node[text=white,font=\sffamily\scriptsize,anchor=north] at (\x mm,-1.6mm) {\v};}
      \foreach \t/\x in {Fácil/28,Média/71,Difícil/99,Muito difícil/142}{
        \node[text=white,font=\sffamily\scriptsize\bfseries,anchor=south] at (\x mm,6.6mm) {\t};}
    \end{scope}
    \node[anchor=south west,inner sep=0pt,text=white,font=\sffamily\scriptsize,opacity=.85,text width=170mm]
      at ([xshift=20mm,yshift=14mm]current page.south west)
      {\faMousePointer\ PDF interativo: sumário e abas clicáveis, links questão $\leftrightarrow$ resolução,
       cartão-resposta e checklist de progresso. \hfill Edição 2026};
  \end{tikzpicture}%
  \null\clearpage}

%% ---------------------------------------------------------------------
%% Outros
%% ---------------------------------------------------------------------
\newcommand\sumario{%
  \chapter*{Sumário}\markboth{Sumário}{}%
  \hypertarget{sumario}{}%
  \bookmark[dest=sumario,level=0]{Sumário}%
  \etocsetnexttocdepth{section}%
  \tableofcontents}
\newcommand\iniciomateria{%
  \cleardoublepage\pagenumbering{arabic}}
\newcommand\vollink[3]{% {volume}{destino}{texto}: link para outro volume
  \href{ENEM-Matematica-Volume-#1.pdf\##2}{#3}}

\AddToHook{begindocument/end}{\begin{Form}}
\AtEndDocument{\ifebook@capaberto\fimcapitulo\fi\end{Form}}
\renewcommand*\LayoutChoiceField[2]{#2}
\renewcommand*\LayoutCheckField[2]{#2}
\endinput
