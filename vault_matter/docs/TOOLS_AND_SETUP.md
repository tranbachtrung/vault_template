# Tools & Setup Guide

Complete installation and configuration guide for all tools in the mathematical knowledge vault.

## Table of Contents

- [Primary Tools](#primary-tools)
  - [Obsidian](#obsidian)
  - [Quarto](#quarto)
  - [Zotero](#zotero)
  - [Git/GitHub](#gitgithub)
- [Supporting Tools](#supporting-tools)
  - [LaTeX Distribution](#latex-distribution)
  - [Inkscape](#inkscape)
- [Programming Languages](#programming-languages)
- [Verification](#verification)

---

## Primary Tools

### Obsidian

**Purpose**: Primary note-taking and knowledge management interface

**Installation**:
```bash
# macOS
brew install --cask obsidian

# Or download from https://obsidian.md/
```

**Configuration**:

1. **Open Vault**: File → Open folder as vault → Select the `vault_template/` directory
2. **Enable Community Plugins**: Settings → Community plugins → Turn off Restricted mode

**Required Plugins**:

#### 1. obsidian-tikzjax
- **Purpose**: Render TikZ diagrams directly in Obsidian
- **Installation**: 
  - Settings → Community plugins → Browse
  - Search "TikzJax"
  - Install and Enable
- **Configuration**: No special configuration needed

#### 2. qmd-as-md-obsidian
- **Purpose**: Treat `.qmd` (Quarto) files as markdown
- **Installation**:
  - Settings → Community plugins → Browse
  - Search "Qmd as md"
  - Install and Enable
- **Configuration**: Automatically treats `.qmd` files as markdown

**Optional Recommended Plugins**:

- **Templater**: Advanced templating (alternative to core Templates)
- **Dataview**: Query and display notes dynamically
- **Tag Wrangler**: Manage tags efficiently
- **Graph Analysis**: Enhanced graph view features
- **Excalidraw**: Sketch diagrams directly in Obsidian

**Core Settings**:

```
Settings → Files and Links:
  - Default location for new notes: notes_atomic/
  - Default location for new attachments: graphics/
  - Automatically update internal links: ON

Settings → Templates:
  - Template folder location: templates/
  - Date format: YYYY-MM-DD
  - Time format: HH:mm:ss
```

---

### Quarto

**Purpose**: Compile markdown notes into websites, books, presentations, and PDFs

**Installation**:
```bash
# macOS
brew install quarto

# Or download from https://quarto.org/docs/get-started/
```

**Verify Installation**:
```bash
quarto --version
# Should show version ≥ 1.2.0
```

**Extensions Used**:

#### 1. danmackinlay/quarto_tikz
- **Purpose**: Render TikZ diagrams to SVG in Quarto output
- **Installation** (in publishing directory):
  ```bash
  cd publishing/template_website/
  quarto add danmackinlay/quarto_tikz
  ```
- **Dependencies**: Requires LaTeX and Inkscape (see below)

#### 2. Custom atomic Extension
- **Purpose**: Include atomic notes with shortcode syntax
- **Location**: `publishing/template_website/_extensions/atomic/`
- **Installation**: Already included in repository
- **Usage**: `{{< atomic "path/to/note.md" >}}`

**Configuration**:

Each publishing template has its own `_quarto.yml` configuration file. Key settings:

```yaml
project:
  type: website  # or book, or default for presentations
  output-dir: _site

filters:
  - ../_settings/filters/atomic-include.lua
  - ../_settings/filters/obsidian-yaml-fix.lua
  - ../_settings/filters/obsidian-wikilinks.lua
  - ../_settings/filters/obsidian-tikz.lua
  - danmackinlay/tikz

format:
  html:
    theme: flatly
    toc: true
    html-math-method: katex
```

---

### Zotero

**Purpose**: Reference and citation management

**Installation**:
```bash
# macOS
brew install --cask zotero

# Or download from https://www.zotero.org/download/
```

**Configuration**:

1. **Install Better BibTeX Plugin**:
   - Download from https://github.com/retorquere/zotero-better-bibtex
   - Tools → Add-ons → Install Add-on from File
   - Select downloaded `.xpi` file

2. **Set Citation Key Format**:
   - Preferences → Better BibTeX
   - Citation key format: `[auth][year]` (generates keys like `Kal2021`)

3. **Auto-Export Library**:
   - File → Export Library
   - Format: Better BibTeX
   - Select: Keep updated
   - Save to: `references/library.bib`

**Creating Literature Notes**:

1. Right-click reference in Zotero → Create Note
2. Write notes in Zotero note editor
3. Export individual note to `notes_zotero/[AuthorYear].md`
4. Link to atomic notes: `[[σ-field]]`

**Integration with Vault**:

Store bibliographic entries in `references/` folder:
```markdown
# references/Kal2021.md
---
type: reference
citekey: Kal2021
---
## Kallenberg, O. (2021). *Foundations of Modern Probability*

- **Type**: Textbook
- **Topics**: Probability Theory, Measure Theory
- **Key Concepts**: [[σ-field]], [[measure space]], [[Monotone Class]]

## Notes
[Your notes about this reference]
```

---

### Git/GitHub

**Purpose**: Version control and collaboration

**Installation**:
```bash
# macOS (usually pre-installed)
git --version

# If not installed:
xcode-select --install
```

**Initial Setup**:
```bash
cd /path/to/math/
git init
git add .
git commit -m "Initial commit"

# Connect to GitHub
gh repo create math-vault --public --source=. --remote=origin
git push -u origin main
```

**Recommended .gitignore** (already included):
```gitignore
_site/
.quarto/
*.html
.DS_Store
.obsidian/workspace.json  # Personal workspace settings
```

**Workflow**:
```bash
# Daily commits
git add notes_atomic/
git commit -m "Added notes on σ-fields and measure spaces"
git push

# Before publishing
cd publishing/template_website/
quarto render
git add _site/
git commit -m "Update rendered website"
git push
```

**GitHub Pages Deployment**:
```bash
# First time
quarto publish gh-pages

# Updates
quarto publish gh-pages --no-prompt
```

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed GitHub Pages setup.

---

## Supporting Tools

### LaTeX Distribution

**Purpose**: TikZ diagram compilation in Quarto

**Installation**:
```bash
# macOS - Full distribution (3.9 GB)
brew install --cask mactex

# macOS - Minimal distribution (100 MB)
brew install --cask basictex

# After basictex, install required packages:
sudo tlmgr update --self
sudo tlmgr install pgf tikz-cd standalone preview
```

**Verify Installation**:
```bash
pdflatex --version
# Should show pdfTeX version
```

**Note**: TikZ diagrams in Obsidian use TikZJax (JavaScript), but Quarto uses pdflatex for compilation.

---

### Inkscape

**Purpose**: Convert PDF diagrams to SVG for web display

**Installation**:
```bash
# macOS
brew install inkscape

# Verify
inkscape --version
```

**Usage**: Automatically invoked by `quarto_tikz` extension during rendering.

---

## Programming Languages

### Python (Optional)

For computational notebooks and code cells in Quarto:

```bash
# Install Python
brew install python

# Create virtual environment for projects
cd publishing/template_website/
python -m venv .venv
source .venv/bin/activate
pip install jupyter matplotlib numpy pandas scipy
```

**Quarto + Python**:
````markdown
```{python}
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0, 2*np.pi, 100)
plt.plot(x, np.sin(x))
plt.show()
```
````

### R (Optional)

For statistical computing in Quarto:

```bash
# Install R
brew install --cask r
brew install --cask rstudio

# Install common packages
R
> install.packages(c("tidyverse", "knitr", "rmarkdown"))
```

### Lua (Included)

Lua is used for Pandoc filters and is included with Quarto/Pandoc. No separate installation needed.

---

## Verification

After installation, verify everything works:

### 1. Obsidian
```
✓ Open vault successfully
✓ See TikZ diagrams rendered
✓ Templates work when creating new notes
✓ Wikilinks autocomplete and resolve
```

### 2. Quarto
```bash
cd publishing/template_website/
quarto preview

✓ Preview opens at http://localhost:4200
✓ TikZ diagrams render as images
✓ Math equations display correctly
✓ Navigation works
```

### 3. Build Pipeline
```bash
cd publishing/template_website/
quarto render

✓ No errors during build
✓ _site/ folder created
✓ HTML files present
✓ TikZ SVGs generated
```

### 4. Git
```bash
git status

✓ Repository initialized
✓ .gitignore working (_site/ not tracked)
✓ Can commit and push
```

---

## Troubleshooting

### TikZ Not Rendering in Quarto

**Problem**: TikZ blocks show as code, not images

**Solutions**:
1. Check LaTeX installation: `pdflatex --version`
2. Check Inkscape: `inkscape --version`
3. Verify `danmackinlay/tikz` filter in `_quarto.yml`
4. Check filter order: `obsidian-tikz.lua` should come before `danmackinlay/tikz`

### Quarto Preview Not Working

**Problem**: `quarto preview` fails or shows errors

**Solutions**:
1. Check Quarto version: `quarto --version` (need ≥1.2.0)
2. Verify `_quarto.yml` syntax (use YAML validator)
3. Check Lua filter paths are correct
4. Run `quarto check` for diagnostics

### Wikilinks Not Converting

**Problem**: Wikilinks appear as `[[text]]` in rendered output

**Solutions**:
1. Verify `obsidian-wikilinks.lua` is in filter list
2. Check filter path is correct relative to `_quarto.yml`
3. Ensure filter is not commented out

### Git Push Fails

**Problem**: Cannot push to GitHub

**Solutions**:
1. Check authentication: `gh auth status`
2. Login if needed: `gh auth login`
3. Verify remote: `git remote -v`
4. Check file sizes (GitHub has 100MB limit)

---

## Next Steps

- **[Folder Structure](FOLDER_STRUCTURE.md)**: Understand vault organization
- **[Workflow](WORKFLOW.md)**: Learn the note-taking → publishing process
- **[Deployment](DEPLOYMENT.md)**: Publish your website to the world
