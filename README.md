# CM-FDI: Cleantech Manufacturing FDI

An open, project-level database of cross-border investment in solar, wind, battery and
electric-vehicle manufacturing, built by the [Net Zero Industrial Policy
Lab](https://netzeropolicylab.com) at Johns Hopkins University.

**Explorer:** https://cmfdi.netzeropolicylab.com
**Data:** [`data/cm-fdi-projects.csv`](data/cm-fdi-projects.csv) ·
[dictionary](data/DATA_DICTIONARY.md)
**Paper:** [working paper](docs/cm-fdi-working-paper.pdf) ·
[methodological appendix](docs/cm-fdi-methodological-appendix.pdf)

## What is in it

914 projects announced between 1997 and 2026, across 381 parent firms investing into 65
destination economies from 28 home economies. 206 are joint ventures. Total disclosed capital is
US$446B. One project predates 2001; the explorer's time axis starts at 2001 and charts it there.

| Technology | Projects | Disclosed capital |
|---|---:|---:|
| Battery | 268 | $218.1B |
| EV | 231 | $157.7B |
| Solar | 242 | $58.1B |
| Wind | 173 | $12.2B |

A project qualifies when the investor is headquartered outside the destination economy. Each
record carries its own sources, field by field, so a reader can check one number without accepting
the whole row.

## Before quoting a figure

**704 of 914 projects report a capital value.** The other 210 are announced with the amount
undisclosed and read as 0. Summing the column understates announced capital by an unknown amount,
and any average must be taken over the 704 rather than all 914.

**845 of 914 projects are manufacturing.** The rest are R&D, design and logistics.

**The paper was written on an earlier release, and works from 888 of the 926 projects there.**
Its sample is the projects announced between 2000 and 2025, with cancelled, paused and closed ones
left out, across every activity. A data audit completed on 30 September 2026 revised the workbook,
and on this release the same rule selects 871 of the 914, so Table MA1 of the appendix does not
reproduce from `data/cm-fdi-projects.csv`. The release it does reproduce from, to the dollar, is in
this repository's history at commit `df14666`. The explorer counts all 914, and each figure in it
states which universe it is on.

## How to cite

```
Bandara, P. and the Net Zero Industrial Policy Lab. Cleantech Manufacturing FDI Dataset,
edition 2026.09.30. Johns Hopkins University. https://cmfdi.netzeropolicylab.com
```

Machine-readable metadata is in [`CITATION.cff`](CITATION.cff).

For the paper itself:

```
Bandara, P., Ratan, I., Sahay, T., Gallagher, K., Xue, X., Larsen, M. and Allan, B. (2026).
Measuring Green Capital Flows: A new database of cleantech manufacturing investment,
determinants, and impacts. Net Zero Industrial Policy Lab, Johns Hopkins University.
```

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
docs/                 the working paper and its methodological appendix
```

## How the explorer is built

`explorer.html` is **generated**, never hand-edited. It is produced from the working workbook by
`build_clean_fdi_explorer.py` in the private `LCT-FDI` repository, which reads the pristine
template `Clean_FDI_Explorer_base.html` and injects the current data, the derived prose and the
export layer on every run. Editing the generated file directly means the next build silently
reverts the change.

Every figure that appears in prose on the page is recomputed from the workbook at build time, and
a validator fails the build if a published number and the data disagree.
