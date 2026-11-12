# kuthesis — LaTeX class for Kasetsart University theses (science track)

คลาส LaTeX สำหรับวิทยานิพนธ์ **สายวิทยาศาสตร์ มหาวิทยาลัยเกษตรศาสตร์** จัดรูปแบบตาม
*คู่มือการพิมพ์วิทยานิพนธ์ สายวิทยาศาสตร์* (บัณฑิตวิทยาลัย มก., พ.ศ. 2553)
โดยใช้ฟอนต์ฟรี: **TH Sarabun New** (ไทย) + **TeX Gyre Termes** (อังกฤษ — ฟอนต์ฟรีที่ขนาดและความกว้างเท่า Times New Roman ตามที่คู่มือกำหนด) + **TeX Gyre Termes Math** (คณิตศาสตร์)

> **ไม่ใช่เอกสารทางการของมหาวิทยาลัย** — โปรดตรวจกับข้อกำหนดล่าสุดของบัณฑิตวิทยาลัย
> และแบบฟอร์มทางการ (ใบรับรองวิทยานิพนธ์, บทคัดย่อ) ก่อนส่งเล่มจริง

## ไฟล์

| ไฟล์ | หน้าที่ |
|---|---|
| `kuthesis.cls` | คลาสหลัก: ขนาดหน้ากระดาษ ฟอนต์ หัวข้อ สารบัญ ปก ใบรับรอง บทคัดย่อ ภาคผนวก ประวัติ |
| `kuthesis.bbx`, `kuthesis.cbx` | สไตล์ biblatex ระบบชื่อ–ปี ตามบทที่ 3 ของคู่มือ |
| `example-th.tex` | ตัวอย่างเล่มภาษาไทย |
| `example-en.tex` | ตัวอย่างเล่มภาษาอังกฤษ |
| `references.bib` | ตัวอย่างรายการอ้างอิง (นำมาจากตัวอย่างในคู่มือ) |
| `logo/` | ตรามหาวิทยาลัย (ไทย, อังกฤษ, สีเขียวสำหรับใบรับรอง) |

## ฟอนต์: ใช้ฟอนต์ฟรีที่ถูกกฎหมายแทนฟอนต์ลิขสิทธิ์

ฟอนต์ที่คู่มือของบัณฑิตวิทยาลัยกำหนด — **AngsanaUPC, BrowalliaUPC, CordiaUPC, DilleniaUPC, EucrosiaUPC,
FreesiaUPC** (ไทย) และ **Times New Roman** (อังกฤษ) — เป็น **ฟอนต์ที่มีลิขสิทธิ์** ของบริษัทผู้ผลิต
ใช้ได้ภายใต้สัญญาอนุญาตที่มากับ Windows / Microsoft Office เท่านั้น นำไปแจกจ่ายหรือฝังใช้นอกเงื่อนไขนั้นไม่ได้
และไม่มีให้ใช้บน Linux หรือระบบที่ไม่ได้ซื้อสิทธิ์

คลาสนี้จึงใช้ **ฟอนต์ฟรีที่ใช้และแจกจ่ายได้ถูกกฎหมาย** แทน โดยเลือกให้หน้าตาและขนาดใกล้ฟอนต์ที่คู่มือกำหนดที่สุด

| ใช้แทน | ฟอนต์ในคลาส | สัญญาอนุญาต |
|---|---|---|
| ฟอนต์ไทยตระกูล UPC | **TH Sarabun New** | ฟอนต์แห่งชาติ (SIPA) ใช้ได้ฟรี |
| Times New Roman | **TeX Gyre Termes** — ขนาดและความกว้างตัวอักษรเท่า Times ทุกตัว | GUST Font License (ฟรี) |
| สมการ | **TeX Gyre Termes Math** — ชุดเดียวกับ Termes | GUST Font License (ฟรี) |
| โค้ด / ตัวพิมพ์ดีด | **Fira Mono** | SIL Open Font License 1.1 (ฟรี) |

ขนาดตัวอักษรยังตรงตามคู่มือ: ไทย 16/18 พอยท์ อังกฤษ 12/14 พอยท์

## สิ่งที่ต้องมี

- TeX Live 2023 ขึ้นไป (หรือ MiKTeX) — ใช้ **XeLaTeX** + **biber**
- ฟอนต์ **TH Sarabun New** ติดตั้งในเครื่อง (ฟอนต์แห่งชาติ ดาวน์โหลดฟรี)
- TeX Gyre Termes, TeX Gyre Termes Math, Fira Mono มากับ TeX Live แล้ว

