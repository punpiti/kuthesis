# Thesis workspace (kuthesis)

This folder is a Kasetsart University thesis workspace created by the kuthesis installer.

- `thesis.md` — the student's thesis, written in Markdown. **The student owns every word.**
- `figures/` — images used in `thesis.md`; `references.bib` (optional) — references from Zotero/Mendeley.
- `kuthesis/` — the LaTeX class, emblems, fonts and instructions. Do not edit.
- `output/` — generated files (`thesis.tex`, `references.bib` if built from the text, `thesis.pdf`).
- `latex/` — a separate starter for students who prefer writing LaTeX by hand. Leave it alone unless asked.

When the student asks for the PDF (e.g. "สร้าง PDF", "make the PDF", "build"), follow
`kuthesis/AI-CONVERT.md` in **Markdown workspace mode**: input `thesis.md`, output in `output/`.
Format only — never reword, shorten, translate or reorder the student's text. Report problems
(missing data, citations without a reference, rule violations) in Thai, with page numbers, and
mark them in the PDF with red `[TODO: …]`.

If tools are missing (`xelatex`, `biber`, `latexmk` not found, or the font is missing), tell the
student to re-run the installer command from https://punpiti.github.io/kuthesis/ .

<!-- kuthesis -- Copyright (C) 2026 Punpiti Piamsa-nga. Licensed under the LaTeX Project Public License 1.3c or later (see LICENSE). -->
