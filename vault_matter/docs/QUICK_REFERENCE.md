# Quick Reference

Essential commands and workflows for the mathematical knowledge vault.

## Daily Workflow

### Morning: Capture & Create

```bash
# 1. Open Obsidian vault
# 2. Review yesterday's notes_scrap/
# 3. Refine into atomic notes

# Create new atomic note
Cmd/Ctrl + N  # New note
Cmd/Ctrl + T  # Insert template
```

### During: Link & Organize

```markdown
# While writing, link freely
[[σ-field]] connects to [[measure space]]

# Use wikilinks for references
See [[Kal2021]] page 10 for details
```

### Evening: Review

```bash
# Check graph view for connections
# Update category overview notes
# Move polished notes from scrap to atomic
```

## Publishing Workflow

### Create New Project

```bash
# Copy template
cd publishing/
cp -r template_website/ my_project/
cd my_project/

# Edit configuration
vim _quarto.yml  # Update title, links, etc.
```

### Write Content

```markdown
# Create .qmd files
---
title: "Chapter 1"
---

# Introduction

{{< atomic "../../notes_atomic/σ-field.md" >}}

{{< atomic "../../notes_atomic/measure.md" "#Definition" >}}
```

### Preview & Deploy

```bash
# Local preview
quarto preview

# Build
quarto render

# Deploy to GitHub Pages
quarto publish gh-pages
```

## Essential Commands

### Obsidian

| Action | Shortcut |
|--------|----------|
| New note | `Cmd/Ctrl + N` |
| Search | `Cmd/Ctrl + O` |
| Command palette | `Cmd/Ctrl + P` |
| Insert template | `Cmd/Ctrl + T` |
| Follow link | `Cmd/Ctrl + Click` |
| Open graph | `Cmd/Ctrl + G` |
| Toggle edit/preview | `Cmd/Ctrl + E` |

### Quarto

```bash
# Preview with live reload
quarto preview

# Render to HTML/PDF
quarto render

# Clean build
quarto render --clean

# Deploy to GitHub Pages
quarto publish gh-pages

# Check installation
quarto check

# List extensions
quarto list extensions
```

### Git

```bash
# Daily commits
git add notes_atomic/
git commit -m "Added notes on measure theory"
git push

# Check status
git status

# View history
git log --oneline

# Create branch
git checkout -b feature/new-topic

# Merge changes
git checkout main
git merge feature/new-topic
```

## File Templates

### Atomic Note (Definition)

```markdown
---
aliases:
  - alternative name
type: definition
created: "2026-01-29 17:19:57"
edited: "2026-01-29"
---
## Definition ([[Reference]], pg. #): Concept Name

[Definition text]

## Examples
- [[Example 1]]

## Counter-Examples
- [[Counter-example 1]]

## Notes
[Additional context]
```

### Quarto Document

```markdown
---
title: "Chapter Title"
---

# Section Heading

{{< atomic "path/to/note.md" >}}

Regular markdown content here.

# Another Section

{{< atomic "path/to/note.md" "#Specific Section" >}}
```

### _quarto.yml (Website)

```yaml
project:
  type: website
  output-dir: _site

website:
  title: "My Project"
  navbar:
    right:
      - text: "Home"
        href: index.qmd
      - text: "Chapter 1"
        href: chapter01.qmd

format:
  html:
    theme: flatly
    toc: true

filters:
  - ../_settings/filters/atomic-include.lua
  - ../_settings/filters/obsidian-yaml-fix.lua
  - ../_settings/filters/obsidian-wikilinks.lua
  - ../_settings/filters/obsidian-tikz.lua
  - danmackinlay/tikz
```

## Common Tasks

### Add New Atomic Note

1. `Cmd/Ctrl + N` in Obsidian
2. Save to `notes_atomic/concept-name.md`
3. `Cmd/Ctrl + T` → Select template
4. Fill in definition, examples, links
5. Save

### Include Note in Publication

```markdown
{{< atomic "../../notes_atomic/concept-name.md" >}}
```

### Add TikZ Diagram

````markdown
```tikz
\begin{document}
\begin{tikzpicture}
  % Your TikZ code
  \draw (0,0) circle (1);
\end{tikzpicture}
\end{document}
```
````

### Reference Bibliography

```markdown
See [[Kal2021]] for details.

According to [[Bas2024]], page 14...
```

### Create Category Overview

```markdown
# vault_matter/categories/topic_name.md

# Topic Name Overview

## Core Concepts
- [[concept 1]]
- [[concept 2]]

## Key Theorems
- [[Theorem 1]]

## References
- [[Reference1]]
```

## Troubleshooting Quick Fixes

### Wikilinks Show as [[text]] in Output

```bash
# Check filter is in _quarto.yml
filters:
  - ../_settings/filters/obsidian-wikilinks.lua
```

### TikZ Not Rendering

```bash
# Check dependencies
pdflatex --version
inkscape --version

# Verify filter order
filters:
  - ../_settings/filters/obsidian-tikz.lua
  - danmackinlay/tikz
```

### Preview Not Updating

```bash
# Restart preview
Ctrl+C
quarto preview
```

### Build Fails

```bash
# Clean and rebuild
quarto render --clean
```

## File Locations

| Content Type | Location |
|--------------|----------|
| Atomic notes | `notes_atomic/` |
| Templates | `templates/` |
| Bibliography | `references/` |
| Literature notes | `notes_zotero/` |
| Draft notes | `notes_scrap/` |
| Images | `graphics/` |
| Publishing projects | `publishing/` |
| Lua filters | `publishing/_settings/filters/` |

## Links to Full Documentation

- **[Main README](../README.md)**: Overview
- **[Tools & Setup](TOOLS_AND_SETUP.md)**: Installation
- **[Folder Structure](FOLDER_STRUCTURE.md)**: Organization
- **[Workflow](WORKFLOW.md)**: Complete process
- **[Deployment](DEPLOYMENT.md)**: Publishing guide

## Installation One-Liner

```bash
# macOS complete setup
brew install --cask obsidian quarto mactex && brew install inkscape
```

## Deploy One-Liner

```bash
# From publishing template directory
quarto render && quarto publish gh-pages --no-prompt
```

## Backup Command

```bash
# Backup entire vault
cd /path/to/math/
tar -czf math-vault-backup-$(date +%Y%m%d).tar.gz \
  notes_atomic/ notes_research/ notes_zotero/ \
  references/ templates/ vault_matter/ \
  publishing/ --exclude='_site' --exclude='.quarto'
```

## Health Check

```bash
# Check all tools installed
command -v obsidian && echo "✓ Obsidian" || echo "✗ Obsidian"
command -v quarto && echo "✓ Quarto" || echo "✗ Quarto"
command -v pdflatex && echo "✓ LaTeX" || echo "✗ LaTeX"
command -v inkscape && echo "✓ Inkscape" || echo "✗ Inkscape"
command -v git && echo "✓ Git" || echo "✗ Git"

# Check Quarto can render
cd publishing/template_website/
quarto check
```