```sh
latexmk -xelatex example-th      # หรือ
xelatex example-th && biber example-th && xelatex example-th && xelatex example-th
```

## การใช้งานย่อ

```latex
\documentclass[thai]{kuthesis}            % หรือ [english]
\usepackage[style=kuthesis]{biblatex}
\addbibresource{references.bib}

\thesistitle{ชื่อเรื่องภาษาไทย}{English Title}
\thaiauthor[นางสาว]{ชื่อ}{นามสกุล}
\englishauthor[Miss]{Given}{Family}
\degree{วิทยาศาสตรมหาบัณฑิต (เทคโนโลยีชีวภาพเกษตร)}{Master of Science (Agricultural Biotechnology)}
\majorfield{...}{...}   \department{...}{...}
\advisor{...}{...}      \coadvisor{...}{...}   % \coadvisor ซ้ำได้หลายคน
\departmenthead{...}{...}  \dean{...}{...}
\thesisyear{2569}{2026}    \ackdate{สิงหาคม 2569}{August 2026}
\kulogo[logo/ku-logo-en.png]{logo/ku-logo-th.png}   % ตราบนปกนอก [เล่มอังกฤษ]{เล่มไทย}
\kuapprovallogo{logo/ku-logo-th-green.png}          % ตราบนใบรับรอง

\begin{document}
\frontmatter
\makecover  \makeapproval  \maketitlepage
\begin{thaiabstract} ... \end{thaiabstract}
\begin{englishabstract} ... \end{englishabstract}
\begin{acknowledgments} ... \end{acknowledgments}
\tableofcontents  \listoftables  \listoffigures
\begin{abbreviations} \abbr{COD}{chemical oxygen demand} \end{abbreviations}

\mainmatter
\chapter{คำนำ}            % หัวข้อใหญ่  — หน้าแรกของเนื้อหาพิมพ์ชื่อเรื่องให้อัตโนมัติ
\section{...}             % หัวข้อรอง
\subsection{...}          % หัวข้อข้าง
\subsubsection{...}       % หัวข้อระดับย่อหน้า (run-in)
\paragraph{...}           % ระดับถัดไป จัดแนวตรงกับข้อความของระดับก่อนหน้า
...
\printbibliography        % "เอกสารและสิ่งอ้างอิง" / "LITERATURE CITED"
\appendix                 % หน้า "ภาคผนวก"
\appendixsection{ชื่อ}     % หน้า "ภาคผนวก ก ..." ; ตาราง/ภาพเป็น ตารางผนวกที่ ก1
\begin{vitae} \vitaeitem{ชื่อ}{...} \end{vitae}
\end{document}
```

ตารางและภาพ: ใช้ `\caption` ตามปกติ (ชื่อตารางอยู่บน ชื่อภาพอยู่ล่าง) และ
`\tablenote{...}`, `\tablesource{...}` สำหรับ “หมายเหตุ” / “ที่มา”
ตารางยาวใช้ `longtable` โดยใส่ `\tablecontinued` ใน `\endhead` เพื่อพิมพ์ “ตารางที่ 1 (ต่อ)”
ตารางแนวนอนใช้ `\begin{landscape}` (เลขหน้ายังคงอยู่มุมบนขวาของหน้าแนวตั้ง)

### ตัวเลือกของคลาส

| ตัวเลือก | ความหมาย |
|---|---|
| `thai` / `english` | ภาษาของเล่ม (ค่าเริ่มต้น `thai`) |
| `numbered` | ใส่เลขกำกับหัวข้อข้าง `1.` และระดับย่อหน้า `1.1`, `1.1.1` |
| `guides` | วาดเส้นสีแดงตามระยะวัดของคู่มือ เพื่อตรวจระยะ (ปิดก่อนส่งเล่ม) |
| `latin=termes` / `latin=inter` / `latin=sarabun` | ฟอนต์ตัวอักษรละติน: Termes (ค่าเริ่มต้น, แทน Times New Roman), Inter, หรือ TH Sarabun New |
| `math=termes` / `fira` / `lete` / `newcm` / `stix` / `none` | ฟอนต์คณิตศาสตร์ (ค่าเริ่มต้น `termes`) |
| `thaifont=...` | เปลี่ยนฟอนต์ไทย (ค่าเริ่มต้น `TH Sarabun New`) |

## การอ้างอิง (biblatex `style=kuthesis`)

| คำสั่ง | ผล |
|---|---|
| `\textcite{key}` | สมศรี (2552) · Prathuangwong (2009) |
| `\parencite{key}` | (สมศรี, 2552) · (Prathuangwong and Burr, 2009) |
| `\parencite[2-5]{key}` | (อัญชลี และคณะ, 2550: 2-5) · (Burr, 2009: 3) |
| `\parencite{a,b}` | (Smith, 2001, 2003; Jones, 2002) |

