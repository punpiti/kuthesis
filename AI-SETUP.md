# AI-SETUP — install everything and create a thesis workspace

Instructions for an AI coding agent (Claude Code in a terminal or in VS Code, Codex, Cursor, …)
running on a student's own computer. The student has only the agent. Your job:

1. install what is missing (git, a small TeX distribution, pandoc, VS Code + extensions),
2. get the kuthesis repository and the TH Sarabun New font,
3. create the student's workspace with a Word draft ready to edit,
4. prove it works by building a PDF, then
5. tell the student, in Thai, what to do next.

The student may start you in an empty folder and say:

> อ่าน https://raw.githubusercontent.com/punpiti/kuthesis/main/AI-SETUP.md แล้วทำตาม

## Rules

* **Ask before installing.** First detect what is already present (step 1), then show the student
  one short list of what you will install and where, and wait for "ok". Prefer per-user installs
  that need no administrator password. If something needs admin rights, say so and why.
* Never remove or upgrade software the student already has unless they agree.
* Work in a terminal you can see the output of. After installing a tool, open a new shell (or
  refresh `PATH`) before using it.
* If a step fails twice, stop, explain the error in plain Thai and give the manual alternative.
* Everything the student writes lives in `kuthesis/work/<name>/`, which is git-ignored — never
  commit or upload it.

## 1. Detect

Find the OS and what exists. Run whichever of these apply and record the versions:

```sh
git --version
xelatex --version      # TeX present?
biber --version
latexmk --version
tlmgr --version        # TeX Live / TinyTeX (absent with MiKTeX)
pandoc --version       # need 2.19 or newer; 3.x preferred
code --version         # VS Code
```

Font check (only informative — the font can also live in a folder, see step 4):
Windows `Get-ChildItem "$env:WINDIR\Fonts","$env:LOCALAPPDATA\Microsoft\Windows\Fonts" -Filter "THSarabunNew*"`;
macOS/Linux `fc-list | grep -i "TH Sarabun New"`.

## 2. Install what is missing

| Need | Windows (PowerShell) | macOS | Linux (Debian/Ubuntu) |
|---|---|---|---|
| package manager | `winget` (built in on Windows 10/11) | Homebrew: see https://brew.sh | `apt` |
| git | `winget install -e --id Git.Git` | `xcode-select --install` or `brew install git` | `sudo apt install git` |
| pandoc | `winget install -e --id JohnMacFarlane.Pandoc` | `brew install pandoc` | `sudo apt install pandoc` (or the .deb from pandoc.org if older than 2.19) |
| VS Code (optional) | `winget install -e --id Microsoft.VisualStudioCode` | `brew install --cask visual-studio-code` | the .deb from code.visualstudio.com |

**TeX.** If a full TeX Live, MacTeX or MiKTeX already works (`xelatex`, `biber`, `latexmk` all run),
keep it and skip to the package list. Otherwise install **TinyTeX** (small, per-user, no admin):

* macOS / Linux: `curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh`
* Windows: download `https://yihui.org/tinytex/install-bin-windows.bat` and run it
  (PowerShell: `Invoke-WebRequest https://yihui.org/tinytex/install-bin-windows.bat -OutFile install-tinytex.bat; .\install-tinytex.bat`)

Then install the packages kuthesis needs (TeX Live / TinyTeX):

```sh
tlmgr update --self
tlmgr install xetex fontspec unicode-math biblatex biber latexmk \
  geometry fancyhdr needspace graphics xcolor tools booktabs caption enumitem \
  pdflscape pict2e refcount etoolbox iftex hyperref url logreq amsmath \
  l3packages unicode-data tex-gyre tex-gyre-math fira
```

(Windows PowerShell: put the list on one line.) With MiKTeX, packages install on first use;
make sure Perl is available for `latexmk` (`winget install -e --id StrawberryPerl.StrawberryPerl`).

**VS Code extensions** (if VS Code is used):
`code --install-extension james-yu.latex-workshop` and, if the student uses Claude Code in VS Code,
`code --install-extension anthropic.claude-code`.

## 3. Get kuthesis

In the folder the student chose (default: their Documents folder):

```sh
git clone https://github.com/punpiti/kuthesis.git
cd kuthesis
```

