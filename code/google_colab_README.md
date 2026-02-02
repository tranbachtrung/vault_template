# Google Colab - Collaborative Notebooks

This directory contains Jupyter notebooks synced from Google Colab for collaborative computational work.

## Setup

### 1. Install Google Drive Desktop
- Download and install [Google Drive for Desktop](https://www.google.com/drive/download/)
- Sign in with your Google account

### 2. Mount This Folder to Google Drive
- Right-click this folder (`code/google_colab/`) in Finder
- Select "Make Available Offline" if using Drive Desktop streaming
- Or manually configure this path as a synced Drive folder

Alternatively, create a folder in Google Drive and sync it to this location:
1. Create a folder in Google Drive called `vault_colab`
2. Configure Drive Desktop to sync it to: `vault_template/code/google_colab/`

### 3. Create Project Folders
Organize notebooks by project:
```
google_colab/
├── project_alpha/
│   ├── analysis_01.ipynb
│   ├── experiments.ipynb
│   └── data/
├── project_beta/
│   └── modeling.ipynb
└── shared_research/
    └── exploratory.ipynb
```

### 4. Share with Collaborators
- Share individual project folders with collaborators in Google Drive
- Use Google Drive's sharing settings (per project)
- Collaborators can open `.ipynb` files directly in Google Colab

## Workflow

### Active Collaboration
1. Open notebooks in Google Colab from Google Drive
2. Use Colab's comment features for collaboration
3. Changes auto-sync to local vault via Drive Desktop
4. Work normally - no manual sync needed

### Extract Knowledge to Vault
- Manually extract key insights to atomic notes in `notes_atomic/`
- Create new concept notes for important discoveries
- Link between atomic notes using Obsidian's `[[wikilinks]]`

## Important Notes

- **Git Excluded**: This entire folder is gitignored
- **No Version Control**: Use Colab's revision history for notebook versions
- **Data Files**: Large data files in project folders are not tracked
- **Manual Process**: Knowledge transfer from notebooks to atomic notes is intentional and manual
