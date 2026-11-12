# AI-CONVERT — turn a student's draft into a kuthesis PDF

Instructions for an AI coding agent (Claude Code, Codex, Cursor, …) working in a clone of this
repository. A student hands you a draft written in Word (`.docx`), Google Docs (exported as
`.docx`) or plain Markdown/text, following `draft-template/thesis-draft-template.docx`.
Your job is to produce `thesis.pdf` formatted by `kuthesis.cls` according to the Kasetsart
University science-track thesis manual.

**You format; you do not write.** Never reword, shorten, translate, "improve" or reorder the
student's sentences, data, numbers or references. If something is missing or ambiguous, leave a
visible marker (`\kutodo{...}`, see below) and list it in your report. The student owns the text.

## 0. Inputs and workspace

```
work/<student>/            # create one folder per thesis; never write into the repo root
  draft.docx               # the student's draft (or draft.md / draft.txt)
  references.bib           # optional: from Zotero/Mendeley/EndNote
  figures/                 # optional: original image files
```

Requirements: XeLaTeX + biber (TeX Live ≥ 2023), pandoc ≥ 3, the TH Sarabun New font.
Copy `kuthesis.cls`, `kuthesis.bbx`, `kuthesis.cbx`, `latexmkrc` and `logo/` into the work folder
(or set `TEXINPUTS`).

## 1. Extract the draft

```sh
pandoc draft.docx -t markdown --wrap=none --extract-media=. -o draft.md
```

Word equations become `$...$` / `$$...$$` LaTeX math, Word tables become pipe/grid tables, images
are saved under `media/`. Read `draft.md` completely before writing anything.

## 2. Thesis information → class commands

The section **ข้อมูลวิทยานิพนธ์** holds `key: value` lines. Map them:

| Draft field | kuthesis |
|---|---|
| ภาษาของเล่ม ไทย / อังกฤษ | `\documentclass[thai]` / `[english]` |
| ระดับ ปริญญาโท / เอก | class option `master` / `doctor` |
| ชื่อเรื่อง (ไทย), (อังกฤษ) | `\thesistitle{ไทย}{English}` |
| ผู้เขียน (ไทย) `นางสาว ชื่อ นามสกุล` | `\thaiauthor[นางสาว]{ชื่อ}{นามสกุล}` |
| ผู้เขียน (อังกฤษ) `Miss Given Family` | `\englishauthor[Miss]{Given}{Family}` |
| ปริญญา | `\degree{...}{...}` |
| สาขาวิชา | `\majorfield{...}{...}` |
| ภาควิชาหรือโครงการ | `\department{...}{...}` |
| อาจารย์ที่ปรึกษาหลัก | `\advisor{...}{...}` |
| อาจารย์ที่ปรึกษาร่วม (each line) | `\coadvisor{...}{...}` (repeat) |
| หัวหน้าภาควิชา / ประธานสาขาวิชา | `\departmenthead{...}{...}`; if the draft says ประธานสาขาวิชา use `\departmentheadlabel{ประธานสาขาวิชา}{PROGRAM CHAIR}` |
| คณบดีบัณฑิตวิทยาลัย | `\dean{...}{...}` |
| ปีที่ส่งเล่ม | `\thesisyear{พ.ศ.}{ค.ศ.}` |
| เดือนปีท้ายกิตติกรรมประกาศ | `\ackdate{...}{...}` |

Always add `\kulogo[logo/ku-logo-en.png]{logo/ku-logo-th.png}` and
`\kuapprovallogo{logo/ku-logo-th-green.png}`. A field still in `[brackets]` is unfilled →
`\kutodo{}` + report. Ignore the section วิธีใช้ไฟล์นี้.

## 3. References → `references.bib`

* If the student supplied a `.bib`, use it; only fix syntax. Otherwise build one entry per
  paragraph under **เอกสารและสิ่งอ้างอิง**.
* Entry types: book `@book`; chapter in edited book `@incollection`; proceedings paper
  `@inproceedings`; journal article `@article`; thesis `@thesis` with `type = {mathesis}` or
  `{phdthesis}`; technical report `@report`; web page `@online` with `url` and `urldate`
  (`YYYY-MM-DD`, Christian era — the style converts to พ.ศ. for Thai entries); patent `@patent`.
* Names: English `Family, G. M.`; Thai `ชื่อ นามสกุล` (given name first, as written); several
  authors joined with ` and `; organisations in double braces `{{กรมวิชาการเกษตร}}`.
* Year exactly as printed (Thai documents in พ.ศ.). Same author and year twice → keep both; the
  style adds ก/ข or a/b.
* Keys: `familyYEAR` (English) or a romanised `givenYEAR` (Thai), unique, lowercase ASCII.
* Copy every field verbatim. **Never invent** a missing volume, page, publisher or DOI — write
  what is there and report the gap.

## 4. Body text → LaTeX

Use `example-th.tex` / `example-en.tex` as the skeleton (preamble, front matter order).

**Headings.** Heading 1 → `\chapter{}`; Heading 2 → `\section{}`; Heading 3 → `\subsection{}`;
Heading 4 → `\subsubsection{}`. Special Heading 1 sections:

