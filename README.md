# Knowledge Vault

> An integrated knowledge management system combining Obsidian for atomic note-taking with Quarto for professional publishing.

Template Website: https://tranbachtrung.github.io/vault_template/

[![Obsidian](https://img.shields.io/badge/Obsidian-7C3AED?style=flat&logo=obsidian&logoColor=white)](https://obsidian.md/)
[![Quarto](https://img.shields.io/badge/Quarto-75AADB?style=flat&logo=quarto&logoColor=white)](https://quarto.org/)

## 📋 Table of Contents

- [Overview](#overview)
- [Philosophy](#philosophy)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Tools & Technologies](#tools--technologies)
- [Folder Structure](#folder-structure)
- [Workflow](#workflow)
- [Publishing](#publishing)
- [Contributing](#contributing)

## 🎯 Overview

This vault implements a **write-once, publish-anywhere** workflow for mathematical knowledge management. Write atomic notes in [Obsidian](https://obsidian.md/) using native features (wikilinks, TikZ diagrams, templates), then seamlessly compile them into professional outputs (websites, books, presentations) using [Quarto](https://quarto.org/).

### Key Features

- ✅ **Single source of truth**: All knowledge lives in atomic markdown notes
- ✅ **No file modification**: Source files never change during publishing
- ✅ **Native Obsidian experience**: Use wikilinks, TikZ, templates without compromise
- ✅ **Professional output**: Publish to HTML, PDF, presentations via Quarto
- ✅ **Version controlled**: Full Git integration for tracking changes
- ✅ **Reference management**: Zotero integration for citations

## 🧠 Philosophy

This system is built on three core principles:

1. **Atomic Notes**: Each concept is a standalone note that can be composed into larger works
2. **Obsidian First**: Notes are written in Obsidian using its full feature set
3. **Seamless Publishing**: Lua filters bridge Obsidian ↔ Quarto syntax at render time

The workflow eliminates rewriting by allowing you to:
- Write atomic notes once in Obsidian
- Reference them in multiple publications
- Render to websites, books, or presentations
- Keep source files unchanged and readable

## 🚀 Quick Start

### Prerequisites

Install the required tools:

```bash
# macOS
brew install --cask obsidian
brew install --cask quarto
brew install --cask mactex  # or basictex for smaller install
brew install inkscape
```

### Setup

1. **Clone this repository**
   ```bash
   git clone https://github.com/username/math-vault.git
   cd math-vault
   ```

2. **Open as Obsidian vault**
   - Launch Obsidian
   - Open folder as vault → Select `vault_template/` directory

3. **Install dependencies** (see [Tools & Setup](docs/TOOLS_AND_SETUP.md))
   ```bash
   brew install quarto
   brew install --cask mactex  # or basictex
   brew install inkscape
   ```

4. **Preview a template**
   ```bash
   cd publishing/template_website/
   quarto preview
   ```

### Create Your First Note

1. Use a template from `templates/` folder
2. Write your note in `notes_atomic/`
3. Link to other notes with `[[wikilinks]]`
4. Include TikZ diagrams with ` ```tikz` blocks
5. View in Obsidian, publish via Quarto

## 📚 Documentation

Comprehensive documentation is organized in the [vault_matter/docs/](vault_matter/docs/) folder:

- **[Quick Reference](docs/QUICK_REFERENCE.md)**: Essential commands and daily workflows
- **[Tools & Setup](docs/TOOLS_AND_SETUP.md)**: Installation and configuration guide for all tools
- **[Folder Structure](docs/FOLDER_STRUCTURE.md)**: Detailed explanation of each directory
- **[Workflow](docs/WORKFLOW.md)**: Atomic notes → Publishing workflow explained
- **[Deployment](docs/DEPLOYMENT.md)**: Building and deploying Quarto websites to GitHub Pages
- **[Integration](PLAN_obsidian_quarto_compatibility.md)**: Technical details of Obsidian-Quarto compatibility

## 🛠️ Tools & Technologies

### Primary Tools

| Tool | Purpose | Version |
|------|---------|---------|
| **[Obsidian](https://obsidian.md/)** | Note-taking and knowledge management | Latest |
| **[Quarto](https://quarto.org/)** | Document rendering and publishing | ≥1.2.0 |
| **[Zotero](https://www.zotero.org/)** | Reference management | Latest |
| **[Git](https://git-scm.com/)** | Version control | Latest |

### Supporting Technologies

- **LaTeX/TikZ**: Mathematical diagrams and typesetting
- **Pandoc**: Document conversion (bundled with Quarto)
- **Lua**: Filter scripting for Obsidian↔Quarto compatibility
- **Python/R**: Optional for computational content
- **Google Colab**: Collaborative Jupyter notebooks with auto-sync

### Obsidian Plugins

- **obsidian-tikzjax**: Render TikZ diagrams in Obsidian
- **qmd-as-md-obsidian**: Treat `.qmd` files as markdown

See [Tools & Setup](docs/TOOLS_AND_SETUP.md) for detailed configuration.

## 📁 Folder Structure

```
vault_template/
├── notes_atomic/             # Atomic notes (single concepts)
├── notes_research/           # Research notes and longer writings
├── notes_scrap/              # Temporary/draft notes
├── notes_zotero/             # Literature notes from Zotero
├── references/               # Bibliography entries
├── templates/                # Obsidian templates for atomic notes
├── vault_matter/             # Vault documentation and metadata
│   ├── docs/                     # Complete documentation
│   │   ├── TOOLS_AND_SETUP.md
│   │   ├── FOLDER_STRUCTURE.md
│   │   ├── WORKFLOW.md
│   │   └── DEPLOYMENT.md
│   └── categories/           # Category overview notes (Bases feature)
├── graphics/                 # Images and diagrams
├── code/                     # Code projects and sandboxes
│   ├── google_colab/         # Collaborative notebooks (synced via Drive)
│   ├── sandboxes/            # Experimental code
│   └── codebases/            # Complete codebases
└── publishing/               # Quarto publishing projects
    ├── _settings/            # Shared Lua filters
    ├── template_website/     # Website template
    ├── template_book/        # Book template
    └── template_presentation/ # Presentation template
```

**Key Folders:**

- **`notes_atomic/`**: Your primary knowledge base. Each file represents one concept.
- **`publishing/`**: Contains Quarto templates. Copy `template_*` folders to start new projects.
- **`vault_matter/`**: Documentation about the vault itself, workflow, features, and planned improvements.
- **`docs/`**: Complete documentation guides for setup, workflow, and deployment.

See [Folder Structure](docs/FOLDER_STRUCTURE.md) for complete details.

## 🔄 Workflow

### 1. Capture Knowledge (Obsidian)

```
Research → Atomic Note → Template → YAML Metadata → Content
```

- Create notes using templates (`templates/definition.md`, `templates/theorem.md`, etc.)
- Use wikilinks to connect concepts: `[[σ-field]]`, `[[measure space]]`
- Add TikZ diagrams for visualization
- Store literature notes in `notes_zotero/`

### 2. Organize & Connect

- Link related concepts with wikilinks
- Create MOCs (Maps of Content) in `vault_matter/categories/`
- Use Obsidian's graph view to explore connections

### 3. Publish (Quarto)

```
Atomic Notes → Quarto Template → Lua Filters → HTML/PDF/Website
```

- Copy a template from `publishing/template_*/`
- Create `.qmd` files that reference atomic notes
- Run `quarto preview` to see live updates
- Run `quarto render` to build final output

### Architecture

```
Atomic Notes (Obsidian syntax) [READ-ONLY]
    ↓
Quarto reads .qmd files
    ↓
Lua filters transform Obsidian syntax in-memory
    ↓
Quarto renders to output format
    ↓
_site/ folder contains final website/book/presentation
```

**Key Insight**: Source `.md` files never change. All transformations happen in memory during rendering.

See [Workflow](docs/WORKFLOW.md) for detailed explanation.

## 🚀 Publishing

### Local Development

```bash
cd publishing/template_website/
quarto preview
```

Opens a live-reloading preview at `http://localhost:4200`

### Build for Production

```bash
cd publishing/template_website/
quarto render
```

Output is written to `_site/` folder

### Deploy to GitHub Pages

```bash
# First time setup
quarto publish gh-pages

# Subsequent updates
quarto publish gh-pages --no-prompt
```

See [Deployment](docs/DEPLOYMENT.md) for complete guide including custom domains, GitHub Actions, and CI/CD.

## 📝 Using as a Template

This vault is designed to be reusable for any subject area:

1. **Fork/clone** this repository
   ```bash
   git clone https://github.com/username/math-vault.git my-subject-vault
   cd my-subject-vault
   ```

2. **Clear content**: Delete example notes in `notes_atomic/`, keep structure
   ```bash
   rm notes_atomic/*.md  # Keep the folder
   ```

3. **Update templates**: Modify `templates/` for your domain
   ```bash
   # Edit templates/definition.md, theorem.md, etc.
   # Adjust YAML frontmatter for your needs
   ```

4. **Customize publishing**: Copy and rename template folders
   ```bash
   cd publishing/
   cp -r template_website/ my_project_website/
   # Edit _quarto.yml with your project details
   ```

5. **Start writing**: Create atomic notes using your templates
   - Open Obsidian
   - Use templates (Cmd/Ctrl + T)
   - Build your knowledge base

6. **Publish**: Render and deploy your customized project
   ```bash
   cd publishing/my_project_website/
   quarto preview  # Test locally
   quarto publish gh-pages  # Deploy to web
   ```

The infrastructure (Lua filters, Quarto configs, folder structure) works for any knowledge domain.

## 🤝 Contributing

Improvements welcome! Areas of interest:

- Additional Lua filters for Obsidian features
- Quarto templates (styles, themes, layouts)
- Documentation improvements
- Workflow optimizations

## 📄 License

This template and codebase structure is freely available for use. Content within `notes_*/` directories is subject to their own licensing.
