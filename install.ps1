# kuthesis installer for Windows (PowerShell 5.1 or 7)
#
#   irm https://raw.githubusercontent.com/punpiti/kuthesis/main/install.ps1 | iex
#
# Installs (only what is missing, per-user, no administrator rights for TeX):
#   TinyTeX + the LaTeX packages kuthesis needs, the TH Sarabun New font (into the
#   workspace, checksum-verified), the kuthesis files, Git for Windows (needed by
#   Claude Code) and Claude Code (an AI CLI).
# Creates the thesis workspace (default: Documents\thesis) and builds a test PDF.
# Run it again at any time to update kuthesis; your thesis files are never overwritten.
#
# Options (set before running, e.g.  $env:KUTHESIS_NO_AI = '1'):
#   KUTHESIS_DIR      workspace folder (default: Documents\thesis)
#   KUTHESIS_NO_AI    '1' = do not install an AI CLI
#   KUTHESIS_SRC      local copy of the repository (testing)

#
# Copyright (C) 2026 Punpiti Piamsa-nga
# Licensed under the MIT License (see LICENSE).
# https://github.com/punpiti/kuthesis

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # much faster Invoke-WebRequest
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Repo = 'punpiti/kuthesis'
$Branch = 'main'
$WS = if ($env:KUTHESIS_DIR) { $env:KUTHESIS_DIR } else {
  Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'thesis' }
$FontUrl = 'https://www.f0nt.com/download/sipafonts/THSarabunNew.zip'
$FontSha256 = '7A3DB732E475B0B8ADB10ADF4058E7D8161ECEF157F56F9711C229C73BEDC592'
$TexPackages = @('xetex','fontspec','unicode-math','biblatex','biber','latexmk','geometry',
  'fancyhdr','needspace','graphics','xcolor','tools','booktabs','caption','enumitem',
  'pdflscape','pict2e','refcount','etoolbox','iftex','hyperref','url','logreq','amsmath',
  'l3packages','unicode-data','tex-gyre','tex-gyre-math','fira')

New-Item -ItemType Directory -Force $WS | Out-Null
$Log = Join-Path $WS 'install.log'
Set-Content -Path $Log -Value "kuthesis install $(Get-Date)" -Encoding UTF8
$Tmp = Join-Path ([IO.Path]::GetTempPath()) ("kuthesis-" + [guid]::NewGuid())
New-Item -ItemType Directory -Force $Tmp | Out-Null