If it is already cloned, `git pull` instead.

## 4. TH Sarabun New

kuthesis uses the font if it is installed on the system. If it is not, put the four files
`THSarabunNew.ttf`, `THSarabunNew Bold.ttf`, `THSarabunNew Italic.ttf`,
`THSarabunNew BoldItalic.ttf` into `kuthesis/fonts/` — the class finds them there; no system
installation or admin rights are needed.

The font is one of the free Thai national fonts (SIPA). Download the official zip from the
f0nt.com release page (https://www.f0nt.com/release/th-sarabun-new/) or the SIPA/DEPA site, unzip,
and copy only the four `.ttf` files. If the download is blocked or the file names differ,
ask the student to download it in a browser and tell you where the zip is. Do not substitute
another font silently. `kuthesis/fonts/` is git-ignored.

## 5. Create the workspace

Ask the student for a short folder name (Latin letters, e.g. their first name or student ID).

```
kuthesis/work/<name>/
  draft.docx              ← copy of draft-template/thesis-draft-template.docx
  kuthesis.cls  kuthesis.bbx  kuthesis.cbx  latexmkrc   ← copied from the repo root
  logo/                    ← copied from the repo root
```

macOS/Linux:

```sh
mkdir -p work/<name>
cp draft-template/thesis-draft-template.docx work/<name>/draft.docx
cp kuthesis.cls kuthesis.bbx kuthesis.cbx latexmkrc work/<name>/
cp -r logo work/<name>/
```

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force work\<name> | Out-Null
Copy-Item draft-template\thesis-draft-template.docx work\<name>\draft.docx
Copy-Item kuthesis.cls,kuthesis.bbx,kuthesis.cbx,latexmkrc work\<name>\
Copy-Item -Recurse logo work\<name>\
```

If the student already has a draft (`.docx`), copy it to `work/<name>/draft.docx` instead of the
template (keep their original untouched).

## 6. Prove it works

Build the bundled example inside the workspace (so the student's folder is also tested):

```sh
cp example-th.tex references.bib work/<name>/
cd work/<name>
latexmk -xelatex example-th.tex
```

Success means: `example-th.pdf` exists, the log has no `!` errors, and the PDF uses the fonts
`THSarabunNew` and `TeXGyreTermes` (`pdffonts example-th.pdf`, or check visually: Thai text in
TH Sarabun New, English in a Times-like font, KU emblem on the cover). Then delete the example
files from `work/<name>/` (`example-th.*`, `references.bib`).

Common problems:

| Symptom | Fix |
|---|---|
| `Thai font ... not found` | step 4: the four `.ttf` files are missing from `kuthesis/fonts/` |
| `File 'xxx.sty' not found` | `tlmgr install <package>` (TinyTeX: `tlmgr search --global --file xxx.sty`) |
| `biber` fails / version mismatch | use biber from the same TeX distribution; `tlmgr install biber` |
| `latexmk` not found (MiKTeX) | install Strawberry Perl, then `miktex packages install latexmk` |
| PDF shows boxes instead of Thai | font step failed; rebuild after fixing step 4 |

## 7. Hand over (in Thai)

Tell the student:

1. Their draft is `kuthesis/work/<name>/draft.docx`. Open it in **Word** (or upload to Google
   Docs and export back to `.docx`), read the 8 rules on its first page, and write.
2. To make the thesis PDF at any time, open the agent in the `kuthesis` folder and say:
   > อ่าน AI-CONVERT.md แล้วแปลง work/<name>/draft.docx เป็น PDF ตามคู่มือวิทยานิพนธ์
3. The PDF appears as `work/<name>/thesis.pdf`. Red `[TODO: …]` marks are things they must fix in
   the Word draft; then ask the agent again.
4. In VS Code: *File → Open Folder → kuthesis*; accept the recommended extensions. Opening
   `work/<name>/thesis.tex` and saving rebuilds the PDF (LaTeX Workshop); the PDF opens in a tab.
5. Back up `work/<name>/` themselves (OneDrive/Google Drive) — it is intentionally not in git.

Finish with a one-paragraph summary of what you installed, where, and the versions.

---

<sub>kuthesis — Copyright (C) 2026 Punpiti Piamsa-nga. Licensed under the MIT License (see LICENSE).</sub>
