# Plan: Obsidian → Quarto Compatibility Solution

## Problem Statement

Two syntax incompatibilities prevent seamless workflow between Obsidian and Quarto:

1. **TikZ Syntax Difference**
   - Obsidian TikZJax: ` ```tikz` with `\begin{document}...\end{document}`
   - Quarto: ` ```{.tikz}` with just `\begin{tikzpicture}...\end{tikzpicture}`

2. **Wikilink Syntax Difference**
   - Obsidian: `[[note]]` and `[[note|alias]]`
   - Quarto/Pandoc: `[text](note.md)` standard markdown links

## Constraints

- **No file conversion**: MD files must remain unchanged
- **No manual editing**: Write once in Obsidian, render in Quarto
- **Source files untouched**: Filters work in-memory only during render

## Solution: Lua Filter Pipeline

Lua filters run during Quarto rendering and transform the in-memory AST (Abstract Syntax Tree). They NEVER modify source files.

```
MD file (Obsidian syntax) [READ-ONLY]
    ↓
Pandoc parses to AST (in memory)
    ↓
Lua filters transform AST (in memory)
    ↓
Quarto renders to HTML/PDF
    ↓
Output written to _site/ folder
```

## Implementation Plan

### Step 1: Project Configuration

Create `_quarto.yml` in the vault root:

```yaml
project:
  type: website
  output-dir: _site

format:
  html:
    theme: default

filters:
  - filters/obsidian-wikilinks.lua
  - filters/obsidian-tikz.lua
  - tikz  # quarto_tikz extension for actual TikZ rendering
```

### Step 2: Create Filters Directory

```
math/
├── _quarto.yml
├── _extensions/
│   └── tikz/              # quarto_tikz extension
├── filters/
│   ├── obsidian-wikilinks.lua
│   └── obsidian-tikz.lua
├── σ-field.md             # Unchanged!
├── λ-system.md            # Unchanged!
└── ...
```

### Step 3: Wikilink Filter (`obsidian-wikilinks.lua`)

Transforms wikilinks to markdown links:

| Input (Obsidian) | Output (Rendered) |
|------------------|-------------------|
| `[[σ-field]]` | `[σ-field](σ-field.md)` |
| `[[σ-field\|sigma field]]` | `[sigma field](σ-field.md)` |
| `[[Kal2021]]` | `[Kal2021](Kal2021.md)` |

The filter parses `[[...]]` patterns and converts them to standard links.

### Step 4: TikZ Syntax Bridge Filter (`obsidian-tikz.lua`)

Transforms Obsidian TikZ blocks to Quarto format:

**Before (Obsidian syntax):**
```
` ` `tikz
\begin{document}
\begin{tikzpicture}
  \draw (0,0) circle (1cm);
\end{tikzpicture}
\end{document}
` ` `
```

**After (in-memory, for Quarto):**
```
` ` `{.tikz}
\begin{tikzpicture}
  \draw (0,0) circle (1cm);
\end{tikzpicture}
` ` `
```

### Step 5: TikZ Rendering Extension

Install `quarto_tikz` extension to actually render TikZ to images:

```bash
quarto add danmackinlay/quarto_tikz
```

**Requirements:**
- `pdflatex` (comes with TeX distribution)
- `inkscape` (for PDF → SVG conversion)

## File Changes Summary

| File | Action |
|------|--------|
| `_quarto.yml` | CREATE - project configuration |
| `filters/obsidian-wikilinks.lua` | CREATE - wikilink converter |
| `filters/obsidian-tikz.lua` | CREATE - TikZ syntax bridge |
| `_extensions/tikz/` | INSTALL via `quarto add` |
| All `.md` files | **UNCHANGED** |

## Workflow After Implementation

1. Write/edit notes in Obsidian (normal workflow)
2. Run `quarto render` or `quarto preview`
3. Filters automatically transform syntax in-memory
4. Output renders correctly with working links and TikZ diagrams
5. Source MD files remain untouched

## Verification Steps

After implementation:

1. Check MD files are unchanged: `ls -la *.md` (timestamps unchanged)
2. Check rendered output has correct links
3. Check TikZ diagrams render as images
4. Verify Obsidian still displays everything correctly

## Dependencies to Install

1. **Quarto** (if not installed): https://quarto.org/docs/get-started/
2. **LaTeX distribution** (for TikZ):
   - macOS: `brew install --cask mactex` or `brew install basictex`
3. **Inkscape** (for SVG conversion):
   - macOS: `brew install inkscape`

## Rollback

If anything goes wrong:
- Delete `_quarto.yml`, `filters/`, `_extensions/`
- Your MD files were never modified, so no data loss possible