- เอกสารภาษาไทยตรวจจับอัตโนมัติจากอักษรไทยในชื่อผู้แต่ง/ชื่อเรื่อง (หรือใส่ `langid = {thai}`)
- เอกสารไทยเรียงก่อน เรียงตาม **ชื่อตัว** แล้วนามสกุล; อ้างอิงในเนื้อความด้วยชื่อตัว;
  ผู้แต่ง 3 คนขึ้นไปเป็น “และคณะ” / “et al.”; ปีซ้ำใช้ ก ข / a b
- ใส่ปีตามที่ปรากฏบนเอกสาร (พ.ศ. สำหรับเอกสารไทย); วันที่สืบค้น (`urldate`) ใส่เป็น ค.ศ.
  ระบบแปลงเป็น พ.ศ. ให้ในรายการภาษาไทย
- ชื่อผู้แต่งไทยเขียนตามปกติ `author = {พัชราภรณ์ เนียมมณี and ...}`;
  ชื่อหน่วยงานใส่วงเล็บปีกกาซ้อน `{{กองอนุรักษ์สัตว์ป่า กรมป่าไม้}}`
- วิทยานิพนธ์: `@thesis` กับ `type = {mathesis}` / `{phdthesis}` → “วิทยานิพนธ์ปริญญาโท” / “M.S. Thesis”

## ระยะหน้ากระดาษ (แบบเครื่องพิมพ์ดีด)

คู่มือวัดระยะแบบโบราณ คือวัดจาก **ขอบกระดาษถึงฐานตัวอักษร (baseline)** ไม่ใช่ถึงขอบกล่องข้อความ
คลาสนี้จึงตั้งค่าให้

| รายการ | ข้อกำหนด | การตั้งค่า |
|---|---|---|
| ขอบบน | ขอบกระดาษ → ฐานบรรทัดแรก 1.5 นิ้ว | กล่องข้อความเริ่มที่ 1.5 นิ้ว − `\topskip` |
| ขอบล่าง | ฐานบรรทัดสุดท้าย → ขอบกระดาษ ≥ 1 นิ้ว | ความสูงเป็นจำนวนบรรทัดเต็ม (ไทย 31 บรรทัด) |
| ซ้าย / ขวา | 1.5 / 1 นิ้ว | |
| เลขหน้า | มุมขวาบน ฐานตัวเลขห่างขอบบน 1 นิ้ว ชิดขอบขวา 1 นิ้ว | `headsep` = 0.5 นิ้ว − `\topskip` |
| ระยะบรรทัด | ไทย 16 pt; อังกฤษ 1.5 เท่า | วัดจากตัวอย่างในคู่มือ: ไทย 21.6 pt, อังกฤษ 20.7 pt |
| ย่อหน้า | เยื้อง 0.5 นิ้ว, เว้น 1 บรรทัดระหว่างย่อหน้าและรอบหัวข้อ | `\parindent` 0.5in, `\parskip` = 1 บรรทัด |

ขนาดอักษรในคลาสเรียกตาม “พอยท์ไทย” ของคู่มือ (เนื้อหา 16, หัวข้อใหญ่ 18, ในตารางไม่ต่ำกว่า 14)
ตัวอังกฤษ (Termes) ได้ขนาด **12 pt** ในเนื้อหาและ **14 pt** ในหัวข้อใหญ่ของเล่มอังกฤษ ตรงตามคู่มือ (Times New Roman 12/14)
และความสูงตัว x เท่ากับ TH Sarabun New 16 pt — ตรงกับที่คู่มือให้ “ขนาดเทียบได้กับอักษรไทย 16 พอยท์”

ตรวจระยะด้วยตัวเลือก `guides`

### การตรวจเทียบกับตัวอย่างในภาคผนวกของคู่มือ

สร้างหน้าตัวอย่างจากภาคผนวก (ปกนอก ปกใน บทคัดย่อ สารบัญ หน้าคำนำ เอกสารอ้างอิง ประวัติ)
ด้วยเนื้อหาเดียวกัน แล้ววัดตำแหน่ง baseline ทุกบรรทัดเทียบกัน (หน่วย bp = พอยท์ของ Word):

