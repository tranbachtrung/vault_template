# Deployment Guide

Complete guide to building Quarto projects locally and deploying them to GitHub Pages and other hosting platforms.

## Table of Contents

- [Overview](#overview)
- [Local Development](#local-development)
- [Building for Production](#building-for-production)
- [GitHub Pages Deployment](#github-pages-deployment)
- [Enabling GitHub Comments](#enabling-github-comments)
- [Alternative Hosting](#alternative-hosting)
- [Custom Domains](#custom-domains)
- [CI/CD Automation](#cicd-automation)
- [Troubleshooting](#troubleshooting)

---

## Overview

Quarto can render your atomic notes into static websites that can be hosted anywhere. This guide focuses on deployment strategies, with emphasis on GitHub Pages as the recommended free hosting solution.

**Deployment Options**:
- **GitHub Pages**: Free, integrated with Git, automatic builds
- **Netlify**: Free tier, drag-and-drop, custom domains
- **Vercel**: Fast, great for React/Next.js integration
- **Custom Server**: Full control, requires server management

---

## Local Development

### Start Development Server

```bash
cd publishing/template_website/  # or your project folder
quarto preview
```

**What happens**:
1. Quarto renders all `.qmd` files
2. Lua filters transform Obsidian syntax
3. Development server starts at `http://localhost:4200`
4. Browser opens automatically
5. Live reload on file changes

**Output**:
```
Preparing to preview
[1/8] index.qmd
[2/8] notes/chapter01/chapter01_notes.qmd
...
Watching files for changes
Browse at http://localhost:4200/
```

### Development Workflow

```bash
# Terminal 1: Keep preview running
quarto preview

# Terminal 2: Work on content
vim notes/chapter01/definitions.qmd
# Save → Browser auto-refreshes

# Edit atomic notes
vim ../../notes_atomic/σ-field.md
# Save → Browser auto-refreshes
```

**Key Points**:
- Changes to `.qmd` files trigger rebuild
- Changes to atomic notes trigger rebuild
- Changes to `_quarto.yml` trigger rebuild
- Changes to Lua filters trigger rebuild
- CSS/JS changes may need manual refresh

### Preview Settings

**Custom port**:
```bash
quarto preview --port 8080
```

**No browser**:
```bash
quarto preview --no-browser
```

**Specific file**:
```bash
quarto preview index.qmd
```

---

## Building for Production

### Full Site Build

```bash
cd publishing/template_website/
quarto render
```

**Output location**: `_site/` folder

**What's generated**:
```
_site/
├── index.html                    # Homepage
├── styles.css                    # Stylesheets
├── notes/
│   └── chapter01/
│       └── chapter01_notes.html
├── solutions/
│   └── chapter01/
│       └── chapter01_sols.html
├── references/
│   └── references.html
├── search.json                   # Search index
└── site_libs/                    # Dependencies
    ├── bootstrap/
    ├── quarto-html/
    └── katex/                    # Math rendering
```

### Build Options

**Clean build** (remove cache):
```bash
quarto render --clean
```

**Specific format**:
```bash
quarto render --to html
quarto render --to pdf
```

**Parallel rendering** (faster):
```bash
quarto render --parallel
```

### Verify Build

**Test locally**:
```bash
cd _site/
python -m http.server 8000

# Open browser to http://localhost:8000
```

**Check for issues**:
- ✅ All pages load correctly
- ✅ Navigation works
- ✅ Math equations render
- ✅ TikZ diagrams appear
- ✅ Search functionality works
- ✅ No 404 errors

---

## GitHub Pages Deployment

GitHub Pages is the recommended deployment method for Quarto projects. It's free, reliable, and integrates seamlessly with your Git workflow.

### Prerequisites

1. **GitHub Account**: Create at https://github.com
2. **Git Repository**: Project should be in a Git repo
3. **GitHub CLI** (optional but recommended):
   ```bash
   brew install gh
   gh auth login
   ```

### Method 1: Quarto Publish (Recommended)

**First-time deployment**:
```bash
cd publishing/template_website/
quarto publish gh-pages
```

**Interactive prompts**:
```
? Update site at https://username.github.io/repository/? (Y/n) › Yes
? Render site before publishing? (Y/n) › Yes

Rendering for publish:
[1/8] index.qmd
[2/8] notes/chapter01/chapter01_notes.qmd
...
Writing to gh-pages branch...
Deploying gh-pages branch...

Browse to https://username.github.io/repository/
```

**Subsequent updates**:
```bash
quarto publish gh-pages --no-prompt
```

**What this does**:
1. Renders your site to `_site/`
2. Creates/updates `gh-pages` branch
3. Pushes `_site/` contents to `gh-pages` branch
4. GitHub automatically serves from this branch

### Method 2: Manual GitHub Pages Setup

**Step 1: Build locally**
```bash
quarto render
```

**Step 2: Create gh-pages branch**
```bash
git checkout --orphan gh-pages
git rm -rf .
cp -r _site/* .
git add .
git commit -m "Deploy site"
git push -u origin gh-pages
git checkout main
```

**Step 3: Configure repository**
1. Go to repository on GitHub
2. Settings → Pages
3. Source: Deploy from branch
4. Branch: `gh-pages` / `(root)`
5. Save

**Step 4: Wait for deployment**
- Check Actions tab for build status
- Site available at `https://username.github.io/repository/`

### Method 3: GitHub Actions (Automatic)

**Create** `.github/workflows/quarto-publish.yml`:

```yaml
name: Render and Deploy Quarto Site

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    
    permissions:
      contents: write
    
    steps:
      - name: Check out repository
        uses: actions/checkout@v4
      
      - name: Set up Quarto
        uses: quarto-dev/quarto-actions/setup@v2
        with:
          version: 1.4.549
      
      - name: Install LaTeX
        run: |
          sudo apt-get update
          sudo apt-get install -y texlive-latex-base texlive-latex-extra
      
      - name: Install Inkscape
        run: |
          sudo apt-get install -y inkscape
      
      - name: Render Quarto Project
        run: |
          cd publishing/template_website
          quarto render
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./publishing/template_website/_site
```

**Commit and push**:
```bash
git add .github/workflows/quarto-publish.yml
git commit -m "Add GitHub Actions workflow"
git push
```

**What this does**:
- Automatically builds on every push to `main`
- Installs dependencies (Quarto, LaTeX, Inkscape)
- Renders the site
- Deploys to `gh-pages` branch
- No manual deployment needed!

**Enable in repository**:
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: `gh-pages` / `(root)`

### Repository Settings

**Public vs Private**:
- **Public repo**: Site automatically public
- **Private repo**: Need GitHub Pro or Team for Pages

**Repository name**:
- `username.github.io`: Site at `https://username.github.io/`
- `any-name`: Site at `https://username.github.io/any-name/`

**Base path** (for project sites):

In `_quarto.yml`:
```yaml
website:
  site-url: "https://username.github.io/repository"
```

---

## Alternative Hosting

### Netlify

**Advantages**:
- Free tier generous
- Drag-and-drop deployment
- Automatic HTTPS
- Custom domains easy
- Form handling

**Deployment**:

1. **Build locally**:
   ```bash
   quarto render
   ```

2. **Deploy via CLI**:
   ```bash
   npm install -g netlify-cli
   netlify login
   netlify deploy --dir=_site --prod
   ```

3. **Or via web**:
   - Go to https://netlify.com
   - New site from Git
   - Connect repository
   - Build command: `cd publishing/template_website && quarto render`
   - Publish directory: `publishing/template_website/_site`

**Custom domain**:
- Domain settings → Add custom domain
- Update DNS records as shown

### Vercel

**Advantages**:
- Fast CDN
- Great analytics
- Easy custom domains
- GitHub integration

**Deployment**:

1. **Install CLI**:
   ```bash
   npm install -g vercel
   ```

2. **Create** `vercel.json`:
   ```json
   {
     "buildCommand": "cd publishing/template_website && quarto render",
     "outputDirectory": "publishing/template_website/_site"
   }
   ```

3. **Deploy**:
   ```bash
   vercel --prod
   ```

### Custom Server

**Requirements**:
- Web server (Apache, Nginx)
- SSH access
- Domain name (optional)

**Deployment via rsync**:
```bash
# Build locally
quarto render

# Upload to server
rsync -avz --delete _site/ user@server.com:/var/www/html/
```

**Nginx configuration**:
```nginx
server {
    listen 80;
    server_name mysite.com;
    root /var/www/html;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

---

## Enabling GitHub Comments

GitHub-based comments allow readers to discuss your content directly on your website. The template uses **giscus**, which leverages GitHub Discussions to power comments.

### What is Giscus?

Giscus is a comments system powered by GitHub Discussions that:
- **Free and open source**: No cost, no ads
- **No tracking**: Privacy-friendly, GDPR compliant
- **GitHub integration**: Readers use their GitHub accounts
- **Markdown support**: Rich text, code blocks, LaTeX
- **Themeable**: Matches your site's light/dark mode
- **Easy moderation**: Manage via GitHub Discussions

### Prerequisites

1. **Public GitHub repository**: Your site must be in a public repo
2. **GitHub Discussions enabled**: Enable in repository settings
3. **Giscus app installed**: Install from GitHub Marketplace

### Step 1: Enable GitHub Discussions

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll to **Features** section
4. Check ☑️ **Discussions**
5. Click **Set up discussions**
6. GitHub creates initial discussion categories

### Step 2: Install Giscus App

1. Visit https://github.com/apps/giscus
2. Click **Install**
3. Choose **Only select repositories**
4. Select your study guide repository
5. Click **Install**
6. Authorize giscus to access your repository

### Step 3: Configure Giscus

1. Go to https://giscus.app
2. **Configuration page** will help you generate settings

**Fill in the form**:

**Repository** section:
```
Repository: username/repository
# Example: johndoe/math-study-guide
```

The site will verify:
- ✅ Repository is public
- ✅ giscus app is installed
- ✅ Discussions feature is enabled

**Page ↔️ Discussions Mapping**:
- Choose **pathname** (recommended)
- Comments are linked to page URL path

**Discussion Category**:
- Choose **General** or create new category "Comments"
- Recommended: Create **"Comments"** category for organization

**Features**:
- ✅ Enable reactions for the main post
- ✅ Place comment box above comments (or below if preferred)
- ✅ Load comments lazily (improves performance)

**Theme**:
- Choose **preferred_color_scheme** (auto-matches light/dark mode)

### Step 4: Get Configuration IDs

After filling the form, giscus will show a script tag. Extract these values:

```html
<script src="https://giscus.app/client.js"
        data-repo="username/repository"
        data-repo-id="R_kgDOHxample"         <!-- Copy this -->
        data-category="Comments"
        data-category-id="DIC_kwDOExample"   <!-- Copy this -->
        ...
</script>
```

**Copy**:
- `data-repo-id`: Something like `R_kgDOHxample`
- `data-category-id`: Something like `DIC_kwDOExample`

### Step 5: Update _quarto.yml

Open [`publishing/template_website/_quarto.yml`](../../publishing/template_website/_quarto.yml) and update the giscus configuration:

```yaml
format:
  html:
    # ... other settings ...
    comments:
      giscus:
        repo: "username/repository"          # Your GitHub username/repo
        repo-id: "R_kgDOHxample"            # From giscus.app
        category: "Comments"                 # Discussion category name
        category-id: "DIC_kwDOExample"      # From giscus.app
        mapping: "pathname"                  # Keep as pathname
        reactions-enabled: true              # Allow reactions
        loading: "lazy"                      # Lazy load for performance
        input-position: "top"                # Comment box position
        theme: "preferred_color_scheme"      # Auto light/dark mode
```

**Example** (filled in):
```yaml
format:
  html:
    comments:
      giscus:
        repo: "johndoe/math-study-guide"
        repo-id: "R_kgDOHxample123"
        category: "Comments"
        category-id: "DIC_kwDOExample456"
        mapping: "pathname"
        reactions-enabled: true
        loading: "lazy"
        input-position: "top"
        theme: "preferred_color_scheme"
```

### Step 6: Test Locally

```bash
cd publishing/template_website/
quarto preview
```

**Verify**:
1. Visit any page (e.g., a chapter notes page)
2. Scroll to bottom of page
3. You should see giscus comment box
4. **Note**: Comments won't fully work locally, need to deploy

### Step 7: Deploy

Deploy your site to see comments in action:

```bash
quarto publish gh-pages
```

Or push to trigger GitHub Actions if you have CI/CD set up.

### Step 8: Test Comments

1. Visit your deployed site
2. Navigate to any content page
3. Scroll to bottom
4. **Sign in with GitHub** (button appears)
5. Write a test comment
6. Comment appears on page AND in GitHub Discussions

### Customization Options

#### Disable Comments on Specific Pages

To disable comments on individual pages, add to the page's YAML frontmatter:

```yaml
---
title: "Privacy Policy"
comments: false
---
```

#### Change Comment Box Position

In `_quarto.yml`:
```yaml
input-position: "bottom"  # Comment box below existing comments
```

#### Different Discussion Categories

You can create separate categories for different content types:

```yaml
# In _quarto.yml - default for all pages
comments:
  giscus:
    category: "Comments"
    category-id: "DIC_kwDOGeneral"

# In specific page frontmatter
---
title: "Solutions Chapter 1"
comments:
  giscus:
    category: "Solutions Discussion"
    category-id: "DIC_kwDOSolutions"
---
```

#### Custom Themes

Match specific color schemes:

```yaml
theme: "light"           # Always light
theme: "dark"            # Always dark
theme: "dark_dimmed"     # GitHub dark dimmed
theme: "transparent_dark" # Transparent dark
```

### Managing Comments

**Via GitHub Discussions**:
1. Go to your repository
2. Click **Discussions** tab
3. Select **Comments** category
4. View, edit, or delete comments
5. Lock, close, or pin discussions
6. Mark as answered

**Moderation**:
- Block users via GitHub settings
- Hide comments marked as spam
- Delete inappropriate comments
- Edit comments if needed

**Notifications**:
- Get GitHub notifications for new comments
- Subscribe to specific discussion threads
- Configure notification preferences

### Troubleshooting

#### Comments Not Appearing

**Problem**: Giscus box doesn't show up

**Solutions**:
1. Verify repository is **public**
2. Check Discussions is enabled in repo settings
3. Confirm giscus app is installed
4. Verify `repo-id` and `category-id` are correct
5. Check browser console for errors
6. Clear browser cache

#### Wrong Theme

**Problem**: Comments don't match site theme

**Solution**: Use `preferred_color_scheme` in `_quarto.yml`:
```yaml
theme: "preferred_color_scheme"
```

#### Comments Load Slowly

**Problem**: Page loads slowly due to comments

**Solution**: Already configured with lazy loading:
```yaml
loading: "lazy"  # Only loads when user scrolls to comments
```

#### Can't Sign In

**Problem**: "Sign in with GitHub" button doesn't work

**Solutions**:
1. Allow popups in browser
2. Check GitHub is accessible (not blocked)
3. Try incognito mode
4. Verify giscus app permissions

#### Comments Appear on Wrong Pages

**Problem**: Comments from one page show on another

**Solution**: Use `pathname` mapping (already configured):
```yaml
mapping: "pathname"  # Each page path gets unique discussion
```

### Alternative: Utterances

If you prefer a lighter alternative, you can use **utterances** instead:

```yaml
format:
  html:
    comments:
      utterances:
        repo: "username/repository"
        issue-term: "pathname"
        theme: "github-light"
```

**Differences from giscus**:
- Uses GitHub **Issues** instead of Discussions
- Lighter weight, faster loading
- Less feature-rich (no reactions, categories)
- Simpler setup (no category-id needed)

### Privacy Considerations

**What data does giscus collect?**
- GitHub username (when signed in)
- Comment content
- Timestamp
- Page URL

**Where is data stored?**
- All in GitHub Discussions (your repository)
- No third-party servers
- You control all data

**GDPR Compliance**:
- Users must have GitHub account (GitHub's privacy policy applies)
- You control the data (stored in your repo)
- Users can delete their comments anytime

---

## Custom Domains

### GitHub Pages with Custom Domain

**Step 1: Buy domain** (from Namecheap, Google Domains, etc.)

**Step 2: Add CNAME to repository**

Create `_site/CNAME`:
```
mysite.com
```

Or in `_quarto.yml`:
```yaml
website:
  site-url: "https://mysite.com"
```

**Step 3: Configure DNS**

For apex domain (`mysite.com`):
```
A Record: @ → 185.199.108.153
A Record: @ → 185.199.109.153
A Record: @ → 185.199.110.153
A Record: @ → 185.199.111.153
```

For subdomain (`www.mysite.com`):
```
CNAME Record: www → username.github.io
```

**Step 4: Enable in GitHub**
1. Repository Settings → Pages
2. Custom domain: `mysite.com`
3. Save
4. Wait for DNS check
5. Enable "Enforce HTTPS"

**Wait time**: DNS propagation takes 24-48 hours

### Netlify Custom Domain

1. Site settings → Domain management
2. Add custom domain
3. Follow DNS configuration instructions
4. Netlify provides HTTPS automatically

---

## CI/CD Automation

### Full GitHub Actions Workflow

**Advanced configuration** (`.github/workflows/deploy.yml`):

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]
    paths:
      - 'notes_atomic/**'
      - 'publishing/template_website/**'
      - '.github/workflows/**'
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Quarto
        uses: quarto-dev/quarto-actions/setup@v2
      
      - name: Install system dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            texlive-latex-base \
            texlive-latex-extra \
            texlive-fonts-recommended \
            inkscape
      
      - name: Cache Quarto
        uses: actions/cache@v3
        with:
          path: ~/.cache/quarto
          key: ${{ runner.os }}-quarto-${{ hashFiles('**/lockfiles') }}
      
      - name: Render site
        run: |
          cd publishing/template_website
          quarto render --to html
      
      - name: Upload artifact
        if: github.event_name == 'push'
        uses: actions/upload-pages-artifact@v2
        with:
          path: publishing/template_website/_site
  
  deploy:
    needs: build
    if: github.event_name == 'push'
    runs-on: ubuntu-latest
    
    permissions:
      pages: write
      id-token: write
    
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

**Features**:
- Only builds when relevant files change
- Caches dependencies for faster builds
- Builds on PRs for testing
- Deploys only on push to main
- Uses official GitHub Pages action

### Pre-commit Hooks

**Install pre-commit**:
```bash
brew install pre-commit
```

**Create** `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: quarto-check
        name: Check Quarto syntax
        entry: quarto check
        language: system
        pass_filenames: false
      
      - id: markdown-lint
        name: Lint markdown files
        entry: markdownlint
        language: node
        files: \\.md$
```

**Install hooks**:
```bash
pre-commit install
```

**Now every commit**:
- Checks Quarto syntax
- Lints markdown files
- Prevents broken commits

---

## Troubleshooting

### Build Fails on GitHub Actions

**Problem**: Build succeeds locally but fails on GitHub

**Common causes**:
1. **Missing dependencies**: Add to workflow
   ```yaml
   - name: Install dependencies
     run: sudo apt-get install -y inkscape texlive
   ```

2. **Path issues**: Use relative paths
   ```yaml
   - name: Render
     run: cd publishing/template_website && quarto render
   ```

3. **Permissions**: Add to job
   ```yaml
   permissions:
     contents: write
     pages: write
   ```

### Site Doesn't Update

**Problem**: Pushed changes but site shows old version

**Solutions**:
1. Check Actions tab for build status
2. Clear browser cache (Cmd+Shift+R)
3. Wait 1-2 minutes for CDN to update
4. Verify `gh-pages` branch updated
5. Check GitHub Pages settings are correct

### Custom Domain Not Working

**Problem**: Custom domain shows 404 or doesn't load

**Solutions**:
1. Verify DNS records with `dig mysite.com`
2. Wait 24-48 hours for DNS propagation
3. Check CNAME file in repository
4. Disable and re-enable custom domain in settings
5. Clear DNS cache: `sudo dscacheutil -flushcache`

### TikZ Diagrams Missing in Deployed Site

**Problem**: TikZ renders locally but not on GitHub Pages

**Solutions**:
1. Install LaTeX in CI workflow
2. Install Inkscape in CI workflow
3. Check build logs for pdflatex errors
4. Verify `danmackinlay/tikz` extension installed
5. Check file permissions on generated SVGs

### Large Repository Size

**Problem**: Repository exceeds GitHub size limits

**Solutions**:
1. Gitignore `_site/` and `_quarto/`
2. Use Git LFS for large PDFs/images
3. Clean git history:
   ```bash
   git filter-branch --tree-filter 'rm -rf _site' HEAD
   ```
4. Consider separate repository for site

### 404 on Subpages

**Problem**: Homepage works, but `/notes/chapter01` gives 404

**Solutions**:
1. Check `_quarto.yml` site-url includes repo name
2. Verify all links are relative
3. Check file structure matches navbar/sidebar
4. Rebuild with `--clean` flag

---

## Performance Optimization

### Build Speed

**Cache dependencies**:
```yaml
- uses: actions/cache@v3
  with:
    path: ~/.cache/quarto
    key: quarto-${{ hashFiles('**/*.qmd') }}
```

**Parallel rendering**:
```bash
quarto render --parallel
```

**Incremental builds**:
```bash
# Only rebuild changed files
quarto render --incremental
```

### Site Performance

**Optimize images**:
```bash
# Compress PNGs
optipng graphics/*.png

# Compress JPGs
jpegoptim graphics/*.jpg
```

**Minify CSS**:
```yaml
format:
  html:
    css: styles.min.css
```

**Enable CDN** (in `_quarto.yml`):
```yaml
format:
  html:
    html-math-method: 
      method: katex
      url: https://cdn.jsdelivr.net/npm/katex@0.16.0/dist/
```

---

## Monitoring

### GitHub Pages Status

**Check deployment**:
1. Repository → Actions tab
2. View workflow runs
3. Check deployment status
4. Review build logs

**Enable notifications**:
- Settings → Notifications
- Watch: Releases only
- Get emailed on build failures

### Analytics

**Google Analytics**:

In `_quarto.yml`:
```yaml
website:
  google-analytics: "G-XXXXXXXXXX"
```

**Plausible Analytics** (privacy-friendly):
```yaml
website:
  head: |
    <script defer data-domain="mysite.com" 
            src="https://plausible.io/js/script.js"></script>
```

---

## Summary

**Local development**:
```bash
quarto preview
```

**Build and test**:
```bash
quarto render
cd _site && python -m http.server 8000
```

**Deploy to GitHub Pages**:
```bash
quarto publish gh-pages --no-prompt
```

**Automate with GitHub Actions**:
- Create workflow file
- Push to repository
- Automatic builds on every commit

**Custom domain**:
- Add CNAME file
- Configure DNS
- Enable in GitHub settings

---

## Next Steps

- **[Workflow](WORKFLOW.md)**: Learn the complete note-taking process
- **[Tools & Setup](TOOLS_AND_SETUP.md)**: Configure development environment
- **[Folder Structure](FOLDER_STRUCTURE.md)**: Understand vault organization
