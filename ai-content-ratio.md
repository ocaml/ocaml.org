# Share of AI-Assisted Content in Tutorials and Tool Pages

This note measures how much of the OCaml.org tutorials and tool pages was
written with AI assistance, both by page and by line of Markdown. It was
computed on `main` at commit `947b830d` (2026-10-04).

## Result

Excluding the MCP server guide, AI-assisted content accounts for **7.8% of
pages** and **2.2% of Markdown lines** across tutorials and tool pages.

| Section | AI pages (fractional) | % of pages | AI lines | % of lines |
| --- | --- | --- | --- | --- |
| Tutorials | 3.61 / 61 | 5.9% | 489 / 26,106 | 1.9% |
| Tool pages | 2 / 11 | 18.2% | 122 / 1,739 | 7.0% |
| **Both** | **5.61 / 72** | **7.8%** | **611 / 27,845** | **2.2%** |

## Scope

- **Pages** are the `.md` files under `data/tutorials/` and
  `data/tool_pages/`; one file is one page.
- **Lines** are every line of each file, including the YAML front matter and
  blank lines (`wc -l`).
- **Excluded:** the MCP server guide
  (`data/tool_pages/platform/3in_02_mcp_server.md`, 257 lines). The MCP
  endpoint was disabled in #3832, so the guide is left out of both the
  numerators and the denominators.

| Section | Pages | Lines |
| --- | --- | --- |
| Tutorials | 61 | 26,106 |
| Tool pages (without MCP guide) | 11 | 1,739 |
| **Total** | **72** | **27,845** |

## Pages Carrying the AI Disclaimer

Seven pages (MCP guide excluded) open with the sentence "This tutorial/page was
written with AI assistance and reviewed by the OCaml.org team." It was added
by PR #3798 (tutorials) and PR #3808 (tool pages). They fall into two groups.

### Entirely AI-Written Pages

Five pages are new and were written entirely with AI. Every line of these files
counts as AI-assisted, including front matter and the disclaimer itself.

| Page | File | Lines |
| --- | --- | --- |
| OCaml-CI | `data/tutorials/platform/2_10_ocaml_ci.md` | 152 |
| OCaml Docker Images | `data/tutorials/platform/2_11_docker.md` | 148 |
| Using OCaml with GitHub Actions | `data/tutorials/platform/2_12_github_actions.md` | 107 |
| The OCaml Infrastructure | `data/tool_pages/platform/3in_00_the_ocaml_infrastructure.md` | 74 |
| The Opam Repository | `data/tool_pages/platform/3in_01_opam-repository.md` | 48 |
| **Total** | | **529** |

Of these, 407 lines are tutorials and 122 lines are tool pages.

### Partly AI-Written Pages

Two older tutorials predate AI assistance and were later rewritten in part with
it. For these, only lines added by a commit credited to an AI co-author count.

A commit counts as AI-credited when its message has a
`Co-authored-by: Claude …` line. Two commits that touched these files qualify:

- **#3526**, "Rewrite opam switches tutorial and managing dependencies
  tutorials for newcomers" (co-authored by Claude Opus 4.6). This is the only
  AI-credited content change.
- **#3798**, which added the 2-line disclaimer to each file. These lines label
  the page rather than add content, so they are not counted.

The number of #3526 lines still present in each file comes from
`git blame -w -M -C`, which ignores whitespace changes and follows lines moved
or copied within and across files:

| Page | File | Lines | From #3526 | AI share |
| --- | --- | --- | --- | --- |
| Managing Dependencies With opam | `data/tutorials/platform/0_01_managing_deps.md` | 204 | 22 | 10.8% |
| Introduction to opam Switches | `data/tutorials/getting-started/2_02_opam_switch.md` | 119 | 60 | 50.4% |
| **Total** | | **323** | **82** | **25.4%** |

The remaining lines of these pages were written by people between 2021 and
2024.

## Calculation

### Per Page

An entirely AI-written page counts as 1. A partly AI-written page counts as the
fraction of its lines that come from #3526.

- Tutorials: 3 + 22/204 + 60/119 = 3 + 0.108 + 0.504 = **3.61**, out of 61
  pages, so **5.9%**.
- Tool pages: **2**, out of 11 pages, so **18.2%**.
- Both: 5.61 / 72 = **7.8%**.

Counting every page with the disclaimer as a whole page instead gives
7 / 72 = 9.7%. Most of the difference comes from Managing Dependencies, which
is only about one-tenth AI-written.

### Per Line

- Tutorials: 407 + 22 + 60 = **489** of 26,106 lines, so **1.9%**.
- Tool pages: **122** of 1,739 lines, so **7.0%**.
- Both: 611 / 27,845 = **2.2%**.

## Caveats

- **Entirely AI-written pages are taken as stated.** All of their lines count,
  including front matter and disclaimer lines, and any later human edits are
  not subtracted.
- **AI use is detected from commit messages only.** An AI-assisted change
  whose commit has no `Co-authored-by: Claude …` line is not counted.
- **`git blame` credits the last commit to touch a line.** A line from #3526
  that a later commit reworded counts as human-written, and a human line that
  #3526 only reformatted counts as AI-written.
- **The MCP guide is still published** at `/tools/docs-mcp`. Including it would
  give 3 tool pages out of 12 and 8 pages out of 73 overall.

## Reproducing

Page and line totals:

```bash
for d in data/tutorials data/tool_pages; do
  find "$d" -name '*.md' | wc -l
  find "$d" -name '*.md' -exec cat {} + | wc -l
done
```

Pages carrying the disclaimer:

```bash
grep -rl "written with AI assistance" data/tutorials data/tool_pages
```

Surviving lines per commit in a partly AI-written page:

```bash
git blame -w -M -C --line-porcelain data/tutorials/platform/0_01_managing_deps.md \
  | grep '^summary ' | sort | uniq -c | sort -rn
```
