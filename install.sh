#!/usr/bin/env bash
# kuthesis installer for macOS and Linux
#
#   curl -fsSL https://raw.githubusercontent.com/punpiti/kuthesis/main/install.sh | bash
#
# Installs (only what is missing, all per-user, no admin needed on Linux):
#   TinyTeX + the LaTeX packages kuthesis needs, the TH Sarabun New font (into the
#   workspace, checksum-verified), the kuthesis files, and Claude Code (an AI CLI).
# Creates the thesis workspace (default ~/thesis) and builds a test PDF.
# Run it again at any time to update kuthesis; your thesis files are never overwritten.
#
# Options (environment variables):
#   KUTHESIS_DIR=~/somewhere   workspace folder            (default: ~/thesis)
#   KUTHESIS_NO_AI=1           do not install an AI CLI
#   KUTHESIS_SRC=/path/repo    use a local copy of the repository (testing)
#   KUTHESIS_FORCE_TINYTEX=1   install TinyTeX even if another TeX exists (testing)

#
# Copyright (C) 2026 Punpiti Piamsa-nga
# Licensed under the LaTeX Project Public License 1.3c or later (see LICENSE).
# https://github.com/punpiti/kuthesis

set -euo pipefail

REPO="punpiti/kuthesis"
BRANCH="main"
WS="${KUTHESIS_DIR:-$HOME/thesis}"
FONT_URL="https://www.f0nt.com/download/sipafonts/THSarabunNew.zip"
FONT_SHA256="7a3db732e475b0b8adb10adf4058e7d8161ecef157f56f9711c229c73bedc592"
TEX_PACKAGES="xetex fontspec unicode-math biblatex biber latexmk geometry fancyhdr
  needspace graphics xcolor tools booktabs caption enumitem pdflscape pict2e refcount
  etoolbox iftex hyperref url logreq amsmath l3packages unicode-data tex-gyre
  tex-gyre-math fira"

mkdir -p "$WS"
LOG="$WS/install.log"
: >"$LOG"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

