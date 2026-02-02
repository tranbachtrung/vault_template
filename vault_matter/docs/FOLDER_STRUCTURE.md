# Folder Structure

Complete guide to the organization of the mathematical knowledge vault.

## Table of Contents

- [Overview](#overview)
- [Root Level](#root-level)
- [Notes Directories](#notes-directories)
- [Publishing Directory](#publishing-directory)
- [Support Directories](#support-directories)
- [Hidden Directories](#hidden-directories)

---

## Overview

The vault is organized around the principle of **separation of concerns**: content creation (Obsidian) is separated from content publication (Quarto), with shared resources accessible to both.

```
vault_template                 # Vault root
├── notes_atomic/              # Core knowledge base
├── notes_research/            # Long-form research
├── notes_scrap/               # Temporary/draft notes
├── notes_zotero/              # Literature notes
├── references/                # Bibliography entries
├── templates/                 # Obsidian templates
├── vault_matter/              # Vault documentation
├── graphics/                  # Images and diagrams
├── code/                      # Code projects
├── publishing/                # Quarto projects
├── .obsidian/                 # Obsidian settings
├── .git/                      # Git repository
└── README.md                  # This documentation
```

---

## Root Level

### README.md
**Purpose**: Main documentation entry point

**Contents**:
- Overview of the vault system
- Quick start guide
- Links to detailed documentation
- Philosophy and principles

### PLAN_obsidian_quarto_compatibility.md
**Purpose**: Technical documentation of Obsidian-Quarto integration

**Contents**:
- Lua filter implementation details
- AST transformation explanation
- Filter pipeline architecture

### .gitignore
**Purpose**: Specify files/folders to exclude from version control

**Key Exclusions**:
```gitignore
_site/           # Rendered Quarto output
.quarto/         # Quarto cache
*.html           # Generated HTML files
.DS_Store        # macOS system files
```

---

## Notes Directories

### notes_atomic/

**Purpose**: Primary knowledge base - atomic notes representing single concepts

**Characteristics**:
- One concept per note
- Highly linked to other notes
- Standalone and self-contained
- Reusable across multiple publications

**Structure**:
```
notes_atomic/
├── σ-field.md
├── λ-system.md
├── π-system.md
├── measure.md
├── measure space.md
├── topological space.md
└── ...
```

**Naming Convention**:
- Use the canonical term for the concept
- Include Unicode symbols (σ, λ, π) when appropriate
- Be specific: `measure space.md` not `spaces.md`

**Template Structure** (see `templates/definition.md`):
```markdown
---
aliases:
  - alternative names
type: definition
created: 2026-01-29 17:19:57
edited: 2026-01-29
---
## Definition ([[Reference]], pg. #): Concept Name

[Main definition]

## Examples
- [[Example note 1]]
- [[Example note 2]]

## Counter-Examples
- [[Counter-example note]]

## Notes
[Additional context, intuition, connections]
```

**Types of Atomic Notes**:
- **Definitions**: Formal mathematical definitions
- **Theorems**: Formal statements with proofs
- **Propositions**: Smaller results
- **Examples**: Concrete instances
- **Counter-examples**: What doesn't work
- **Exercises**: Practice problems

---

### notes_research/

**Purpose**: Long-form research notes, paper summaries, and extended explorations

**Use Cases**:
- Literature reviews
- Research project notes
- Topic deep dives
- Reading notes on papers

**Structure**:
```
notes_research/
├── measure_theory_overview.md
├── probability_foundations_notes.md
└── project_brownian_motion/
    ├── main_notes.md
    └── scratch.md
```

**Difference from notes_atomic/**:
- Multiple concepts per note
- Narrative structure, not standalone
- Less reusable, more contextual
- May evolve significantly over time

---

### notes_scrap/

**Purpose**: Temporary workspace for drafts, incomplete thoughts, and experimental notes

**Characteristics**:
- Not cleaned up or formalized
- May contain duplicates or conflicting info
- Safe place to write without structure
- Periodically reviewed and moved to other folders

**Usage Pattern**:
```
Daily work → notes_scrap/
Review → Refine → Move to notes_atomic/ or notes_research/
Or delete if no longer relevant
```

**Example Contents**:
- Quick calculations
- Temporary problem-solving scratch work
- Ideas to develop later
- Meeting notes

---

### notes_zotero/

**Purpose**: Literature notes from Zotero references

**Structure**:
```
notes_zotero/
├── Kal2021_notes.md
├── Bas2024_notes.md
└── ...
```

**Note Format**:
```markdown
---
source: "[[Kal2021]]"
type: literature_note
---
# Kallenberg (2021) - Foundations of Modern Probability

## Chapter 1: Measure Theory

### Key Concepts
- [[σ-field]]
- [[measure space]]
- [[Monotone Class]]

### Important Theorems
- [[Thm 1.1 - Monotone Class]]

### Notes
[Your reading notes]

## Chapter 2: ...
```

**Workflow**:
1. Add reference to Zotero
2. Export to `references/[CiteKey].md` using Zotero export/integration tools
3. Create notes in `notes_zotero/[CiteKey]_notes.md`
4. Link to atomic notes in `notes_atomic/`

---

## Publishing Directory

### publishing/

**Purpose**: Quarto projects for rendering notes into websites, books, and presentations

**Structure**:
```
publishing/
├── _settings/                    # Shared resources
│   └── filters/                  # Lua filters
│       ├── atomic-include.lua
│       ├── obsidian-wikilinks.lua
│       ├── obsidian-tikz.lua
│       └── obsidian-yaml-fix.lua
├── _notes_atomic/                # Test atomic notes
├── template_website/             # Website template
├── template_book/                # Book template
└── template_presentation/        # Presentation template
```

---

### publishing/_settings/

**Purpose**: Shared configuration and filters used by all publishing projects

#### filters/

**atomic-include.lua**:
- Includes atomic notes in Quarto documents
- Strips YAML frontmatter
- Supports section extraction
- Converts wikilinks to plain text

**obsidian-wikilinks.lua**:
- Converts `[[wikilink]]` to plain text
- Handles `[[note|alias]]` syntax
- Processes split wikilinks across inline elements

**obsidian-tikz.lua**:
- Strips `\begin{document}` wrappers
- Converts Obsidian TikZ to Quarto TikZ format
- Generates cache-friendly filenames

**obsidian-yaml-fix.lua**:
- Fixes empty YAML fields
- Removes leading blank paragraphs
- Ensures clean document structure

---

### publishing/template_website/

**Purpose**: Template for creating educational websites (textbook study guides, course notes)

**Structure**:
```
template_website/
├── _quarto.yml                  # Main configuration
├── index.qmd                    # Homepage
├── styles.css                   # Custom styles
├── dark-mode-handler.html       # Dark mode toggle
├── _extensions/                 # Quarto extensions
│   ├── atomic/                  # Atomic note shortcode
│   └── danmackinlay/tikz/       # TikZ rendering
├── notes/                       # Note chapters
│   ├── notes.qmd
│   └── chapter01/
│       ├── chapter01_notes.qmd
│       └── ...
├── solutions/                   # Exercise solutions
│   ├── solutions.qmd
│   └── chapter01/
├── references/                  # Bibliography page
│   └── references.qmd
├── cheatsheets/                 # Quick reference
│   └── cheatsheets.qmd
└── _site/                       # Rendered output (gitignored)
```

**Key Files**:

**_quarto.yml**: Main configuration
```yaml
project:
  type: website
  output-dir: _site

website:
  title: "Book Study Guide"
  navbar: ...
  sidebar: ...

format:
  html:
    theme:
      light: flatly
      dark: darkly
    toc: true
    html-math-method: katex

filters:
  - ../_settings/filters/atomic-include.lua
  - ../_settings/filters/obsidian-yaml-fix.lua
  - ../_settings/filters/obsidian-wikilinks.lua
  - ../_settings/filters/obsidian-tikz.lua
  - danmackinlay/tikz
```

**Usage**:
1. Copy `template_website/` to new folder: `my_project/`
2. Customize `_quarto.yml` (title, navbar, sidebar)
3. Create `.qmd` files that reference atomic notes
4. Run `quarto preview` for live preview
5. Run `quarto render` to build

**Including Atomic Notes**:
```markdown
# Chapter 1: Measure Theory

{{< atomic "../../../notes_atomic/σ-field.md" >}}

{{< atomic "../../../notes_atomic/measure.md" "#Examples" >}}
```

---

### publishing/template_book/

**Purpose**: Template for creating PDF books or long-form documents

**Structure**:
```
template_book/
├── _quarto.yml          # Book configuration
├── index.qmd           # Title page
├── chapters/
│   ├── chapter01.qmd
│   ├── chapter02.qmd
│   └── ...
└── references.qmd      # Bibliography
```

**Output Formats**:
- PDF (via LaTeX)
- HTML website
- EPUB (e-book)

**Usage**: Similar to website template, but with book-specific navigation and structure.

---

### publishing/template_presentation/

**Purpose**: Template for creating slide presentations with reveal.js

**Structure**:
```
template_presentation/
├── _quarto.yml          # Presentation config
└── presentation.qmd     # Slide content
```

**Features**:
- Reveal.js slides
- Incremental reveals
- Code highlighting
- Math equations
- TikZ diagrams
- Speaker notes

**Usage**:
```markdown
---
title: "Measure Theory Basics"
format: revealjs
---

# σ-fields

{{< atomic "../../notes_atomic/σ-field.md" >}}

---

# Applications

- Probability spaces
- Integration theory
```

---

## Support Directories

### references/

**Purpose**: Bibliography entries and reference notes

**Structure**:
```
references/
├── Kal2021.md
├── Bas2024.md
└── library.bib
```

**Note Format**:
```markdown
---
type: reference
citekey: Kal2021
---
## Kallenberg, O. (2021). *Foundations of Modern Probability*

**Full Citation**: Kallenberg, O. (2021). Foundations of Modern Probability (3rd ed.). Springer.

**Topics**: [[Probability Theory]], [[Measure Theory]]

**Key Chapters**:
- Chapter 1: [[σ-field]], [[measure space]]
- Chapter 2: [[random variables]], [[distribution]]

**Notes**:
Comprehensive treatment of probability theory...
```

**library.bib**: Auto-exported from Zotero with Better BibTeX
```bibtex
@book{Kal2021,
  author = {Kallenberg, Olav},
  title = {Foundations of Modern Probability},
  year = {2021},
  publisher = {Springer}
}
```

---

### templates/

**Purpose**: Obsidian templates for creating consistent atomic notes

**Available Templates**:

- **definition.md**: Mathematical definitions
- **theorem.md**: Theorems with proofs
- **proposition.md**: Smaller results
- **example.md**: Concrete examples
- **counter example.md**: Counter-examples
- **exercise.md**: Practice problems
- **question.md**: Open questions

**Usage in Obsidian**:
1. Settings → Templates → Template folder: `templates/`
2. Create new note
3. Ctrl+T (or Cmd+T) → Select template
4. Fill in placeholders

**Template Example** (definition.md):
```markdown
---
aliases:
type: definition
created: "{{date}} {{time}}"
edited: "{{date}}"
---
## Definition # ([[]], pg. #): definition name


## Examples


## Counter-Examples


## Notes

```

---

### vault_matter/

**Purpose**: Documentation about the vault itself - meta-information, workflows, planned features

**Contents**:
- Vault workflow documentation
- Feature descriptions
- Planned improvements
- Usage guidelines
- Tool integration notes

**Structure**:
```
vault_matter/
├── categories/          # Category overview notes
└── (other meta docs)
```

#### categories/

**Purpose**: Overview notes for major categories using Obsidian's "Bases" feature

**Concept**: Create high-level category notes that automatically include all notes of a certain type

**Example** (categories/measure_theory.md):
```markdown
---
type: category
---
# Measure Theory

## Overview
Core concepts in measure theory...

## Key Definitions
- [[σ-field]]
- [[measure space]]
- [[measurable set]]

## Important Theorems
- [[Monotone Class Theorem]]

## Graph View
[Embedded graph showing connections]
```

**Purpose**: Provides bird's-eye view of related notes and their connections.

---

### graphics/

**Purpose**: Store images, diagrams, and visual assets

**Structure**:
```
graphics/
├── diagrams/
│   ├── venn_diagram.svg
│   └── commutative_diagram.svg
├── figures/
└── tikz_exports/
```

**Usage**:
```markdown
![Venn Diagram](graphics/diagrams/venn_diagram.svg)
```

**Obsidian Settings**: Settings → Files and Links → Default location for new attachments: `graphics/`

---

### code/

**Purpose**: Programming projects, computational notebooks, and code sandboxes

**Structure**:
```
code/
└── codebases/
└── sandboxes/
    ├── probability_simulations/
    └── measure_theory_examples/
```

codebases/: holds complete codebases

sandboxes/: holds scrap codes for experimentation

**Use Cases**:
- Monte Carlo simulations
- Computational examples
- Algorithm implementations
- Interactive demonstrations

**Integration with Quarto**: Can include code directly in `.qmd` files or reference external scripts.

---

## Hidden Directories

### .obsidian/

**Purpose**: Obsidian application settings and workspace state

**Key Files**:
- `community-plugins.json`: List of enabled plugins
- `workspace.json`: Current workspace layout (gitignored)
- `app.json`: App preferences
- `plugins/`: Plugin data and settings

**Note**: `workspace.json` is personal and should not be version controlled. Other settings can be shared.

---

### .git/

**Purpose**: Git version control repository

**Best Practices**:
- Commit atomic notes regularly
- Use meaningful commit messages
- Don't commit `_site/` or `.quarto/` (gitignored)
- Create branches for major changes
- Push to GitHub for backup

---

### .quarto/

**Purpose**: Quarto build cache and temporary files

**Contents**:
- Rendered markdown cache
- Crossref information
- Build artifacts

**Note**: Gitignored - regenerated on each build

---

## Directory Decision Tree

**Where should I put this file?**

```
Is it a single concept/definition/theorem?
├─ YES → notes_atomic/
└─ NO → Is it a complete thought/article?
         ├─ YES → notes_research/
         └─ NO → Is it polished?
                  ├─ YES → notes_research/
                  └─ NO → notes_scrap/

Is it from a paper/book?
├─ Bibliographic entry → references/
└─ Reading exported from Zotero → notes_zotero/

Is it a Quarto project?
├─ Website → publishing/website_name
├─ Book → publishing/book_name
└─ Presentation → publishing/presentations/presentation_name

Is it an image/diagram?
└─ graphics/

Is it code?
└─ code/

Is it about the vault itself?
└─ vault_matter/
```

---

## Maintenance
- Review `notes_scrap/` - promote to atomic or delete
- Check for broken wikilinks
- Update literature notes from recent reading
- Review and refactor related notes
- Update category overview notes
- Clean up unused graphics
- Check git repository size
- Split overly complex atomic notes
- Merge redundant notes
- Update templates based on new patterns
- Reorganize folder structure if needed

---

## Next Steps

- **[Workflow](WORKFLOW.md)**: Learn the complete note-taking → publishing process
- **[Tools & Setup](TOOLS_AND_SETUP.md)**: Configure all tools properly
- **[Deployment](DEPLOYMENT.md)**: Publish your work to the web