function Step($m) { Write-Host "* $m" }
function Ok($m)   { Write-Host "  OK  $m" -ForegroundColor Green }
function Fail($m) {
  Write-Host "  FAILED  $m" -ForegroundColor Red
  Write-Host "  Details: $Log"
  Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
  throw "kuthesis installer stopped: $m"
}
function Have($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Log-Run([scriptblock]$b) {
  # native tools write progress to stderr; in PowerShell 5.1 that would be a
  # terminating error under 'Stop', so relax it while they run
  $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
  try { & $b *>> $Log } finally { $ErrorActionPreference = $old }
}
function Refresh-Path {
  $m = [Environment]::GetEnvironmentVariable('Path','Machine')
  $u = [Environment]::GetEnvironmentVariable('Path','User')
  $env:Path = "$m;$u;$env:Path"
}
function Use-TinyTeX {
  $root = Join-Path $env:APPDATA 'TinyTeX\bin'
  if (Test-Path $root) {
    foreach ($d in Get-ChildItem $root -Directory) {
      if (Test-Path (Join-Path $d.FullName 'tlmgr.bat')) { $env:Path = "$($d.FullName);$env:Path"; return $true }
    }
  }
  return $false
}

Write-Host ''
Write-Host 'kuthesis - Kasetsart University thesis tools'
Write-Host "workspace: $WS"
Write-Host ''

# ---------------------------------------------------------------------------
# 1. TeX (TinyTeX if nothing usable is present)
# ---------------------------------------------------------------------------
Step 'TeX'
[void](Use-TinyTeX)
$texOk = (Have 'xelatex') -and (Have 'biber') -and (Have 'latexmk')
if (-not $texOk -and -not (Use-TinyTeX)) {
  Write-Host '  Installing TinyTeX (first time takes several minutes)...'
  $bat = Join-Path $Tmp 'install-tinytex.bat'
  Invoke-WebRequest 'https://yihui.org/tinytex/install-bin-windows.bat' -OutFile $bat -UseBasicParsing
  Log-Run { cmd /c "`"$bat`"" }
  Refresh-Path
  if (-not (Use-TinyTeX)) { Fail 'TinyTeX installation failed' }
}
$tlmgr = Get-Command 'tlmgr' -ErrorAction SilentlyContinue
if ($tlmgr -and $tlmgr.Source -like "$env:APPDATA*") {
  Write-Host '  Installing LaTeX packages...'
  Log-Run { tlmgr update --self }
  Log-Run { tlmgr install @TexPackages }
} elseif (Have 'miktex') {
  Log-Run { miktex packages install latexmk biber }
}
if (-not ((Have 'xelatex') -and (Have 'biber') -and (Have 'latexmk'))) { Fail 'xelatex / biber / latexmk not found' }
Ok ((& xelatex --version 2>$null | Select-Object -First 1))

# ---------------------------------------------------------------------------
# 2. kuthesis files
# ---------------------------------------------------------------------------
Step 'kuthesis'
if ($env:KUTHESIS_SRC) {
  Copy-Item -Recurse $env:KUTHESIS_SRC (Join-Path $Tmp 'repo')
} else {
  $zip = Join-Path $Tmp 'repo.zip'
  Invoke-WebRequest "https://codeload.github.com/$Repo/zip/refs/heads/$Branch" -OutFile $zip -UseBasicParsing
  Expand-Archive $zip -DestinationPath $Tmp -Force
  Rename-Item (Join-Path $Tmp "kuthesis-$Branch") 'repo'
}
$R = Join-Path $Tmp 'repo'
$K = Join-Path $WS 'kuthesis'
New-Item -ItemType Directory -Force (Join-Path $K 'fonts') | Out-Null
foreach ($f in 'kuthesis.cls','kuthesis.bbx','kuthesis.cbx','latexmkrc','AI-CONVERT.md','README.md',
               'LICENSE','example-th.tex','example-en.tex','references.bib') {
  Copy-Item (Join-Path $R $f) $K -Force
}
Remove-Item -Recurse -Force (Join-Path $K 'logo') -ErrorAction SilentlyContinue
Copy-Item -Recurse (Join-Path $R 'logo') (Join-Path $K 'logo')
Copy-Item (Join-Path $R 'draft-template\thesis.md') (Join-Path $K 'thesis-template.md') -Force
Ok $K

# ---------------------------------------------------------------------------
# 3. TH Sarabun New (into the workspace; no system installation)
# ---------------------------------------------------------------------------
Step 'Font TH Sarabun New'
$fonts = Join-Path $K 'fonts'
if ((Test-Path (Join-Path $fonts 'THSarabunNew.ttf')) -and (Test-Path (Join-Path $fonts 'THSarabunNew Bold.ttf'))) {
  Ok 'already present'
} else {
  $fz = Join-Path $Tmp 'font.zip'
  Invoke-WebRequest $FontUrl -OutFile $fz -UseBasicParsing
  if ((Get-FileHash $fz -Algorithm SHA256).Hash -ne $FontSha256) { Fail 'font file checksum mismatch' }
  Expand-Archive $fz -DestinationPath (Join-Path $Tmp 'font') -Force
  Get-ChildItem (Join-Path $Tmp 'font') -Recurse -Filter 'THSarabunNew*.ttf' |
    Where-Object { $_.FullName -notmatch '__MACOSX' } | Copy-Item -Destination $fonts -Force
  if (-not (Test-Path (Join-Path $fonts 'THSarabunNew.ttf'))) { Fail 'could not unpack the font' }
  Ok $fonts
}

# ---------------------------------------------------------------------------
# 4. Workspace (never overwrite the student's files)
# ---------------------------------------------------------------------------
Step 'workspace'
foreach ($d in 'figures','output','latex') { New-Item -ItemType Directory -Force (Join-Path $WS $d) | Out-Null }
if (-not (Test-Path (Join-Path $WS 'thesis.md'))) { Copy-Item (Join-Path $K 'thesis-template.md') (Join-Path $WS 'thesis.md') }
Copy-Item (Join-Path $R 'workspace\AGENTS.md'),(Join-Path $R 'workspace\CLAUDE.md') $WS -Force
$L = Join-Path $WS 'latex'
if (-not (Test-Path (Join-Path $L 'thesis.tex')))     { Copy-Item (Join-Path $K 'example-th.tex') (Join-Path $L 'thesis.tex') }
if (-not (Test-Path (Join-Path $L 'references.bib'))) { Copy-Item (Join-Path $K 'references.bib') $L }
foreach ($f in 'kuthesis.cls','kuthesis.bbx','kuthesis.cbx','latexmkrc') { Copy-Item (Join-Path $K $f) $L -Force }
Remove-Item -Recurse -Force (Join-Path $L 'logo') -ErrorAction SilentlyContinue
Copy-Item -Recurse (Join-Path $K 'logo') (Join-Path $L 'logo')
Ok $WS

# ---------------------------------------------------------------------------
# 5. AI CLI (Claude Code needs Git for Windows)
# ---------------------------------------------------------------------------
Step 'AI CLI'
$ai = @('claude','codex','gemini') | Where-Object { Have $_ }
if ($ai) {
  Ok "already installed ($($ai -join ', '))"
} elseif ($env:KUTHESIS_NO_AI -eq '1') {
  Ok 'skipped (KUTHESIS_NO_AI=1)'
} else {
  if (-not (Have 'git')) {
    if (Have 'winget') {
      Write-Host '  Installing Git for Windows...'
      Log-Run { winget install -e --id Git.Git --silent --accept-package-agreements --accept-source-agreements }
      Refresh-Path
    } else {
      Write-Host '  Git for Windows is required by Claude Code: https://git-scm.com/download/win'
    }
  }
  Write-Host '  Installing Claude Code...'
  $cc = Invoke-RestMethod 'https://claude.ai/install.ps1'
  Log-Run ([scriptblock]::Create($cc))
  Refresh-Path
  $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
  if (Have 'claude') { Ok 'claude' } else { Write-Host '  Claude Code may need a new terminal window to appear.' }
}

# ---------------------------------------------------------------------------
# 6. Test build
# ---------------------------------------------------------------------------
Step 'Test PDF'
$T = Join-Path $WS '.selftest'
Remove-Item -Recurse -Force $T -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $T | Out-Null
foreach ($f in 'kuthesis.cls','kuthesis.bbx','kuthesis.cbx','latexmkrc','example-th.tex','references.bib') {
  Copy-Item (Join-Path $K $f) $T
}
Copy-Item -Recurse (Join-Path $K 'logo') (Join-Path $T 'logo')
Push-Location $T
try { Log-Run { latexmk -xelatex -interaction=nonstopmode example-th.tex } } catch {}
Pop-Location
if ((Test-Path (Join-Path $T 'example-th.pdf')) -and ((Get-Item (Join-Path $T 'example-th.pdf')).Length -gt 0)) {
  Remove-Item -Recurse -Force $T
  Ok 'success'
} else {
  Fail "test PDF was not created (see $T\example-th.log)"
}
Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue

Write-Host ''
Write-Host 'Done.' -ForegroundColor Green
Write-Host ''
Write-Host 'Way 1 - write Markdown, let the AI build the thesis'
Write-Host "  1) Edit   $WS\thesis.md   (images go in $WS\figures\)"
Write-Host "  2) Open a NEW terminal:   cd `"$WS`"; claude"
Write-Host '  3) Type to the AI:   สร้าง PDF   (or: make the PDF)'
Write-Host "     -> $WS\output\thesis.pdf"
Write-Host ''
Write-Host 'Way 2 - write LaTeX yourself'
Write-Host "  Edit $WS\latex\thesis.tex, then:   cd `"$WS\latex`"; latexmk thesis"
Write-Host ''
Write-Host 'Run the install command again at any time to update kuthesis (your files are kept).'
Write-Host 'Guide (Thai): https://punpiti.github.io/kuthesis/'
