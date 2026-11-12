%% kuthesis.cls
%% Unofficial LaTeX class for Kasetsart University theses (science track),
%% following "คู่มือการพิมพ์วิทยานิพนธ์ สายวิทยาศาสตร์" (Graduate School, KU, 2553/2010).
%%
%% Copyright (C) 2026 Punpiti Piamsa-nga
%% This work may be distributed and/or modified under the conditions of the
%% LaTeX Project Public License, version 1.3c or later.
%%
%% Engine: XeLaTeX (ICU dictionary-based Thai line breaking).
%%
%% Measurements follow the manual's typewriter-era convention: the top margin
%% (1.5 in) and bottom margin (1 in) are measured to the BASELINE of the first
%% and last lines, and the page number's baseline is 1 in from the top edge.
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{kuthesis}[2026/11/13 v0.1 Kasetsart University thesis, science track (unofficial)]

\RequirePackage{iftex}
\RequireXeTeX

% ---------------------------------------------------------------------------
% Options
% ---------------------------------------------------------------------------
\newif\ifku@thai      \ku@thaitrue
\newif\ifku@numbered  \ku@numberedfalse
\newif\ifku@guides    \ku@guidesfalse
\newif\ifku@doctor    \ku@doctorfalse
\def\ku@latin{termes}
\def\ku@math{termes}
\def\ku@thaifontname{TH Sarabun New}