say()  { printf '%s\n' "$*"; }
step() { printf '• %s\n' "$*"; }
ok()   { printf '  ✓ %s\n' "$*"; }
fail() { printf '  ✗ %s\n    ดูรายละเอียดใน %s\n' "$*" "$LOG" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
log()  { "$@" >>"$LOG" 2>&1; }

have curl || fail "ต้องมีคำสั่ง curl"
have tar  || fail "ต้องมีคำสั่ง tar"

say ""
say "kuthesis — ติดตั้งเครื่องมือทำวิทยานิพนธ์ มหาวิทยาลัยเกษตรศาสตร์"
say "workspace: $WS"
say ""

# --------------------------------------------------------------------------
# 1. TeX (TinyTeX if nothing usable is present)
# --------------------------------------------------------------------------
tinytex_bin() {
  local d
  for d in "$HOME/Library/TinyTeX/bin/"* "$HOME/.TinyTeX/bin/"*; do
    [ -x "$d/tlmgr" ] && { printf '%s\n' "$d"; return 0; }
  done
  return 1
}
use_tinytex_path() {
  local d
  if d="$(tinytex_bin)"; then
    export PATH="$d:$PATH"
    # make it permanent for new terminals (idempotent)
    local rc line="export PATH=\"$d:\$PATH\"  # kuthesis: TinyTeX"
    [ "$(uname)" = Darwin ] && touch "$HOME/.zshrc"
    for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
      [ -f "$rc" ] || continue
      grep -qs "kuthesis: TinyTeX" "$rc" || printf '\n%s\n' "$line" >>"$rc"
    done
  fi
}
tex_ok() { have xelatex && have biber && have latexmk; }

step "TeX"
use_tinytex_path
if [ "${KUTHESIS_FORCE_TINYTEX:-0}" = 1 ] || ! tex_ok; then
  if ! tinytex_bin >/dev/null; then
    say "  กำลังติดตั้ง TinyTeX (ครั้งแรกใช้เวลาหลายนาที)…"
    curl -fsSL https://yihui.org/tinytex/install-bin-unix.sh | log sh \
      || fail "ติดตั้ง TinyTeX ไม่สำเร็จ"
    use_tinytex_path
  fi
fi
if tlmgr_path="$(command -v tlmgr 2>/dev/null)" && [ "${tlmgr_path#"$HOME"}" != "$tlmgr_path" ]; then
  # user-owned TeX Live (TinyTeX): install/refresh the packages kuthesis needs
  say "  กำลังติดตั้งแพ็กเกจ LaTeX…"
  log tlmgr update --self || true
  # shellcheck disable=SC2086
  log tlmgr install $TEX_PACKAGES || fail "ติดตั้งแพ็กเกจ LaTeX ไม่สำเร็จ"
else
  # system TeX (e.g. apt, MacTeX): check instead of installing
  missing=""
  for f in fontspec.sty unicode-math.sty biblatex.sty needspace.sty pict2e.sty \
           texgyretermes-regular.otf texgyretermes-math.otf FiraMono-Regular.otf; do
    kpsewhich "$f" >/dev/null 2>&1 || missing="$missing $f"
  done
  if [ -n "$missing" ]; then
    say "  TeX ที่มีอยู่ขาดไฟล์:$missing"
    say "  Debian/Ubuntu: sudo apt install texlive-xetex texlive-latex-extra texlive-bibtex-extra biber latexmk texlive-fonts-extra"
    say "  หรือรันใหม่ด้วย KUTHESIS_FORCE_TINYTEX=1 เพื่อใช้ TinyTeX แทน"
    fail "แพ็กเกจ LaTeX ไม่ครบ"
  fi
fi
tex_ok || fail "ไม่พบ xelatex / biber / latexmk"
ok "$(xelatex --version 2>/dev/null | head -1)"

# --------------------------------------------------------------------------
# 2. kuthesis files
# --------------------------------------------------------------------------
step "kuthesis"
if [ -n "${KUTHESIS_SRC:-}" ]; then
  cp -R "$KUTHESIS_SRC" "$TMP/repo"
else
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" \
    | tar xz -C "$TMP" || fail "ดาวน์โหลด kuthesis ไม่สำเร็จ"
  mv "$TMP/kuthesis-$BRANCH" "$TMP/repo"
fi
K="$WS/kuthesis"
mkdir -p "$K/fonts"
for f in kuthesis.cls kuthesis.bbx kuthesis.cbx latexmkrc AI-CONVERT.md README.md LICENSE \
         example-th.tex example-en.tex references.bib; do
  cp "$TMP/repo/$f" "$K/"
done
rm -rf "$K/logo"; cp -R "$TMP/repo/logo" "$K/logo"
cp "$TMP/repo/draft-template/thesis.md" "$K/thesis-template.md"
ok "$K"

# --------------------------------------------------------------------------
# 3. TH Sarabun New (into the workspace; no system installation)
# --------------------------------------------------------------------------
step "ฟอนต์ TH Sarabun New"
if [ -f "$K/fonts/THSarabunNew.ttf" ] && [ -f "$K/fonts/THSarabunNew Bold.ttf" ]; then
  ok "มีอยู่แล้ว"
else
  curl -fsSL -o "$TMP/font.zip" "$FONT_URL" || fail "ดาวน์โหลดฟอนต์ไม่สำเร็จ"
  if have sha256sum; then sum="$(sha256sum "$TMP/font.zip" | cut -d' ' -f1)"
  else sum="$(shasum -a 256 "$TMP/font.zip" | cut -d' ' -f1)"; fi
  [ "$sum" = "$FONT_SHA256" ] || fail "ไฟล์ฟอนต์ไม่ตรงกับ checksum ที่กำหนด"
  mkdir -p "$TMP/font"
  if have unzip; then log unzip -q -o "$TMP/font.zip" -d "$TMP/font"
  elif have bsdtar; then log bsdtar -xf "$TMP/font.zip" -C "$TMP/font"
  elif have python3; then log python3 -m zipfile -e "$TMP/font.zip" "$TMP/font"
  else fail "ต้องมี unzip หรือ python3 เพื่อแตกไฟล์ฟอนต์"; fi
  find "$TMP/font" -name 'THSarabunNew*.ttf' ! -path '*__MACOSX*' -exec cp {} "$K/fonts/" \;
  [ -f "$K/fonts/THSarabunNew.ttf" ] || fail "แตกไฟล์ฟอนต์ไม่สำเร็จ"
  ok "$K/fonts"
fi

# --------------------------------------------------------------------------
# 4. Workspace (never overwrite the student's files)
# --------------------------------------------------------------------------
step "workspace"
mkdir -p "$WS/figures" "$WS/output" "$WS/latex"
[ -f "$WS/thesis.md" ] || cp "$K/thesis-template.md" "$WS/thesis.md"
cp "$TMP/repo/workspace/AGENTS.md" "$TMP/repo/workspace/CLAUDE.md" "$WS/"
# LaTeX starter for students who write LaTeX themselves
[ -f "$WS/latex/thesis.tex" ]     || cp "$K/example-th.tex" "$WS/latex/thesis.tex"
[ -f "$WS/latex/references.bib" ] || cp "$K/references.bib" "$WS/latex/references.bib"
cp "$K/kuthesis.cls" "$K/kuthesis.bbx" "$K/kuthesis.cbx" "$K/latexmkrc" "$WS/latex/"
rm -rf "$WS/latex/logo"; cp -R "$K/logo" "$WS/latex/logo"
ok "$WS"

# --------------------------------------------------------------------------
# 5. AI CLI
# --------------------------------------------------------------------------
step "AI CLI"
if have claude || have codex || have gemini; then
  ok "มีอยู่แล้ว ($(for c in claude codex gemini; do have $c && printf '%s ' $c; done))"
elif [ "${KUTHESIS_NO_AI:-0}" = 1 ]; then
  ok "ข้าม (KUTHESIS_NO_AI=1)"
else
  say "  กำลังติดตั้ง Claude Code…"
  curl -fsSL https://claude.ai/install.sh | log bash || fail "ติดตั้ง Claude Code ไม่สำเร็จ"
  export PATH="$HOME/.local/bin:$PATH"
  ok "claude"
fi

# --------------------------------------------------------------------------
# 6. Test build
# --------------------------------------------------------------------------
step "ทดสอบสร้าง PDF"
T="$WS/.selftest"
rm -rf "$T"; mkdir -p "$T"
cp "$K/kuthesis.cls" "$K/kuthesis.bbx" "$K/kuthesis.cbx" "$K/latexmkrc" \
   "$K/example-th.tex" "$K/references.bib" "$T/"
cp -R "$K/logo" "$T/logo"
( cd "$T" && log latexmk -xelatex -interaction=nonstopmode example-th.tex ) || true
if [ -s "$T/example-th.pdf" ]; then
  rm -rf "$T"
  ok "สำเร็จ"
else
  fail "สร้าง PDF ทดสอบไม่สำเร็จ (ดู $T/example-th.log)"
fi

say ""
say "เสร็จแล้ว 🎓"
say ""
say "ทางที่ 1 — เขียน Markdown แล้วให้ AI จัดเล่ม"
say "  1) เปิดแก้ไฟล์  $WS/thesis.md   (รูปภาพใส่ใน $WS/figures/)"
say "  2) เปิด terminal ใหม่ แล้วพิมพ์:   cd \"$WS\" && claude"
say "  3) พิมพ์ใน AI:   สร้าง PDF        → ได้ $WS/output/thesis.pdf"
say ""
say "ทางที่ 2 — เขียน LaTeX เอง"
say "  แก้ $WS/latex/thesis.tex แล้วรัน:   cd \"$WS/latex\" && latexmk thesis"
say ""
say "รันคำสั่งติดตั้งซ้ำได้ทุกเมื่อเพื่ออัปเดต kuthesis (ไฟล์ที่เขียนไว้จะไม่ถูกแตะ)"
