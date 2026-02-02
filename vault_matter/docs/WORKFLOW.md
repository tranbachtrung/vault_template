# Workflow Guide

Complete guide to the atomic notes → publishing workflow in the mathematical knowledge vault.

## Table of Contents

- [Overview](#overview)
- [Philosophy: Single Source of Truth](#philosophy-single-source-of-truth)
- [Phase 1: Capture & Create (Obsidian)](#phase-1-capture--create-obsidian)
- [Phase 2: Organize & Connect](#phase-2-organize--connect)
- [Phase 3: Publish (Quarto)](#phase-3-publish-quarto)
- [Complete Example](#complete-example)
- [Advanced Workflows](#advanced-workflows)
- [Best Practices](#best-practices)

---

## Overview

The workflow implements a **write-once, publish-anywhere** philosophy:

```
Research/Learning
      ↓
Atomic Notes (Obsidian)
      ↓
Link & Organize
      ↓
Compose into Projects (.qmd files)
      ↓
Render with Quarto
      ↓
Publish (Web/PDF/Presentation)
```

**Key Principle**: Notes are written once in Obsidian and reused across multiple publications without modification.

---

## Philosophy: Single Source of Truth

### The Problem with Traditional Workflows

**Traditional approach**:
```
Notes → Copy to Word → Edit for paper
      → Copy to slides → Edit for presentation
      → Copy to blog → Edit for website
```

**Problems**:
- Same content repeated in multiple places
- Updates require editing multiple files
- Inconsistencies between versions
- Wasted time rewriting

### Our Solution: Atomic Notes

**Atomic note approach**:
```
Atomic Notes (single source)
      ↓
Paper.qmd ────┐
Slides.qmd ───┼──→ Quarto Render → Multiple Outputs
Website.qmd ──┘
```

**Benefits**:
- ✅ Write concept once, use everywhere
- ✅ Update in one place, propagates to all outputs
- ✅ Consistent terminology and definitions
- ✅ Reduces cognitive load
- ✅ Faster content creation

### What Makes a Good Atomic Note?

**Characteristics**:
1. **Single concept**: One definition, theorem, or example
2. **Self-contained**: Understandable on its own
3. **Well-linked**: Connected to related concepts
4. **Reusable**: Can appear in any context
5. **Permanent**: Won't change significantly over time

**Good Example**:
```markdown
# σ-field.md
Definition: A σ-field is a collection of sets closed under...
Examples: [[Example 1]], [[Example 2]]
Properties: [[countably additive]], [[complement closed]]
```

**Bad Example**:
```markdown
# chapter1_notes.md
This chapter covers σ-fields, measures, and integration.
First we define a σ-field as...
Then we define a measure as...
[Too many concepts, not reusable]
```

---

## Phase 1: Capture & Create (Obsidian)

### Step 1: Research & Reading

**Sources**:
- Textbooks (Kallenberg, Bass, etc.)
- Papers
- Lectures
- Courses

**Initial Capture**:
1. Add reference to Zotero
2. Create entry in `references/[CiteKey].md`
3. Take reading notes in `notes_zotero/[CiteKey]_notes.md`

**Example**: Reading Kallenberg (2021), Chapter 1

```markdown
# notes_zotero/Kal2021_notes.md

## Chapter 1: Measure Theory

### Page 10: σ-fields
- Definition of σ-field
- Must be closed under countable unions
- Must contain complement of each set
- Examples: {∅, S}, power set
- See [[Thm 1.1 - Monotone Class]]

TODO: Create atomic notes for:
- [ ] σ-field definition
- [ ] Examples of σ-fields
- [ ] Monotone Class Theorem
```

### Step 2: Extract Atomic Notes

**From reading notes, create atomic notes**:

#### Creating a Definition Note

1. **Open template**: `Ctrl/Cmd + T` → Select `definition.md`
2. **Fill in metadata**:
   ```markdown
   ---
   aliases:
     - σ-algebra
   type: definition
   created: 2026-01-29 17:19:57
   edited: 2026-01-29
   ---
   ```

3. **Write definition**:
   ```markdown
   ## Definition ([[Kal2021]], pg. 10): σ-field
   
   A σ-field in $S$ is a nonempty collection $\mathcal{S}$ 
   of subsets of $S$ closed under:
   1. Countable union: If $A_1, A_2, \ldots \in \mathcal{S}$, 
      then $\cup_{k=1}^{\infty} A_k \in \mathcal{S}$
   2. Complementation: If $A \in \mathcal{S}$, then 
      $A^c \in \mathcal{S}$
   
   In particular, $S$ and $\emptyset$ belong to every σ-field.
   ```

4. **Add examples and links**:
   ```markdown
   ## Examples
   - [[Example - {∅, S} is a σ-field]]
   - [[Example - power set is a σ-field]]
   
   ## Counter-Examples
   - [[Counter Example - union of σ-fields might not be σ-field]]
   
   ## Notes
   - Used to define [[measurable space]]
   - Related: [[Borel σ-field]], [[topology]]
   ```

5. **Save** to `notes_atomic/σ-field.md`

#### Creating a Theorem Note

```markdown
# Thm 1.1 (Kal2021, pg. 10) - Monotone Class.md
---
type: theorem
created: 2026-01-30 10:22:15
edited: 2026-01-30
---
## Theorem 1.1 ([[Kal2021]], pg. 10): Monotone Class

Let $\mathcal{A}$ be a [[π-system]] on $S$, and let 
$\mathcal{M}$ be a [[monotone class]] containing $\mathcal{A}$. 
Then $\sigma(\mathcal{A}) \subseteq \mathcal{M}$.

### Proof

[Proof content]

### Corollary

If $\mathcal{M}$ is both a monotone class and a π-system, 
then $\mathcal{M}$ is a [[σ-field]].
```

#### Creating an Example Note

```markdown
# Example - {∅, S} is a σ-field.md
---
type: example
created: 2026-01-29 18:45:22
edited: 2026-01-29
---
## Example ([[Kal2021]], pg. 10): Trivial σ-field

The collection $\{\emptyset, S\}$ is a [[σ-field]] on $S$.

### Verification

1. **Non-empty**: Contains $\emptyset$ and $S$
2. **Closed under complement**: 
   - $\emptyset^c = S \in \{\emptyset, S\}$
   - $S^c = \emptyset \in \{\emptyset, S\}$
3. **Closed under countable union**: 
   - Any union of $\emptyset$ and $S$ is either $\emptyset$ or $S$

This is the smallest σ-field on any set $S$.
```

### Step 3: Add Visual Content

#### TikZ Diagrams

```markdown
## Visualization

` ` `tikz
\begin{document}
\begin{tikzpicture}
  % Venn diagram showing set operations
  \draw (0,0) circle (1cm) node {$A$};
  \draw (2,0) circle (1cm) node {$B$};
  \draw (-1,-2) rectangle (3,2);
  \node at (2.5,1.5) {$S$};
\end{tikzpicture}
\end{document}
` ` `
```

#### Images

```markdown
![Probability Space Diagram](graphics/diagrams/probability_space.svg)
```

### Step 4: Write Multiple Notes Per Session

**Efficient batch creation**:

```
Reading session (2 hours) →
  notes_zotero/Kal2021_notes.md (capture)
  ↓
Note creation session (1 hour) →
  notes_atomic/σ-field.md
  notes_atomic/measure.md
  notes_atomic/measurable space.md
  notes_atomic/Example - trivial σ-field.md
  notes_atomic/Thm 1.1 - Monotone Class.md
```

---

## Phase 2: Organize & Connect

### Step 1: Link Related Concepts

**While writing each note, create wikilinks**:

```markdown
A [[measurable space]] is a pair $(S, \mathcal{S})$ where:
- $S$ is a set
- $\mathcal{S}$ is a [[σ-field]] on $S$

This is the foundation for defining a [[measure space]].
```

**Obsidian automatically**:
- Creates bidirectional links
- Shows backlinks panel
- Updates graph view
- Suggests autocomplete

### Step 2: Use Graph View

**Access**: Click graph icon in left sidebar

**What it shows**:
- Nodes = notes
- Edges = wikilinks
- Clusters = related concepts

**Use cases**:
- Identify missing connections
- Find isolated notes
- Discover relationships
- Verify completeness of topic

### Step 3: Create Category Overview Notes

**Purpose**: High-level map of a topic area

```markdown
# vault_matter/categories/measure_theory.md

# Measure Theory Overview

## Core Concepts

### Basic Structures
- [[σ-field]] - Collections of measurable sets
- [[measurable space]] - Set with σ-field
- [[measure]] - Function assigning sizes
- [[measure space]] - Space with measure

### Advanced Topics
- [[Monotone Class Theorem]]
- [[π-system]] and [[λ-system]]
- [[Borel σ-field]]

## Key Theorems
1. [[Thm 1.1 - Monotone Class]]
2. [[Thm 2.10 - Monotone Class]]

## References
- [[Kal2021]] - Comprehensive treatment
- [[Bas2024]] - Modern approach
```

### Step 4: Regular Review

**Weekly review**:
1. Check for orphan notes (no incoming links)
2. Add missing examples
3. Link new notes to existing ones
4. Update category overviews
5. Move drafts from `notes_scrap/` to `notes_atomic/`

---

## Phase 3: Publish (Quarto)

### Step 1: Choose Output Type

**Website**: Multi-page documentation, study guides
```
Use: publishing/template_website/
```

**Book**: Long-form PDF or EPUB
```
Use: publishing/template_book/
```

**Presentation**: Slides for teaching
```
Use: publishing/template_presentation/
```

### Step 2: Copy and Configure Template

```bash
# Copy template
cd publishing/
cp -r template_website/ measure_theory_guide/
cd measure_theory_guide/

# Customize _quarto.yml
vim _quarto.yml
```

**Edit configuration**:
```yaml
website:
  title: "Measure Theory Study Guide"
  navbar:
    right:
      - icon: github
        href: https://github.com/username/measure-theory
  
  sidebar:
    contents:
      - text: "Home"
        href: index.qmd
      - section: "Chapter 1: σ-fields"
        contents:
          - text: "Basic Definitions"
            href: notes/chapter01/definitions.qmd
          - text: "Examples"
            href: notes/chapter01/examples.qmd
```

### Step 3: Create Quarto Documents

**Create chapter file**: `notes/chapter01/definitions.qmd`

```markdown
---
title: "Basic Definitions"
---

# Set Systems

This chapter introduces the fundamental algebraic structures 
used in measure theory.

## σ-fields

{{< atomic "../../../notes_atomic/σ-field.md" >}}

The concept of a σ-field is central to measure theory because 
it specifies which sets are "measurable."

### Examples

{{< atomic "../../../notes_atomic/Example - {∅, S} is a σ-field.md" >}}

{{< atomic "../../../notes_atomic/Example - power set is a σ-field.md" >}}

## Measurable Spaces

{{< atomic "../../../notes_atomic/measurable space.md" >}}

## Exercises

1. Prove that the intersection of σ-fields is a σ-field.
   
   {{< atomic "../../../notes_atomic/Prop - arbitrary intersection of σ-fields.md" "#Proof" >}}

2. Show that the union of σ-fields need not be a σ-field.
   
   {{< atomic "../../../notes_atomic/Counter Example - union of σ-fields.md" >}}
```

**Key features**:
- `{{< atomic "path" >}}` includes entire note
- `{{< atomic "path" "#Section" >}}` includes specific section
- Wikilinks in atomic notes → plain text in output
- TikZ diagrams → rendered SVG images

### Step 4: Preview and Iterate

```bash
# Start live preview
quarto preview
```

**Opens at**: `http://localhost:4200`

**Live reload**: Edit `.qmd` or atomic notes → page updates automatically

**Check**:
- ✅ Atomic notes render correctly
- ✅ Math equations display properly
- ✅ TikZ diagrams show as images
- ✅ Navigation works
- ✅ Styling looks good

### Step 5: Render Final Output

```bash
# Build website
quarto render

# Output location
ls _site/
# index.html, notes/chapter01/definitions.html, etc.
```

**Test locally**:
```bash
# Serve locally
cd _site/
python -m http.server 8000

# Open http://localhost:8000
```

### Step 6: Deploy

**GitHub Pages** (recommended):
```bash
quarto publish gh-pages
```

**Other options**:
- Netlify: `quarto publish netlify`
- Custom server: Upload `_site/` folder
- PDF: Already generated in `_site/`

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions.

---

## Complete Example

Let's walk through creating a complete mini-publication:

### Scenario

**Goal**: Create a study guide for Chapter 1 of Kallenberg's book

### Day 1: Reading and Capture (2 hours)

**Activity**: Read Chapter 1, take notes

```markdown
# notes_zotero/Kal2021_notes.md

## Chapter 1: Measure Theory

### Section 1.1: σ-fields
- Definition on page 10
- Examples: trivial, power set
- Proposition: intersection of σ-fields is σ-field
- Counter-example: union is NOT σ-field

### Section 1.2: Monotone Classes
- Monotone class definition
- π-system definition  
- Main theorem: Monotone Class Theorem (Thm 1.1)

TODO: Create atomic notes for all above concepts
```

### Day 2: Create Atomic Notes (1.5 hours)

**Created notes**:
```
notes_atomic/
├── σ-field.md (definition)
├── Example - trivial σ-field.md
├── Example - power set is σ-field.md
├── Prop - intersection of σ-fields.md
├── Counter Example - union of σ-fields.md
├── monotone class.md (definition)
├── π-system.md (definition)
└── Thm 1.1 - Monotone Class.md
```

**Total**: 8 atomic notes, well-linked

### Day 3: Build Study Guide (1 hour)

**Setup project**:
```bash
cd publishing/
cp -r template_website/ kallenberg_ch1/
cd kallenberg_ch1/
```

**Create structure**:
```
notes/
└── chapter01/
    ├── 01_sigma_fields.qmd
    ├── 02_examples.qmd
    ├── 03_monotone_class.qmd
    └── 04_exercises.qmd
```

**Write** `01_sigma_fields.qmd`:
```markdown
---
title: "σ-fields"
---

# Definition

{{< atomic "../../../notes_atomic/σ-field.md" >}}

# Key Properties

- Closed under countable unions
- Closed under complements
- Always contains $\emptyset$ and $S$

# Why do we care?

σ-fields specify which sets are "measurable" in measure theory...
```

**Write** `02_examples.qmd`:
```markdown
---
title: "Examples of σ-fields"
---

# Trivial σ-field

{{< atomic "../../../notes_atomic/Example - trivial σ-field.md" >}}

# Power set σ-field

{{< atomic "../../../notes_atomic/Example - power set is σ-field.md" >}}

# Non-example

{{< atomic "../../../notes_atomic/Counter Example - union of σ-fields.md" >}}
```

### Day 4: Preview and Publish (30 minutes)

```bash
# Preview
quarto preview
# Check everything looks good

# Render
quarto render

# Deploy to GitHub Pages
quarto publish gh-pages
```

**Result**: Professional study guide website at `username.github.io/kallenberg_ch1/`

### Total Time Investment

- Reading: 2 hours
- Note creation: 1.5 hours
- Publication: 1.5 hours
- **Total: 5 hours**

### Future Benefits

Those 8 atomic notes can now be reused in:
- A comprehensive measure theory textbook
- Lecture slides for teaching
- Blog posts on specific topics
- Exercise solutions
- Cheat sheets

**No rewriting needed** - just include them in new projects!

---

## Advanced Workflows

### Multi-Project Publishing

**Scenario**: Same atomic notes, multiple outputs

```
notes_atomic/σ-field.md (written once)
      ↓
├──→ website/study_guide.qmd
├──→ book/chapter01.qmd
├──→ presentation/lecture01.qmd
└──→ blog/what_is_sigma_field.qmd
```

**Implementation**:
```markdown
# All four files include the same atomic note

{{< atomic "../../notes_atomic/σ-field.md" >}}
```

### Selective Section Inclusion

**Scenario**: Include only specific sections

```markdown
# In presentation (brief)
{{< atomic "note.md" "#Definition" >}}

# In textbook (complete)
{{< atomic "note.md" >}}

# In exercises (just examples)
{{< atomic "note.md" "#Examples" >}}
```

### Progressive Disclosure

**Scenario**: Build up complexity over chapters

```markdown
# Chapter 1: Basic definition
{{< atomic "σ-field.md" "#Definition" >}}

# Chapter 3: Add examples
{{< atomic "σ-field.md" "#Definition" >}}
{{< atomic "σ-field.md" "#Examples" >}}

# Chapter 5: Complete treatment
{{< atomic "σ-field.md" >}}
```

### Collaborative Workflows

**Scenario**: Multiple people working on vault

```bash
# Person A: Creates atomic notes
git checkout -b feature/probability-theory
# Create notes in notes_atomic/
git commit -m "Add probability space notes"
git push

# Person B: Creates publication
git checkout -b feature/probability-website
cd publishing/probability_guide/
# Create .qmd files referencing Person A's notes
git commit -m "Add probability guide website"
git push

# Merge both
git checkout main
git merge feature/probability-theory
git merge feature/probability-website
```

---

## Best Practices

### Note Creation

✅ **DO**:
- Write atomic notes for permanent concepts
- Use templates consistently
- Link generously to related concepts
- Include examples and counter-examples
- Cite sources with page numbers

❌ **DON'T**:
- Put multiple concepts in one note
- Write notes that are too context-specific
- Skip linking to related concepts
- Forget to cite sources
- Use unclear or ambiguous names

### Publishing

✅ **DO**:
- Test with `quarto preview` before rendering
- Verify all atomic note paths are correct
- Check math rendering in browser
- Validate links and navigation
- Use relative paths for atomic notes

❌ **DON'T**:
- Modify atomic notes for specific publications
- Hard-code absolute paths
- Skip testing in browser
- Forget to gitignore `_site/`
- Publish without checking output

### Maintenance

✅ **DO**:
- Review and refactor notes regularly
- Keep notes_scrap/ clean
- Update category overviews
- Version control everything
- Document your customizations

❌ **DON'T**:
- Let drafts pile up indefinitely
- Ignore orphan notes
- Skip git commits
- Modify Lua filters without testing
- Forget to backup

### Organization

✅ **DO**:
- Use consistent naming conventions
- Follow folder structure guidelines
- Create category overview notes
- Use YAML frontmatter consistently
- Tag appropriately

❌ **DON'T**:
- Mix different types in same folder
- Use unclear file names
- Skip YAML metadata
- Create deeply nested structures
- Duplicate content

---

## Troubleshooting Common Workflows

### Problem: Atomic note doesn't render in Quarto

**Solutions**:
1. Check path is correct: `{{< atomic "path/to/note.md" >}}`
2. Verify note exists at that path
3. Check for YAML errors in atomic note
4. Look at Quarto build output for error messages

### Problem: Wikilinks show as [[text]] in output

**Solutions**:
1. Verify `obsidian-wikilinks.lua` is in filter list
2. Check filter path in `_quarto.yml`
3. Ensure filter comes before rendering

### Problem: TikZ diagrams don't render

**Solutions**:
1. Check LaTeX installation: `pdflatex --version`
2. Check Inkscape: `inkscape --version`
3. Verify `obsidian-tikz.lua` is before `danmackinlay/tikz`
4. Look at `.quarto/` folder for LaTeX errors

### Problem: Too many orphan notes

**Solutions**:
1. Use graph view to identify clusters
2. Create category overview notes with links
3. Add "See also" sections to related notes
4. Consider if notes are too granular

---

## Next Steps

- **[Deployment](DEPLOYMENT.md)**: Publish your Quarto output to the web
- **[Tools & Setup](TOOLS_AND_SETUP.md)**: Ensure tools are configured correctly
- **[Folder Structure](FOLDER_STRUCTURE.md)**: Understand vault organization