| รายการ | ตัวอย่างในคู่มือ | kuthesis |
|---|---|---|
| ระยะบรรทัดเนื้อหา ไทย / อังกฤษ | 21.6 / 20.7 | 21.6 / 20.7 |
| บรรทัดในหัวข้อ 18 พอยท์ ไทย / อังกฤษ | 25.0 / 16.1 | 25.0 / 16.1 |
| หัวข้อ → หัวข้อ (ชื่อเรื่อง → คำนำ) | 49.3–49.9 / 48.5 | 49.6 / 48.5 |
| หัวข้อใหญ่ → เนื้อหา | 44.8 / 46.4 | 44.8 / 46.4 |
| ชื่อสารบัญ → “หน้า” ไทย / อังกฤษ | 44.6 / 42.9 | 44.6 / 42.9 |
| บทคัดย่อ: บรรทัดสุดท้าย / ช่องลายมือชื่อ | 9.87 / 10.32 นิ้ว | 9.90 / 10.32 นิ้ว |
| ปกในอังกฤษ: THESIS → ชื่อเรื่อง, บรรทัดล่าง | 0.446 / 0.192 นิ้ว | 0.447 / 0.192 นิ้ว |

ข้อสังเกต: ตัวอย่างภาษาอังกฤษวาง baseline บรรทัดแรกที่ 1.49 นิ้ว และเลขหน้าที่ 1.00 นิ้ว ตรงตามข้อความในคู่มือ
แต่ตัวอย่างภาษาไทยบางหน้าวางต่ำกว่า (1.55–1.82 นิ้ว) เพราะ Word วัด 1.5 นิ้วถึง “ขอบบนของบรรทัด”
ของฟอนต์ Angsana ซึ่งสูงมาก คลาสนี้ยึดตาม **ข้อความในคู่มือ** (วัดถึงฐานตัวอักษร) ทั้งสองภาษา

## ข้อที่ควรทราบ

- **ฟอนต์อังกฤษ**: คู่มือกำหนด Times New Roman สำหรับเล่มอังกฤษ คลาสใช้ TeX Gyre Termes ซึ่งเป็นฟอนต์ฟรีที่ขนาดและความกว้าง
  ตัวอักษรเท่า Times ทุกตัว (วัดเทียบกับตัวอย่างในคู่มือแล้วตำแหน่งตรงกันระดับ 0.01 นิ้ว)
  ส่วนตัวอังกฤษในเล่มไทย คู่มือข้อ 4 ให้ใช้ “แบบอักษรเดียวกับอักษรไทย” — ถ้าต้องการตามนั้นเคร่งครัดใช้ `latin=sarabun`
- **ตรามหาวิทยาลัย** ในโฟลเดอร์ `logo/` แกะจากภาพในคู่มือ (ความละเอียดต้นฉบับประมาณ 150 dpi
  ขยายและทำความสะอาดเป็นภาพขาว–ดำ/เขียว) หากได้ไฟล์ตราความละเอียดสูงจากมหาวิทยาลัยให้ใช้แทน;
  ถ้าไม่มีไฟล์ คลาสจะวาดวงกลมแทนโดยไม่ error · ตราเป็นเครื่องหมายของมหาวิทยาลัย ใช้เพื่อจัดทำวิทยานิพนธ์เท่านั้น
- **ใบรับรองวิทยานิพนธ์และบทคัดย่อ** จัดตามตัวอย่างในคู่มือ บัณฑิตวิทยาลัยอาจกำหนดให้ใช้แบบฟอร์มทางการ
- ปกนอกจริงเป็นปกแข็งพิมพ์ทอง (เอก: ดำ, โท: เขียวเข้ม) จัดทำโดยโรงพิมพ์ — `\makecover` มีไว้เป็นต้นแบบ/ฉบับ PDF
- ยังไม่รองรับ: สันปก, การแทนชื่อผู้แต่งซ้ำด้วยเส้นขีดในรายการอ้างอิง

## License

LaTeX Project Public License 1.3c or later (see `LICENSE`).

---

## English summary

Unofficial XeLaTeX class + biblatex style for Kasetsart University science-track theses,
following the Graduate School's 2010 (B.E. 2553) formatting manual. Thai text is set in
TH Sarabun New with ICU dictionary line breaking; Latin text in TeX Gyre Termes (a free,
metric-compatible Times New Roman, the font the manual names) at exactly 12/14 pt, and
math in TeX Gyre Termes Math.
The fonts named by the manual (AngsanaUPC and the other UPC fonts, Times New Roman) are
proprietary; this class uses only free, legally redistributable fonts in their place. Margins are measured to the baseline as the manual
specifies (first baseline 1.5 in from the top, last baseline ≥ 1 in from the bottom,
page number baseline 1 in from the top). The biblatex style implements the manual's
name–year system, with Thai references listed first and cited by given name.
