# CM-FDI: Cleantech Manufacturing FDI

An open, project-level database of cross-border investment in solar, wind, battery and
electric-vehicle manufacturing, built by the [Net Zero Industrial Policy
Lab](https://netzeropolicylab.com) at Johns Hopkins University.

**Explorer:** https://cmfdi.netzeropolicylab.com
**Data:** [`data/cm-fdi-projects.csv`](data/cm-fdi-projects.csv) ·
[dictionary](data/DATA_DICTIONARY.md)

## What is in it

926 projects announced between 1997 and 2026, across 384 parent firms investing into 65
destination economies from 28 home economies. 213 are joint ventures. Total disclosed capital is
US$579B. One project predates 2001; the explorer's time axis starts at 2001 and charts it there.

| Technology | Projects | Disclosed capital |
|---|---:|---:|
| Battery | 265 | $228.6B |
| EV | 231 | $208.6B |
| Solar | 245 | $73.8B |
| Wind | 185 | $67.7B |

A project qualifies when the investor is headquartered outside the destination economy. Each
record carries its own sources, field by field, so a reader can check one number without accepting
the whole row.

## Before quoting a figure

**815 of 926 projects report a capital value.** The other 111 are announced with the amount
undisclosed and read as 0. Summing the column understates announced capital by an unknown amount,
and any average must be taken over the 815 rather than all 926.

**853 of 926 projects are manufacturing.** The rest are R&D, design and logistics. The working
paper's regressions use the manufacturing subset; the explorer counts every activity. These are
different universes, and each figure in the explorer states which one it is on.

## How to cite

```
Bandara, P. and the Net Zero Industrial Policy Lab. Cleantech Manufacturing FDI Dataset,
edition 2026.09. Johns Hopkins University. https://cmfdi.netzeropolicylab.com
```

Machine-readable metadata is in [`CITATION.cff`](CITATION.cff).

## Licence

The dataset is released under [CC BY 4.0](LICENSE): reuse and redistribution are permitted with
attribution. Praveena Bandara is the data author. The explorer's code is in this repository under
the same terms.

## Contributing a missing project

Spotted a project that is not here? Use the **See Something, Say Something** form in the explorer.
It checks your link against the dataset first and, where the project is genuinely new, opens a
pre-filled issue at
[`lct-fdi-submissions`](https://github.com/bandarapraveena/lct-fdi-submissions) for review.

## Repository layout

```
index.html            landing page
explorer.html         the interactive explorer, generated (see below)
vendor/               pinned d3, topojson, Chart.js, map geometry, fonts
data/                 the release CSV, the workbook, and the data dictionary
docs/                 working paper and slides
```

## How the explorer is built

`explorer.html` is **generated**, never hand-edited. It is produced from the working workbook by
`build_clean_fdi_explorer.py` in the private `LCT-FDI` repository, which reads the pristine
template `Clean_FDI_Explorer_base.html` and injects the current data, the derived prose and the
export layer on every run. Editing the generated file directly means the next build silently
reverts the change.

Every figure that appears in prose on the page is recomputed from the workbook at build time, and
a validator fails the build if a published number and the data disagree. That check exists because
the page previously said wind manufacturing drew $12B beside a data constant that said $67.7B, and
nothing in the build could notice.