| Heading 1 in the draft | Becomes |
|---|---|
| บทคัดย่อ (ภาษาไทย) | `\begin{thaiabstract} … \end{thaiabstract}` |
| Abstract | `\begin{englishabstract} … \end{englishabstract}` |
| กิตติกรรมประกาศ / Acknowledgements | `\begin{acknowledgments} … \end{acknowledgments}` |
| คำอธิบายสัญลักษณ์และคำย่อ | `\begin{abbreviations}` with `\abbr{COD}{chemical oxygen demand}` per `X = Y` line |
| คำนำ (first body chapter) | preceded by `\mainmatter` |
| เอกสารและสิ่งอ้างอิง / Literature Cited | `\printbibliography` (the list itself goes to the .bib) |
| ภาคผนวก ก ชื่อ / Appendix A Title | first one: `\appendix`; each: `\appendixsection{ชื่อ}` |
| ประวัติการศึกษาและการทำงาน / Curriculum Vitae | `\begin{vitae}` with `\vitaeitem{label}{value}` per line |

Front matter order: `\frontmatter \makecover \makeapproval \maketitlepage`, abstracts,
acknowledgments, `\tableofcontents \listoftables \listoffigures`, abbreviations, `\mainmatter`.
Omit `\listoftables`/`\listoffigures` when there are no tables/figures.

If side headings carry numbers (“1. การวิเคราะห์”), use class option `numbered` and drop the
typed numbers. Remove any manual heading numbers such as “บทที่ 1”.

**Citations** (match each to exactly one .bib key):

| Draft | LaTeX |
|---|---|
| `(สมศรี, 2552)` · `(Burr, 2009)` | `\parencite{key}` |
| `สมศรี (2552)` · `Burr et al. (2009)` | `\textcite{key}` |
| `(A, 2001; B, 2002)` · `(Smith, 2001, 2003)` | `\parencite{a,b}` |
| `(Burr, 2009: 3)` · `Burr (2009: 3-5)` | `\parencite[3]{key}` · `\textcite[3-5]{key}` |
| `ที่มา: Burr (2009)` under a table/figure | `\tablesource{\textcite{key}}` |

Thai citations use the given name (และคณะ = 3+ authors); English use the family name
(et al. = 3+). If a citation matches no reference, or two, keep the original text, add
`\kutodo{citation not found: ...}` and report it. A reference that is listed but never cited:
keep it with `\nocite{key}` just before `\printbibliography` and report it (the manual requires
the student to cite it or delete it).

**Figures.** An image followed by a line “ภาพที่ n …” / “Figure n …”:

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{media/image1.png} % never wider than \textwidth
  \caption{คำบรรยายภาพ (without the “ภาพที่ n” prefix)}
  \label{fig:n}
\end{figure}
```

**Tables.** A line “ตารางที่ n …” / “Table n …” followed by a table:
`\begin{table}[htbp] \caption{…} \label{tab:n} \centering \begin{tabular}{…} \toprule … \midrule
… \bottomrule \end{tabular}` then `\tablenote{…}` for หมายเหตุ and `\tablesource{…}` for ที่มา.
Numbers right- or centre-aligned, text left. No vertical rules (manual). A table longer than a
page → `longtable` with `\tablecontinued` in `\endhead`. Too wide → `\begin{landscape}`.

**Cross-references.** “ภาพที่ 1” → `ภาพที่~\ref{fig:1}`, “ตารางที่ 2” → `ตารางที่~\ref{tab:2}`,
“สมการที่ (1)” → `สมการที่~(\ref{eq:1})`. Labels follow the draft's own numbers so they match.
In appendices the class numbers tables/figures ก1, ก2 … automatically.

**Equations.** Display math → `\begin{equation} … \label{eq:n} \end{equation}`. Students often
type the number themselves (`… \quad\quad(1)` at the end of the formula) — delete it, the class
numbers equations. Inline math stays `$…$`. Units in text: keep as typed (e.g. `mg/L`, `m\textsuperscript{3}`).

**Text.** Keep every word. Italic → `\emph{}`, bold → `\textbf{}`, superscript →
`\textsuperscript{}`, subscript → `\textsubscript{}`. Escape `% & # _ $ { }` outside math.
Numbered lists → `enumerate`, bullets → `itemize`. Remove Word artefacts (empty paragraphs,
manual page breaks, tab-indents, “บทที่ …” prefixes, typed page numbers).

Missing items use the marker command (define it in the preamble):

```latex
\newcommand\kutodo[1]{\textcolor{red}{[TODO: #1]}}
```

## 5. Build

```sh
latexmk -xelatex thesis.tex
```

Fix every LaTeX error. Treat as errors too: undefined citations or references, `??` in the PDF,
missing images, overfull boxes wider than 5 pt (shrink the image/table, never the margins).

## 6. Check against the manual, then report

Check and **report** (do not silently change the student's content):

1. Every cited work is in the reference list and every listed work is cited (manual ch. 1, 1.4).
2. Each abstract fits on one page; acknowledgments ≤ 1 page; CV ≤ 1 page.
3. Each heading level used under a parent appears at least twice (manual ch. 4, การพิมพ์หัวข้อ 4).
4. Captions and table titles are in the thesis language (manual ch. 4).
5. All `\kutodo` markers.
6. Figures with text smaller than 14 pt Thai / 11 pt English (judge visually).

Finish with a short report to the student, in Thai for a Thai thesis:
what was converted, the list of TODOs and rule issues with page numbers, and the path of
`thesis.pdf`. Keep `thesis.tex`, `references.bib` and `media/` so the student (or the next AI run)
can rebuild after editing the draft.

## Re-running after the student edits the draft

Rebuild from the new draft, but reuse the existing `references.bib` keys so citations stay
stable. Mention what changed since the previous build.