\DeclareKeys{
  thai       .code = \ku@thaitrue,
  english    .code = \ku@thaifalse,
  master     .code = \ku@doctorfalse,
  doctor     .code = \ku@doctortrue,
  numbered   .if   = ku@numbered,
  guides     .if   = ku@guides,
  latin      .store = \ku@latin,
  math       .store = \ku@math,
  thaifont   .store = \ku@thaifontname,
}
\DeclareUnknownKeyHandler{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessKeyOptions\relax

\LoadClass[a4paper,oneside]{report}

% ---------------------------------------------------------------------------
% Packages
% ---------------------------------------------------------------------------
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{fontspec}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{needspace}
\RequirePackage{graphicx}
\RequirePackage{pict2e}
\RequirePackage{xcolor}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{booktabs}
\RequirePackage{pdflscape}
\RequirePackage{enumitem}
\RequirePackage[hang]{caption}
\RequirePackage{refcount}

% ---------------------------------------------------------------------------
% Fonts
%   * Thai script      -> TH Sarabun New (option thaifont=...)
%   * everything else  -> TeX Gyre Termes (default, latin=termes): free,
%                         metric-compatible Times New Roman, the font the
%                         manual names for English; Inter (latin=inter); or
%                         the Thai font itself (latin=sarabun)
%   * math             -> TeX Gyre Termes Math (default) / Fira Math /
%                         Lete Sans Math / New Computer Modern / STIX Two
%   Nominal sizes are Thai points. Termes is scaled 0.75 so that the body
%   (16) is exactly Times 12 pt and English headings are Times 14 pt, as the
%   manual prescribes; its x-height (5.40 pt) then matches TH Sarabun New
%   16 pt (5.44 pt). The other fonts are scaled to the same x-height.
% ---------------------------------------------------------------------------
\defaultfontfeatures{Ligatures=TeX}
% The Thai font is used from the system if installed; otherwise from the
% files THSarabunNew*.ttf in fonts/, ../kuthesis/fonts/ (installer
% workspace, building in output/), kuthesis/fonts/, ../fonts/, ../../fonts/
% (repository root when building in work/<name>/), or anywhere kpathsea
% finds them. No system-wide font installation is needed.
\newif\ifku@thaibyfile
\IfFontExistsTF{\ku@thaifontname}{}{\ku@thaibyfiletrue}
\ifku@thaibyfile
  \def\ku@thaipath{}%
  \def\ku@trypath#1{\IfFileExists{#1THSarabunNew.ttf}{\def\ku@thaipath{#1}\let\ku@tryrest\relax}{}}%
  \let\ku@tryrest\@empty
  \@for\ku@p:={fonts/,../kuthesis/fonts/,kuthesis/fonts/,../fonts/,../../fonts/}\do{%
    \ifx\ku@tryrest\@empty\expandafter\ku@trypath\expandafter{\ku@p}\fi}%
  \ifx\ku@tryrest\@empty
      \IfFileExists{THSarabunNew.ttf}{}{%
        \ClassError{kuthesis}{Thai font `\ku@thaifontname' not found}
          {Install TH Sarabun New, or copy THSarabunNew.ttf, THSarabunNew Bold.ttf,\MessageBreak
           THSarabunNew Italic.ttf and THSarabunNew BoldItalic.ttf into a folder\MessageBreak
           named fonts/ next to your thesis (see AI-SETUP.md).}}%
  \fi
  \newcommand\ku@loadthai[2]{#1{THSarabunNew}[Path=\ku@thaipath, Extension=.ttf,
    UprightFont=*, BoldFont=* Bold, ItalicFont=* Italic, BoldItalicFont=* BoldItalic,
    Script=Thai, #2]}
\else
  \newcommand\ku@loadthai[2]{#1{\ku@thaifontname}[Script=Thai, #2]}
\fi
\ku@loadthai{\newfontfamily\ku@thaifamily}{NFSSFamily=kuthai}
\edef\ku@thaifam{kuthai}

\def\ku@tmp{sarabun}
\ifx\ku@latin\ku@tmp
  \ku@loadthai{\setmainfont}{}
  \ku@loadthai{\setsansfont}{}
\else\def\ku@tmp{termes}\ifx\ku@latin\ku@tmp
  \setmainfont{texgyretermes}[
    Extension=.otf, UprightFont=*-regular, BoldFont=*-bold,
    ItalicFont=*-italic, BoldItalicFont=*-bolditalic, Scale=0.75]
  \setsansfont{texgyretermes}[
    Extension=.otf, UprightFont=*-regular, BoldFont=*-bold,
    ItalicFont=*-italic, BoldItalicFont=*-bolditalic, Scale=0.75]
\else
  \setmainfont{Inter}[
    Extension=.otf, UprightFont=*-Regular, BoldFont=*-Bold,
    ItalicFont=*-Italic, BoldItalicFont=*-BoldItalic, Scale=0.623,
    RawFeature=-calt]
  \setsansfont{Inter}[
    Extension=.otf, UprightFont=*-Regular, BoldFont=*-Bold,
    ItalicFont=*-Italic, BoldItalicFont=*-BoldItalic, Scale=0.623,
    RawFeature=-calt]
\fi\fi
\setmonofont{FiraMono}[
  Extension=.otf, UprightFont=*-Regular, BoldFont=*-Bold,
  ItalicFont=*-Oblique, BoldItalicFont=*-BoldOblique, Scale=0.645]

\def\ku@tmp{none}
\ifx\ku@math\ku@tmp\else
  \RequirePackage{unicode-math}
  \def\ku@tmp{termes}\ifx\ku@math\ku@tmp
    \setmathfont{texgyretermes-math.otf}[Scale=0.75]\fi
  \def\ku@tmp{fira}\ifx\ku@math\ku@tmp
    \setmathfont{FiraMath-Regular.otf}[Scale=0.645]\fi
  \def\ku@tmp{lete}\ifx\ku@math\ku@tmp
    \setmathfont{LeteSansMath.otf}[Scale=0.756]\fi
  \def\ku@tmp{newcm}\ifx\ku@math\ku@tmp
    \setmathfont{NewCMMath-Regular.otf}[Scale=0.789]\fi
  \def\ku@tmp{stix}\ifx\ku@math\ku@tmp
    \setmathfont{STIXTwoMath-Regular.otf}[Scale=0.719]\fi
\fi

% Automatic script switching (XeTeX inter-character tokens).
% Thai characters switch to the Thai family; the first Latin letter after Thai
% switches back to whatever family was active (rm, sf, tt ...). Digits and
% common punctuation are "neutral" and stay in the current font.
\XeTeXinterchartokenstate=1
\newXeTeXintercharclass\ku@thaiclass
\newXeTeXintercharclass\ku@neutralclass
\@tempcnta="0E01
\loop\ifnum\@tempcnta<"0E5C
  \XeTeXcharclass\@tempcnta=\ku@thaiclass
  \advance\@tempcnta\@ne
\repeat
\@tempcnta="30
\loop\ifnum\@tempcnta<"3A
  \XeTeXcharclass\@tempcnta=\ku@neutralclass
  \advance\@tempcnta\@ne
\repeat
\@for\ku@c:={"21,"22,"25,"27,"28,"29,"2C,"2D,"2E,"2F,"3A,"3B,"3F,"5B,"5D}\do{%
  \XeTeXcharclass\ku@c=\ku@neutralclass}
\XeTeXcharclass"2013=\ku@neutralclass % en dash
\XeTeXcharclass"2014=\ku@neutralclass % em dash
\XeTeXcharclass"2018=\ku@neutralclass
\XeTeXcharclass"2019=\ku@neutralclass
\XeTeXcharclass"201C=\ku@neutralclass
\XeTeXcharclass"201D=\ku@neutralclass

\def\ku@tothai{%
  \ifx\f@family\ku@thaifam\else
    \let\ku@prevfam\f@family
    \fontfamily{\ku@thaifam}\selectfont
  \fi}
\def\ku@fromthai{%
  \ifx\f@family\ku@thaifam
    \ifdefined\ku@prevfam\fontfamily{\ku@prevfam}\else\rmfamily\fi
    \selectfont
  \fi}
\XeTeXinterchartoks 0               \ku@thaiclass = {\ku@tothai}
\XeTeXinterchartoks 4095            \ku@thaiclass = {\ku@tothai}
\XeTeXinterchartoks \ku@neutralclass \ku@thaiclass = {\ku@tothai}
\XeTeXinterchartoks \ku@thaiclass    0 = {\ku@fromthai}
\XeTeXinterchartoks \ku@neutralclass 0 = {\ku@fromthai}
\XeTeXinterchartoks 4095            0 = {\ku@fromthai}

% Thai line breaking (ICU dictionary). A little stretch at Thai word
% boundaries helps justification without visible gaps.
\XeTeXlinebreaklocale "th"
\XeTeXlinebreakskip = 0pt plus 0.6pt
\emergencystretch=2em

% ---------------------------------------------------------------------------
% Sizes and spacing
%   Nominal sizes are Thai point sizes as written in the manual:
%   body 16 pt, major heading 18 pt, minimum inside tables/figures 14 pt.
%   Line pitch measured from the manual's sample pages:
%     Thai thesis    16 pt "single"      -> 21.6 pt
%     English thesis 12 pt TNR x 1.5     -> 20.7 pt
% ---------------------------------------------------------------------------
\newdimen\ku@bls
% Word/PostScript points (bp), as in the manual's samples
\ifku@thai \ku@bls=21.6bp \else \ku@bls=20.7bp \fi
\newdimen\ku@blsS \ku@blsS=\dimexpr\ku@bls*14/16\relax
% 18-pt heading lines: Thai 25 bp (sample p.29); English single-spaced
% 14-pt TNR equivalent 16.1 bp (sample p.30)
\newdimen\ku@blsL \ifku@thai \ku@blsL=25bp \else \ku@blsL=16.1bp \fi
% In Word the blank line after a heading keeps the heading's size, so the
% gaps around 18-pt headings are a little taller than a body blank line.
% Measured on samples p.29 (Thai) and p.30 (English):
%   heading -> heading   Thai 49.6 bp, English 48.5 bp
%   heading -> body      Thai 44.8 bp, English 46.4 bp
\newdimen\ku@hhgap \newdimen\ku@hbgap
\ifku@thai \ku@hhgap=3bp \ku@hbgap=1.6bp \else \ku@hhgap=11.7bp \ku@hbgap=5bp \fi
% list headings (สารบัญ ...) -> column head: Thai 44.6 bp (p.85), English 42.9 bp (p.90)
\newdimen\ku@listgap \ifku@thai \ku@listgap=4.1bp \else \ku@listgap=7.6bp \fi

\renewcommand\normalsize{%
  \@setfontsize\normalsize{16.06}{\ku@bls}%
  \abovedisplayskip\ku@bls \@plus 2\p@ \@minus 6\p@
  \belowdisplayskip\abovedisplayskip
  \abovedisplayshortskip\abovedisplayskip
  \belowdisplayshortskip\abovedisplayskip
  \let\@listi\@listI}
% English thesis: "large" = Times 14 pt (headings), "small" = Times 11 pt
% (the minimum the manual allows inside tables and figures)
\ifku@thai
  \def\ku@smallsize{14.05}\def\ku@largesize{18.07}
\else
  \def\ku@smallsize{14.73}\def\ku@largesize{18.75}
\fi
\renewcommand\small{\@setfontsize\small{\ku@smallsize}{\ku@blsS}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{\ku@smallsize}{\ku@blsS}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{12.05}{16}}
\renewcommand\tiny{\@setfontsize\tiny{10.04}{13}}
\renewcommand\large{\@setfontsize\large{\ku@largesize}{\ku@blsL}}
\renewcommand\Large{\@setfontsize\Large{20}{27}}
\renewcommand\LARGE{\@setfontsize\LARGE{24}{32}}
\renewcommand\huge{\@setfontsize\huge{28}{38}}
\renewcommand\Huge{\@setfontsize\Huge{32}{43}}
\normalsize

\setlength\parindent{0.5in}
\setlength\parskip{\ku@bls}        % one blank line between paragraphs
\setlength\topskip{16bp}
\setlength\maxdepth{8pt}
\raggedbottom
\clubpenalty=10000
\widowpenalty=10000
\displaywidowpenalty=10000
\renewcommand\baselinestretch{1}
\DeclareRobustCommand\ku@twospaces{\hskip 2\fontdimen2\font\relax}
\AtBeginDocument{\pdfstringdefDisableCommands{\def\ku@twospaces{ }}}

% ---------------------------------------------------------------------------
% Page geometry (the "typewriter" measurement)
%   first baseline   1.5 in from top edge
%   last baseline   >= 1 in from bottom edge  (whole number of lines)
%   page number      baseline 1 in from top edge, flush right at 1 in
% ---------------------------------------------------------------------------
\newdimen\ku@avail \newcount\ku@lines \newdimen\ku@textht
\ku@avail=\dimexpr\paperheight-2.5in\relax
\ku@lines=\numexpr\ku@avail/\ku@bls\relax
\ifdim\dimexpr\ku@lines\ku@bls\relax>\ku@avail \advance\ku@lines\m@ne\fi
\ku@textht=\dimexpr\topskip+\ku@lines\ku@bls\relax
\newdimen\ku@spare \ku@spare=\dimexpr\ku@avail-\ku@lines\ku@bls\relax
\newdimen\ku@topm \ku@topm=\dimexpr1.5in-\topskip\relax
% fancyhdr ends the header with a strut: its depth (0.3 baselineskip) lifts
% the page number, so it is subtracted to keep the baseline at exactly 1 in
\newdimen\ku@hsep \ku@hsep=\dimexpr0.5in-\topskip-\ku@bls*3/10\relax
\edef\ku@tmp{\noexpand\geometry{a4paper, left=1.5in, right=1in,
  top=\the\ku@topm, textheight=\the\ku@textht, headheight=24pt,
  headsep=\the\ku@hsep, footskip=24pt}}
\ku@tmp

% Optional measurement guides (class option "guides")
\ifku@guides
  \AddToHook{shipout/foreground}{%
    \begingroup\color{red}\linethickness{0.2pt}%
    \put(0,-1in){\line(1,0){\paperwidth}}%           page-number baseline
    \put(0,-1.5in){\line(1,0){\paperwidth}}%         first baseline
    \put(0,-\dimexpr\paperheight-1in\relax){\line(1,0){\paperwidth}}% 1 in bottom
    \put(1.5in,0){\line(0,-1){\paperheight}}%
    \put(\dimexpr\paperwidth-1in\relax,0){\line(0,-1){\paperheight}}%
    \endgroup}
\fi

% ---------------------------------------------------------------------------
% Language strings
% ---------------------------------------------------------------------------
\ifku@thai
  \def\ku@contentsname{สารบัญ}
  \def\ku@lotname{สารบัญตาราง}
  \def\ku@lofname{สารบัญภาพ}
  \def\ku@abbrname{คำอธิบายสัญลักษณ์และคำย่อ}
  \def\ku@bibname{เอกสารและสิ่งอ้างอิง}
  \def\ku@appname{ภาคผนวก}
  \def\ku@appsname{ภาคผนวก}
  \def\ku@subappname{ภาคผนวก}
  \def\ku@vitaename{ประวัติการศึกษาและการทำงาน}
  \def\ku@ackname{กิตติกรรมประกาศ}
  \def\ku@pagename{หน้า}
  \def\ku@contname{(ต่อ)}
  \def\ku@tabname{ตารางที่}
  \def\ku@figname{ภาพที่}
  \def\ku@apptabname{ตารางผนวกที่}
  \def\ku@appfigname{ภาพผนวกที่}
  \def\ku@notename{หมายเหตุ:}
  \def\ku@sourcename{ที่มา:}
\else
  \def\ku@contentsname{TABLE OF CONTENTS}
  \def\ku@lotname{LIST OF TABLES}
  \def\ku@lofname{LIST OF FIGURES}
  \def\ku@abbrname{LIST OF ABBREVIATIONS}
  \def\ku@bibname{LITERATURE CITED}
  \def\ku@appname{APPENDIX}
  \def\ku@appsname{APPENDICES}
  \def\ku@subappname{Appendix}
  \def\ku@vitaename{CURRICULUM VITAE}
  \def\ku@ackname{ACKNOWLEDGEMENTS}
  \def\ku@pagename{Page}
  \def\ku@contname{(Continued)}
  \def\ku@tabname{Table}
  \def\ku@figname{Figure}
  \def\ku@apptabname{Appendix Table}
  \def\ku@appfigname{Appendix Figure}
  \def\ku@notename{Note:}
  \def\ku@sourcename{Source:}
\fi
\let\contentsname\ku@contentsname
\let\listtablename\ku@lotname
\let\listfigurename\ku@lofname
\let\bibname\ku@bibname
\let\appendixname\ku@appname
\let\tablename\ku@tabname
\let\figurename\ku@figname

% Thai alphabetic counter for appendices: ก ข ค ง จ ฉ ช ซ ฌ ญ ...
\def\ku@thaialph#1{\ifcase#1\or ก\or ข\or ค\or ง\or จ\or ฉ\or ช\or ซ\or ฌ\or
  ญ\or ฎ\or ฏ\or ฐ\or ฑ\or ฒ\or ณ\or ด\or ต\or ถ\or ท\or ธ\or น\or บ\or ป\or
  ผ\or ฝ\or พ\or ฟ\or ภ\or ม\else\@ctrerr\fi}
\newcommand*\thaialph[1]{\expandafter\ku@thaialph\csname c@#1\endcsname}
\def\ku@thaimonth#1{\ifcase#1\or มกราคม\or กุมภาพันธ์\or มีนาคม\or เมษายน\or
  พฤษภาคม\or มิถุนายน\or กรกฎาคม\or สิงหาคม\or กันยายน\or ตุลาคม\or
  พฤศจิกายน\or ธันวาคม\fi}

% ---------------------------------------------------------------------------
% Metadata
% ---------------------------------------------------------------------------
\newcommand*\thesistitle[2]{\def\ku@thtitle{#1}\def\ku@entitle{#2}}
\newcommand*\thaiauthor[3][]{\def\ku@thprefix{#1}\def\ku@thgiven{#2}\def\ku@thfamily{#3}}
\newcommand*\englishauthor[3][]{\def\ku@enprefix{#1}\def\ku@engiven{#2}\def\ku@enfamily{#3}}
\newcommand*\degree[2]{\def\ku@thdegree{#1}\def\ku@endegree{#2}}
\newcommand*\majorfield[2]{\def\ku@thfield{#1}\def\ku@enfield{#2}}
\newcommand*\department[2]{\def\ku@thdept{#1}\def\ku@endept{#2}}
\newcommand*\advisor[2]{\def\ku@thadvisor{#1}\def\ku@enadvisor{#2}}
\newcommand*\departmenthead[3][]{\def\ku@thhead{#2}\def\ku@enhead{#3}%
  \ifstrempty{#1}{}{\def\ku@thheadlabel{#1}}}
\newcommand*\dean[2]{\def\ku@thdean{#1}\def\ku@endean{#2}}
\newcommand*\thesisyear[2]{\def\ku@thyear{#1}\def\ku@enyear{#2}}
\newcommand*\ackdate[2]{\def\ku@thackdate{#1}\def\ku@enackdate{#2}}
% \kulogo[<English-cover emblem>]{<Thai-cover emblem>}
% \kuapprovallogo{<emblem for the approval form>}  (default: Thai-cover emblem)
% Missing files fall back to a placeholder circle.
\newcommand*\kulogo[2][]{\def\ku@logo{#2}\ifstrempty{#1}{\def\ku@logoen{#2}}{\def\ku@logoen{#1}}}
\newcommand*\kuapprovallogo[1]{\def\ku@approvallogo{#1}}
\newcommand*\totalpages[1]{\def\ku@totalpages{#1}}
\def\ku@coadvisors{}
\newcommand*\coadvisor[2]{\appto\ku@coadvisors{\ku@docoadvisor{#1}{#2}}}
\def\ku@thheadlabel{หัวหน้าภาควิชา}
\def\ku@enheadlabel{DEPARTMENT HEAD}
\newcommand*\departmentheadlabel[2]{\def\ku@thheadlabel{#1}\def\ku@enheadlabel{#2}}

\thesistitle{ชื่อวิทยานิพนธ์ภาษาไทย}{English Thesis Title}
\thaiauthor[นาย]{ชื่อ}{นามสกุล}
\englishauthor[Mr.]{Given}{Family}
\degree{วิทยาศาสตรมหาบัณฑิต (สาขา)}{Master of Science (Field)}
\majorfield{สาขาวิชา}{Major Field}
\department{ภาควิชา}{Department}
\advisor{อาจารย์ที่ปรึกษา}{Advisor}
\departmenthead{หัวหน้าภาควิชา}{Department Head}
\dean{คณบดีบัณฑิตวิทยาลัย}{Dean}
\thesisyear{2569}{2026}
\ackdate{เดือน พ.ศ.}{Month Year}

% Name with two spaces between given name and family name (as in the samples)
\def\ku@thname{\ku@thgiven\ku@twospaces\ku@thfamily}
\def\ku@enname{\ku@engiven\ku@twospaces\ku@enfamily}
\def\ku@thfullname{\ifdefempty\ku@thprefix{}{\ku@thprefix}\ku@thname}
\def\ku@enfullname{\ifdefempty\ku@enprefix{}{\ku@enprefix\ }\ku@enname}

% Total number of pages (last page number) for the abstract header
\AtEndDocument{\par\protected@write\@auxout{}{\gdef\string\ku@lastpageval{\arabic{page}}}}
\def\ku@pagecount{%
  \ifdefined\ku@totalpages\ku@totalpages
  \else\ifdefined\ku@lastpageval\ku@lastpageval\else ??\fi\fi}

% ---------------------------------------------------------------------------
% Page styles
% ---------------------------------------------------------------------------
\fancypagestyle{kuthesis}{%
  \fancyhf{}%
  \fancyhead[R]{\normalfont\normalsize\thepage}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}}
\fancypagestyle{plain}{\fancyhf{}\renewcommand\headrulewidth{0pt}%
  \fancyhead[R]{\normalfont\normalsize\thepage}}
\pagestyle{kuthesis}

\newif\ifku@mainmatter \ku@mainmatterfalse
\newif\ifku@firstbody  \ku@firstbodyfalse
\newif\ifku@inappendix \ku@inappendixfalse
\newif\ifku@hassubapp  \ku@hassubappfalse

\def\ku@frontpagenumbering{%
  \ifku@thai \def\thepage{(\arabic{page})}\else \def\thepage{\roman{page}}\fi}

\def\frontmatter{\clearpage\pagestyle{empty}\ku@mainmatterfalse}
\newcommand\ku@startpreliminary{%
  \ifnum\value{ku@prelimstarted}=0
    \clearpage\pagestyle{kuthesis}\setcounter{page}{1}\ku@frontpagenumbering
    \setcounter{ku@prelimstarted}{1}%
  \fi}
\newcounter{ku@prelimstarted}
\def\mainmatter{%
  \clearpage
  \pagestyle{kuthesis}%
  \pagenumbering{arabic}%
  \ku@mainmattertrue\ku@firstbodytrue}
\providecommand\backmatter{}

% ---------------------------------------------------------------------------
% Headings
%   \chapter        หัวข้อใหญ่   new page, centred, 18 pt bold, unnumbered
%   \section        หัวข้อรอง    centred, 16 pt bold, unnumbered
%   \subsection     หัวข้อข้าง    flush left, 16 pt bold, optional "1."
%   \subsubsection  หัวข้อระดับย่อหน้า  run-in at 0.5 in, not bold, optional "1.1"
%   \paragraph      next level, aligned with the text of \subsubsection
%   One blank line separates headings from text (= \parskip).
% ---------------------------------------------------------------------------
\def\ku@case#1{\ifku@thai#1\else\MakeUppercase{#1}\fi}
\setcounter{secnumdepth}{-10}
\setcounter{tocdepth}{1}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}
\counterwithout{footnote}{chapter}
\counterwithin*{subsection}{chapter}
\counterwithin*{subsection}{section}
\renewcommand\thesubsection{\arabic{subsection}}
\renewcommand\thesubsubsection{\thesubsection.\arabic{subsubsection}}
\renewcommand\theparagraph{\thesubsubsection.\arabic{paragraph}}

\newcommand\ku@titleblock{%
  \begingroup\centering\large\bfseries
  \ifku@thai
    \ku@thtitle\par\vspace{\ku@hhgap}\ku@entitle\par
  \else
    \MakeUppercase{\ku@entitle}\par
  \fi
  \endgroup\vspace{\ku@hhgap}}

% #1 = text for TOC (empty = none), #2 = heading text
\newcommand\ku@major[2]{%
  \clearpage
  \ifku@mainmatter\thispagestyle{empty}\else\thispagestyle{kuthesis}\fi
  \ifku@firstbody\ku@titleblock\global\ku@firstbodyfalse\fi
  \phantomsection
  \ifstrempty{#1}{}{\addcontentsline{toc}{chapter}{\ku@case{#1}}}%
  \markboth{#2}{}%
  \begingroup\centering\large\bfseries\ku@case{#2}\par\endgroup
  \nobreak\vspace{\ku@hbgap}\nobreak\@afterindenttrue\@afterheading}

\renewcommand\chapter{\@ifstar{\ku@chapterstar}{\ku@chapternostar}}
\newcommand\ku@chapternostar[2][]{%
  \stepcounter{chapter}%
  \ifstrempty{#1}{\ku@major{#2}{#2}}{\ku@major{#1}{#2}}}
\newcommand\ku@chapterstar[1]{\ku@major{}{#1}}

\renewcommand\section{\@ifstar{\ku@sectionstar}{\ku@sectionnostar}}
\newcommand\ku@sectionbody[1]{%
  \par\Needspace{4\baselineskip}%
  \begingroup\centering\normalsize\bfseries#1\par\endgroup
  \nobreak\@afterindenttrue\@afterheading}
\newcommand\ku@sectionnostar[2][]{%
  \stepcounter{section}\phantomsection
  \addcontentsline{toc}{section}{\ifstrempty{#1}{#2}{#1}}%
  \ku@sectionbody{#2}}
\newcommand\ku@sectionstar[1]{\ku@sectionbody{#1}}

\renewcommand\subsection{\@ifstar{\ku@subsection@}{\ku@subsection@}}
\newcommand\ku@subsection@[2][]{%
  \stepcounter{subsection}\phantomsection
  \addcontentsline{toc}{subsection}{\ifstrempty{#1}{#2}{#1}}%
  \par\Needspace{4\baselineskip}%
  \begingroup\noindent\normalsize\bfseries
  \ifku@numbered\thesubsection.\ku@twospaces\fi#2\par\endgroup
  \nobreak\@afterindenttrue\@afterheading}

\newdimen\ku@runinwd
\renewcommand\subsubsection{\@ifstar{\ku@subsubsection@}{\ku@subsubsection@}}
\newcommand\ku@subsubsection@[2][]{%
  \stepcounter{subsubsection}\phantomsection
  \addcontentsline{toc}{subsubsection}{\ifstrempty{#1}{#2}{#1}}%
  \par\Needspace{3\baselineskip}%
  \ifku@numbered
    \setbox\z@\hbox{\normalfont\thesubsubsection\ku@twospaces}%
    \global\ku@runinwd\wd\z@
    \indent\box\z@#2\ku@twospaces\ignorespaces
  \else
    \global\ku@runinwd\z@
    \indent#2\ku@twospaces\ignorespaces
  \fi}

\renewcommand\paragraph{\@ifstar{\ku@paragraph@}{\ku@paragraph@}}
\newcommand\ku@paragraph@[2][]{%
  \stepcounter{paragraph}%
  \par\Needspace{3\baselineskip}%
  \noindent\hspace*{\dimexpr\parindent+\ku@runinwd\relax}%
  \ifku@numbered\theparagraph\ku@twospaces\fi#2\ku@twospaces\ignorespaces}

% ---------------------------------------------------------------------------
% Floats, captions, equations
% ---------------------------------------------------------------------------
\DeclareCaptionLabelSeparator{kutwospaces}{\ku@twospaces}
\captionsetup{
  font=normalsize, labelfont=bf, labelsep=kutwospaces,
  format=hang, justification=justified, singlelinecheck=false,
  skip=\ku@bls}
\captionsetup[table]{position=top}
\captionsetup[figure]{position=bottom}
\setlength\textfloatsep{\ku@bls \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep{\ku@bls \@plus 4\p@ \@minus 2\p@}
\setlength\intextsep{\ku@bls \@plus 4\p@ \@minus 2\p@}
\renewcommand\topfraction{0.9}
\renewcommand\bottomfraction{0.8}
\renewcommand\textfraction{0.07}
\renewcommand\floatpagefraction{0.8}
\setlength\LTpre{0pt}\setlength\LTpost{0pt}
\setlength\LTcapwidth{\textwidth}
\setlength\abovetopsep{0pt}
\setlength\aboverulesep{2pt}\setlength\belowrulesep{2pt}

% "ตารางที่ 1 (ต่อ)" / "Table 1 (Continued)" for split tables (longtable \endhead)
\newcommand\tablecontinued{\textbf{\tablename~\thetable}\ \ku@contname}
\newcommand\figurecontinued{\textbf{\figurename~\thefigure}\ \ku@contname}
% Notes and sources below tables and figures
\newcommand\tablenote[1]{\par\vspace{0.5\ku@bls}%
  {\raggedright\noindent\ku@notename\ #1\par}}
\newcommand\tablesource[1]{\par\vspace{0.5\ku@bls}%
  {\raggedright\noindent\ku@sourcename\ #1\par}}
\let\figuresource\tablesource

\renewcommand\theequation{\arabic{equation}}

% Lists: no extra vertical space, labels at the paragraph indent
\setlist{nosep}
\setlist[enumerate,1]{label=\arabic*., labelindent=\parindent, leftmargin=*, align=left}
\setlist[enumerate,2]{label=\arabic{enumi}.\arabic*, leftmargin=*, align=left}
\setlist[enumerate,3]{label=\arabic{enumi}.\arabic{enumii}.\arabic*, leftmargin=*, align=left}
\setlist[enumerate,4]{label=\thaialph*., leftmargin=*, align=left}
\AddEnumerateCounter{\thaialph}{\ku@thaialph}{ฌ}
\setlist[itemize]{labelindent=\parindent, leftmargin=*}

% ---------------------------------------------------------------------------
% Table of contents, lists of tables/figures
%   Typeset as longtables so that continuation pages repeat the heading
%   ("สารบัญ (ต่อ)" / "TABLE OF CONTENTS (Continued)") and the "หน้า"/"Page"
%   column head, as in the manual's samples. No dot leaders.
% ---------------------------------------------------------------------------
\newtoks\ku@rows
\def\ku@addrow#1{\global\ku@rows\expandafter{\the\ku@rows#1}}
\newdimen\ku@pagecolwd \ku@pagecolwd=0.6in
\newdimen\ku@numcolwd
\newcounter{ku@savedtable}

% Read <jobname>.<ext> into \ku@rows, one \tabularnewline-terminated row
% per entry. Rows are typeset with the classic TOC technique: the page
% number hangs into a right-hand slot on the LAST line of the entry.
\def\ku@readlist#1{%
  \global\ku@rows{}%
  \begingroup
    \let\ku@pendinghead\relax
    \def\contentsline##1##2##3##4{%
      \ifcsname ku@cl@##1\endcsname\csname ku@cl@##1\endcsname{##2}{##3}\fi}%
    \let\addvspace\@gobble \let\vspace\@gobble
    \let\protect\relax
    \makeatletter\@input{\jobname.#1}%
  \endgroup}

% entry text with the page number at the right end of its last line
\newcommand\ku@entry[4][0.5in]{% [#1 hang], #2 left indent, #3 text, #4 page
  \leftskip#2\relax
  \rightskip\ku@pagecolwd plus 1fil\relax
  \parfillskip-\ku@pagecolwd\relax
  \hangindent#1\hangafter1
  \noindent#3\nobreak\hfill\nobreak\hbox to\ku@pagecolwd{\hss#4}\par}

% TOC rows: level 0 at the margin, level 1 indented 0.5 in
\def\ku@cl@chapter#1#2{\ku@addrow{\ku@entry{0pt}{#1}{#2}\tabularnewline}}
\def\ku@cl@section#1#2{\ku@addrow{\ku@entry{0.5in}{#1}{#2}\tabularnewline}}
\def\ku@cl@kuappendix#1#2{\ku@addrow{%
  \ku@entry{\ifku@thai0pt\else0.5in\fi}{#1}{#2}\tabularnewline}}

\newcommand\ku@majorlisthead[1]{%
  \ku@startpreliminary
  \clearpage\thispagestyle{kuthesis}%
  \phantomsection\addcontentsline{toc}{chapter}{#1}%
  \begingroup\centering\large\bfseries#1\par\endgroup\nobreak
  \vspace{\ku@listgap}\nobreak}

% longtable steps the table counter; keep captions numbered from 1
\newcommand\ku@begintable{\setcounter{ku@savedtable}{\value{table}}%
  \setlength\tabcolsep{0pt}\setlength\LTpre{\ku@bls}\setlength\LTpost{0pt}}
\newcommand\ku@endtable{\setcounter{table}{\value{ku@savedtable}}}

\renewcommand\tableofcontents{%
  \ku@majorlisthead{\ku@contentsname}%
  \ku@readlist{toc}%
  \begingroup\ku@begintable
  \begin{longtable}{@{}p{\textwidth}@{}}
    \hfill\ku@pagename\\[\ku@bls]
  \endfirsthead
    \centering\large\bfseries\ku@contentsname\ \ku@contname\\[\ku@bls]
    \hfill\ku@pagename\\[\ku@bls]
  \endhead
    \the\ku@rows
  \end{longtable}\ku@endtable\endgroup
  \@starttoc{toc}}
% keep LaTeX's file writing but suppress its own typesetting
\def\@starttoc#1{\begingroup\makeatletter
  \if@filesw\expandafter\newwrite\csname tf@#1\endcsname
    \immediate\openout\csname tf@#1\endcsname\jobname.#1\relax\fi
  \@nobreakfalse\endgroup}

% LOT/LOF rows: number centred under the column head (first line),
% caption text at the second column, page number at the end of the last line.
% A sub-head ("ตารางผนวกที่") is emitted only if appendix entries follow.
\def\ku@cl@table#1#2{\ku@listentry{#1}{#2}}
\def\ku@cl@figure#1#2{\ku@listentry{#1}{#2}}
\def\ku@cl@kulisthead#1#2{\def\ku@pendinghead{#1}}
\def\ku@listentry#1#2{%
  \ifx\ku@pendinghead\relax\else
    \expandafter\ku@addrow\expandafter{\expandafter
      \ku@listsubhead\expandafter{\ku@pendinghead}}%
    \let\ku@pendinghead\relax
  \fi
  \ku@splitnumber#1\ku@stop
  \expandafter\ku@listentry@\expandafter{\ku@tmpnum}{#2}}
\def\ku@splitnumber#1\ku@stop{\ku@splitnumber@#1\numberline{}{}\ku@stop}
\def\ku@splitnumber@#1\numberline#2#3#4\ku@stop{%
  \def\ku@tmpnum{#2}\def\ku@tmptext{#1#3}}
\def\ku@listentry@#1#2{%
  \expandafter\ku@listentry@@\expandafter{\ku@tmptext}{#1}{#2}}
\def\ku@listentry@@#1#2#3{%
  \ku@addrow{#2&\ku@entry[0pt]{0pt}{#1}{#3}\tabularnewline}}
\newcommand\ku@listsubhead[1]{%
  \multicolumn{2}{@{}l@{}}{}\tabularnewline
  \multicolumn{2}{@{}l@{}}{#1}\tabularnewline}

\newcommand\ku@makelist[3]{% #1 ext, #2 title, #3 column head
  \ku@majorlisthead{#2}%
  \ku@readlist{#1}%
  \setbox\z@\hbox{#3}%
  \ku@numcolwd=\wd\z@
  \advance\ku@numcolwd 0.15in
  \ifdim\ku@numcolwd<0.5in\ku@numcolwd=0.5in\fi
  \begingroup\ku@begintable
  \begin{longtable}{@{}>{\centering\arraybackslash}p{\ku@numcolwd}
                      p{\dimexpr\textwidth-\ku@numcolwd}@{}}
    \multicolumn{1}{@{}l}{#3} & \hfill\ku@pagename\\[\ku@bls]
  \endfirsthead
    \multicolumn{2}{@{}c@{}}{\large\bfseries#2\ \ku@contname}\\[\ku@bls]
    \multicolumn{1}{@{}l}{#3} & \hfill\ku@pagename\\[\ku@bls]
  \endhead
    \the\ku@rows
  \end{longtable}\ku@endtable\endgroup
  \@starttoc{#1}}

\renewcommand\listoftables{\ku@makelist{lot}{\ku@lotname}{\ku@tabname}}
\renewcommand\listoffigures{\ku@makelist{lof}{\ku@lofname}{\ku@figname}}

% ---------------------------------------------------------------------------
% List of symbols and abbreviations
%   \begin{abbreviations} \abbr{BA}{6-benzylaminopurine} ... \end{abbreviations}
% ---------------------------------------------------------------------------
\newenvironment{abbreviations}[1][1.1in]{%
  \ku@majorlisthead{\ku@abbrname}%
  \def\abbr##1##2{##1 & = & ##2\tabularnewline}%
  \ku@begintable
  \longtable{@{}>{\raggedright\arraybackslash}p{#1}
               >{\centering\arraybackslash}p{0.5in}
               >{\raggedright\arraybackslash}p{\dimexpr\textwidth-#1-0.5in}@{}}
  \endfirsthead
    \multicolumn{3}{@{}c@{}}{\large\bfseries\ku@abbrname\ \ku@contname}\\[\ku@bls]
  \endhead}
 {\endlongtable\ku@endtable}

% ---------------------------------------------------------------------------
% Front matter pages
% ---------------------------------------------------------------------------
\newcommand\ku@logobox[1][1.5in]{%
  \edef\ku@thislogo{\ifdefined\ku@logo\ifku@thai\ku@logo\else\ku@logoen\fi\fi}%
  \ifx\ku@thislogo\@empty\let\ku@thislogo\relax\fi
  \ifx\ku@thislogo\relax\ku@logoplaceholder{#1}\else
    \IfFileExists{\ku@thislogo}
      {\includegraphics[width=#1]{\ku@thislogo}}
      {\ku@logoplaceholder{#1}}%
  \fi}
\newcommand\ku@logoplaceholder[1]{%
  \setlength\unitlength{#1}%
  \begin{picture}(1,1)
    \color{gray}\put(0.5,0.5){\circle{1}}%
    \put(0.5,0.5){\makebox(0,0){\small\textcolor{gray}{\ifku@thai ตรามหาวิทยาลัย\else KU emblem\fi}}}%
  \end{picture}}

% Pages whose last line must sit exactly 1 in above the bottom edge
\def\ku@fullpage{\enlargethispage{\ku@spare}}

% Outer cover (ปกนอก) -- for reference / soft copy; the bound cover is
% printed in gold on a hard cover by the binder.
% Positions measured on the manual's samples (p.71-72):
%   logo (1.5 in) top 1 in from the top edge; "วิทยานิพนธ์"/"THESIS" top 0.5 in
%   below the logo; title top 1 in below the logo; name centred between
%   title and the bottom block, whose last baseline is 1 in from the bottom.
\newcommand\ku@vbox[1]{\nointerlineskip\hbox to\textwidth{\hss#1\hss}}
\newcommand\makecover{%
  \clearpage\thispagestyle{empty}\ku@fullpage
  \begingroup\setlength\parskip{0pt}\bfseries
  \vspace*{-0.5in}% \vspace* sits on the 1.5 in baseline -> 1 in
  \ku@vbox{\ku@logobox}%
  \setbox\z@\hbox{\fontsize{30.1}{36}\selectfont\ifku@thai วิทยานิพนธ์\else THESIS\fi}%
  \dimen@=\dimexpr0.5in-\ht\z@-\dp\z@\relax % title top = logo bottom + 1 in
  \nointerlineskip\vskip0.5in
  \ku@vbox{\box\z@}%
  \nointerlineskip\vskip\dimen@
  \nointerlineskip
  \vbox{\hsize\textwidth\centering
    \ifku@thai
      \large\ku@thtitle\par
      \vspace{\ku@hhgap}\vspace{\ku@blsL}%
      \normalsize\baselineskip13.8bp \MakeUppercase{\ku@entitle}\par
    \else
      \normalsize\baselineskip13.8bp \MakeUppercase{\ku@entitle}\par
    \fi}%
  \vfill
  \begingroup\centering
  \ifku@thai\large\ku@thfullname\else\normalsize\MakeUppercase{\ku@enname}\fi\par
  \endgroup
  \vfill
  \begingroup\centering
  \ifku@thai
    \large บัณฑิตวิทยาลัย\ku@twospaces มหาวิทยาลัยเกษตรศาสตร์\par
    พ.ศ.~\ku@thyear\par
  \else
    \normalsize\baselineskip13.8bp
    GRADUATE SCHOOL, KASETSART UNIVERSITY\par
    \ku@enyear\par
  \fi
  \endgroup
  \endgroup\clearpage}

% Inner title page (ปกใน)
\newcommand\maketitlepage{%
  \clearpage\thispagestyle{empty}\ku@fullpage
  \begingroup\centering
  \ifku@thai
    วิทยานิพนธ์\par
    เรื่อง\par
    \ku@thtitle\par
    \ku@entitle\par
    \vfill
    โดย\par
    \ku@thfullname\par
    \vfill
    เสนอ\par
    บัณฑิตวิทยาลัย\ku@twospaces มหาวิทยาลัยเกษตรศาสตร์\par
    \setlength\parskip{0pt}%
    เพื่อความสมบูรณ์แห่งปริญญา\ku@thdegree\par
    พ.ศ.~\ku@thyear\par
  \else
    {\large THESIS\par}\vspace{\dimexpr\ku@blsL-\parskip}%
    {\large\MakeUppercase{\ku@entitle}\par}
    \vfill
    \MakeUppercase{\ku@enname}\par
    \vfill
    \setlength\parskip{0pt}\fontsize{16.06}{13.8bp}\selectfont % single-spaced (sample p.80)
    A Thesis Submitted in Partial Fulfillment of\par
    the Requirements for the Degree of\par
    \ku@endegree\par
    Graduate School, Kasetsart University\par
    \ku@enyear\par
  \fi
  \endgroup\clearpage}
\renewcommand\maketitle{\maketitlepage}

% Approval form (ใบรับรองวิทยานิพนธ์). The Graduate School may require its
% own official form; this reproduces the layout of the manual's sample.
\newcommand\ku@sigline[2]{% #1 label (right of line), #2 name
  \par\noindent\makebox[\dimexpr\textwidth-1.9in][l]{\dotfill}\ \textbf{\small#1}\par
  \vspace{-\parskip}\noindent(\makebox[\dimexpr\textwidth-2.1in][c]{#2})\par}
\newcommand\makeapproval{%
  \clearpage\thispagestyle{empty}\ku@fullpage
  \begingroup\setlength\parskip{0pt}%
  % emblem in the top margin, as on the Graduate School's form (sample p.75)
  \ifdefined\ku@approvallogo\else\ifdefined\ku@logo\let\ku@approvallogo\ku@logo\fi\fi
  \ifdefined\ku@approvallogo
    \IfFileExists{\ku@approvallogo}{%
      \vspace*{-0.95in}%
      \ku@vbox{\includegraphics[width=0.85in]{\ku@approvallogo}}%
      \nointerlineskip\vskip0.1in}{}%
  \fi
  \def\ku@dotted##1##2{\begin{tabular}[t]{@{}c@{}}\makebox[##1][c]{##2}\\[-0.9\ku@bls]
    \makebox[##1]{\dotfill}\end{tabular}}%
  \ifku@thai
    {\centering\bfseries\Large ใบรับรองวิทยานิพนธ์\par
     \large บัณฑิตวิทยาลัย\ku@twospaces มหาวิทยาลัยเกษตรศาสตร์\par}
    \vspace{\ku@bls}%
    {\centering\ku@dotted{0.8\textwidth}{\ku@thdegree}\par
     \small\bfseries ปริญญา\par}
    \vspace{0.5\ku@bls}%
    \noindent\begin{tabular}{@{}c@{\hspace{0.1\textwidth}}c@{}}
      \ku@dotted{0.45\textwidth}{\ku@thfield} & \ku@dotted{0.45\textwidth}{\ku@thdept}\\
      \small\bfseries สาขา & \small\bfseries ภาควิชา
    \end{tabular}\par
    \vspace{\ku@bls}%
    \noindent\begin{tabular}{@{}p{1in}p{\dimexpr\textwidth-1in}@{}}
      \textbf{เรื่อง} & \ku@thtitle\\[0.5\ku@bls]
      & \ku@entitle\\[\ku@bls]
      \textbf{นามผู้วิจัย} & \ku@thfullname
    \end{tabular}\par
    \vspace{\ku@bls}%
    \noindent\textbf{ได้พิจารณาเห็นชอบโดย}\par
    \def\ku@sig##1##2{\par\vspace{0.6\ku@bls}\noindent
      \makebox[2.3in][r]{\textbf{##1}}\ \dotfill\par
      \noindent\hspace*{2.3in}\ (\makebox[\dimexpr\textwidth-2.6in][c]{##2})\par}%
    \ku@sig{อาจารย์ที่ปรึกษาวิทยานิพนธ์หลัก}{\ku@thadvisor}%
    \def\ku@docoadvisor##1##2{\ku@sig{อาจารย์ที่ปรึกษาวิทยานิพนธ์ร่วม}{##1}}%
    \ku@coadvisors
    \ku@sig{\ku@thheadlabel}{\ku@thhead}%
    \vspace{\ku@bls}%
    {\centering\bfseries บัณฑิตวิทยาลัย\ku@twospaces มหาวิทยาลัยเกษตรศาสตร์รับรองแล้ว\par}
    \vspace{\ku@bls}%
    {\centering\makebox[3.5in]{\dotfill}\par
     (\makebox[3.3in][c]{\ku@thdean})\par
     \textbf{คณบดีบัณฑิตวิทยาลัย}\par
     \vspace{0.6\ku@bls}%
     \textbf{วันที่}\ \makebox[0.6in]{\dotfill}\ \textbf{เดือน}\ \makebox[1.2in]{\dotfill}\
     \textbf{พ.ศ.}\ \makebox[0.6in]{\dotfill}\par}
  \else
    {\centering\bfseries THESIS APPROVAL\par
     GRADUATE SCHOOL, KASETSART UNIVERSITY\par}
    \vspace{\ku@bls}%
    {\centering\ku@dotted{0.8\textwidth}{\ku@endegree}\par
     \small\bfseries DEGREE\par}
    \vspace{0.5\ku@bls}%
    \noindent\begin{tabular}{@{}c@{\hspace{0.1\textwidth}}c@{}}
      \ku@dotted{0.45\textwidth}{\ku@enfield} & \ku@dotted{0.45\textwidth}{\ku@endept}\\
      \small\bfseries FIELD & \small\bfseries DEPARTMENT
    \end{tabular}\par
    \vspace{\ku@bls}%
    \noindent\begin{tabular}{@{}p{0.8in}p{\dimexpr\textwidth-0.8in}@{}}
      \small\textbf{TITLE:} & \ku@entitle\\[\ku@bls]
      \small\textbf{NAME:} & \ku@enfullname
    \end{tabular}\par
    \vspace{\ku@bls}%
    \noindent\small\textbf{THIS THESIS HAS BEEN ACCEPTED BY}\normalsize\par
    \def\ku@docoadvisor##1##2{\ku@sigline{THESIS CO-ADVISOR}{##2}}%
    \vspace{0.6\ku@bls}\ku@sigline{THESIS ADVISOR}{\ku@enadvisor}%
    \ku@coadvisors
    \vspace{0.3\ku@bls}\ku@sigline{\ku@enheadlabel}{\ku@enhead}%
    \vspace{\ku@bls}%
    \noindent\small\textbf{APPROVED BY THE GRADUATE SCHOOL ON}\ \normalsize\dotfill\par
    \vspace{1.5\ku@bls}%
    \ku@sigline{DEAN}{\ku@endean}%
  \fi
  \endgroup\clearpage}

% Abstracts. Header block indented 0.5 in, then two blank lines, then text;
% signature lines at the foot of the page. Thai abstract precedes English.
% Signature lines sit below the text area, as on the Graduate School's
% abstract form (sample p.82): labels' baseline 10.32 in from the top edge,
% the text area ending two lines earlier than on ordinary pages.
\newcommand\ku@abstractfoot[3]{%
  \par
  \AddToHookNext{shipout/foreground}{%
    \put(1.5in,-10.32in){\makebox[0pt][l]{\normalfont\normalsize
      \begin{tabular}[b]{@{}c@{\hspace{0.3in}}c@{\hspace{0.3in}}c@{}}
        \rule{1.6in}{0.4pt} & \rule{2.4in}{0.4pt} &
          \rule{0.3in}{0.4pt}\,/\,\rule{0.3in}{0.4pt}\,/\,\rule{0.3in}{0.4pt}\\[-6bp]
        #1 & #2 & #3
      \end{tabular}}}}}
\newcommand\ku@abstractpage{%
  \clearpage\thispagestyle{empty}%
  \ku@bls=21.6bp\normalsize\setlength\parskip{\ku@bls}% abstract form pitch (samples p.81-82)
  \enlargethispage{\dimexpr\ku@spare-2\ku@bls\relax}}
\newenvironment{thaiabstract}{%
  \ku@abstractpage
  \begingroup\leftskip0.5in\noindent
  \ku@thname\ku@twospaces\ku@thyear:\ \ku@thtitle\ku@twospaces
  ปริญญา\ku@thdegree\ \ สาขา\ku@thfield\ \ \ku@thdept\ku@twospaces
  อาจารย์ที่ปรึกษาวิทยานิพนธ์หลัก:\ \ku@thadvisor\ku@twospaces
  \ku@pagecount\ หน้า\par\endgroup
  \vspace{\ku@bls}}
 {\ku@abstractfoot{ลายมือชื่อนิสิต}{ลายมือชื่ออาจารย์ที่ปรึกษาวิทยานิพนธ์หลัก}{}%
  \clearpage}
\newenvironment{englishabstract}{%
  \ku@abstractpage
  \begingroup\leftskip0.5in\noindent
  \ku@engiven\ku@twospaces\ku@enfamily\ku@twospaces\ku@enyear:\ \ku@entitle.\ku@twospaces
  \ku@endegree,\ Major Field:\ \ku@enfield,\ \ku@endept.\ku@twospaces
  Thesis Advisor:\ \ku@enadvisor\ku@twospaces\ku@pagecount\ pages.\par\endgroup
  \vspace{\ku@bls}}
 {\ku@abstractfoot{Student's signature}{Thesis Advisor's signature}{}%
  \clearpage}
\renewenvironment{abstract}
  {\ifku@thai\thaiabstract\else\englishabstract\fi}
  {\ifku@thai\endthaiabstract\else\endenglishabstract\fi}

\newenvironment{acknowledgments}{%
  \clearpage\thispagestyle{empty}%
  \begingroup\centering\large\bfseries\ku@ackname\par\endgroup\nobreak
  \@afterindenttrue\@afterheading}
 {\par\nobreak\hfill
  \begin{tabular}{@{}c@{}}
    \ifku@thai\ku@thgiven\ \ku@thfamily\\\ku@thackdate
    \else\ku@engiven\ \ku@enfamily\\\ku@enackdate\fi
  \end{tabular}\par\clearpage}
\let\acknowledgements\acknowledgments
\let\endacknowledgements\endacknowledgments

% ---------------------------------------------------------------------------
% Appendices
%   \appendix                 -> divider page "ภาคผนวก"/"APPENDIX(ES)"
%   \appendixsection{title}   -> divider page "ภาคผนวก ก / title",
%                                content starts on the next page
%   Tables/figures: ตารางผนวกที่ ก1 / Appendix Table A1 (or 1, 2 ... without
%   sub-appendices).
% ---------------------------------------------------------------------------
\newcounter{kuappendix}
\def\thekuappendix{\ifku@thai\thaialph{kuappendix}\else\Alph{kuappendix}\fi}
\newcommand\ku@dividerpage[1]{%
  \clearpage\thispagestyle{empty}%
  \vspace*{\fill}%
  \begingroup\centering\bfseries#1\par\endgroup
  \vspace*{\fill}\clearpage}

\renewcommand\appendix{%
  \clearpage
  \ku@inappendixtrue
  \setcounter{table}{0}\setcounter{figure}{0}%
  \let\tablename\ku@apptabname
  \let\figurename\ku@appfigname
  \renewcommand\thetable{\arabic{table}}%
  \renewcommand\thefigure{\arabic{figure}}%
  \edef\ku@thisappname{\ifku@thai\ku@appname\else
    \ifku@hassubapp\ku@appsname\else\ku@appname\fi\fi}%
  \phantomsection\addcontentsline{toc}{chapter}{\ku@thisappname}%
  \ku@dividerpage{\large\ku@thisappname}%
  \addtocontents{lot}{\protect\contentsline{kulisthead}{\ku@apptabname}{}{}}%
  \addtocontents{lof}{\protect\contentsline{kulisthead}{\ku@appfigname}{}{}}%
  \ku@mainmattertrue}

\newcommand\appendixsection[1]{%
  \ifnum\value{kuappendix}=0 \immediate\write\@auxout{\global\noexpand\ku@hassubapptrue}\fi
  \stepcounter{kuappendix}%
  \setcounter{table}{0}\setcounter{figure}{0}%
  \renewcommand\thetable{\thekuappendix\arabic{table}}%
  \renewcommand\thefigure{\thekuappendix\arabic{figure}}%
  \clearpage\phantomsection
  \addcontentsline{toc}{kuappendix}{\ku@subappname\ \thekuappendix\ku@twospaces#1}%
  \ku@dividerpage{\ku@subappname\ \thekuappendix\par#1}%
  \stepcounter{chapter}}
\def\toclevel@kuappendix{1}
\def\toclevel@kulisthead{0}

% ---------------------------------------------------------------------------
% Curriculum vitae
%   \begin{vitae} \vitaeitem{ชื่อ}{...} ... \end{vitae}
% ---------------------------------------------------------------------------
\newenvironment{vitae}[1][\ifku@thai1.5in\else1.25in\fi]{%
  \ku@major{\ku@vitaename}{\ku@vitaename}%
  \setlength\parskip{0pt}%
  \def\ku@vlabelwd{#1}%
  \def\vitaeitem##1##2{\par\noindent\hangindent\dimexpr\ku@vlabelwd\ifku@thai\else+0.15in\fi\relax
    \hangafter1
    \setbox\z@\hbox{##1}%
    \ifdim\wd\z@<\ku@vlabelwd\makebox[\ku@vlabelwd][l]{##1}\else##1\enspace\fi
    \ifku@thai\else:\ \fi##2\par
    \ifku@thai\else\vspace{\dimexpr\ku@bls*4/10}\fi}%
  \vspace{\ku@bls}}
 {\par}

% ---------------------------------------------------------------------------
% Bibliography (biblatex, style=kuthesis)
% ---------------------------------------------------------------------------
\AtBeginDocument{%
  \@ifpackageloaded{biblatex}{%
    \defbibheading{bibliography}[\ku@bibname]{\chapter{#1}}%
    \setlength\bibhang{0.5in}%
    \setlength\bibitemsep{\ku@bls}%
    \setlength\bibparsep{0pt}%
  }{}}

% ---------------------------------------------------------------------------
% hyperref (bookmarks; links are not coloured, for printing)
% ---------------------------------------------------------------------------
\RequirePackage[unicode,hidelinks,bookmarksopen]{hyperref}
\AtBeginDocument{%
  \hypersetup{pdftitle={\ifku@thai\ku@thtitle\else\ku@entitle\fi},
              pdfauthor={\ifku@thai\ku@thgiven\ \ku@thfamily\else\ku@engiven\ \ku@enfamily\fi}}}

\endinput
