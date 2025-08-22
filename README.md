# UiT Bachelor Portfolio — Economics with Data Science

This repository organizes my bachelor studies at UiT (program: “Samfunnsøkonomi med Datavitenskap”) in a clean, consistent folder layout by year, semester, and course. Content and docs are in English.

<!-- toc -->
- [Overview](#overview)
- [Study plan](#study-plan)
- [Getting started](#getting-started)
- [Folder layout conventions](#folder-layout-conventions)
- [Link/import existing public GitHub course repos](#linkimport-existing-public-github-course-repos)
- [Exchange semester (Waseda)](#exchange-semester-waseda)
- [Bachelor thesis (SOK-2209)](#bachelor-thesis-sok-2209)
- [Auto-generated Table of Contents](#auto-generated-table-of-contents)
<!-- tocstop -->

## Overview
- Program (nb): Samfunnsøkonomi med Datavitenskap
- Program (en): Economics with Data Science
- University: UiT The Arctic University of Norway
- Language: English (files, READMEs)

## Study plan
Year 1
- Semester 1: SOK-1003 (Python-lab), SOK-1004 (Økonomiske emner og programmering), BED-1007 (Matematikk for økonomer)
- Semester 2: SOK-1016 (Makroøkonomi), SOK-1006 (Mikroøkonomi), SOK-1005 (Datavitenskap for økonomer)

Year 2
- Semester 3: SOK-2008 (Den Nordiske Modellen), SOK-2009 (Statistikk for økonomer)
- Semester 4: SOK-2012 (Økonomiske insentiver), SOK-2030 (Næringsøkonomi og konkurransestrategi), SOK-2011 (Økonomisk vekst og bærekraftig utvikling)

Year 3
- Semester 5: Exchange — Waseda University
- Semester 6: FIL-0700 (Ex.phil), SOK-2209 (Bacheloroppgave i samfunnsøkonomi)

## Getting started
1) Generate the folder structure from the curriculum file:
   - Ensure you have Python 3.9+ installed
   - Optional: create a virtual environment
   - Run:
     ```bash
     python3 scripts/generate_structure.py
     ```
   This will create folders like:
   - year-1/semester-1/SOK-1003, SOK-1004, BED-1007
   - year-1/semester-2/SOK-1016, SOK-1006, SOK-1005
   - …
   Each course folder contains standard subfolders: notes, assignments, projects, exam, resources.

2) Commit the generated structure:
   ```bash
   git add -A
   git commit -m "Generate bachelor structure from curriculum.yaml"
   ```

## Folder layout conventions
- Root:
  - year-{1..3}/semester-{1..6}/COURSE-CODE/
  - scripts/ — utilities to manage the repo structure
  - curriculum.yaml — single source of truth for courses per semester
  - .github/workflows/ — CI (e.g., auto TOC)
- Each course folder:
  - README.md — course overview (code, title, links, plan)
  - notes/ — lecture notes, summaries
  - assignments/ — problem sets, solutions
  - projects/ — course projects
  - exam/ — exam prep, past exams (if allowed), solutions
  - resources/ — readings, datasets (ensure licensing), and links to external repos
- Thesis (SOK-2209) includes a richer structure: data/, notebooks/, src/, writing/, references/, figures/.

## Link/import existing public GitHub course repos
You mentioned you have existing public GitHub repos for some courses. Two good options:

- A) Submodules (recommended): keep the external repos as submodules inside the corresponding course folder.
  ```bash
  ./scripts/add-submodule.sh year-1/semester-1/SOK-1003 https://github.com/owner/course-repo.git
  ```
  This will create: year-1/semester-1/SOK-1003/resources/external/course-repo (as a submodule).

- B) Links: add links in each course’s README under “External resources”.

Note: When using submodules, remember to commit the updated .gitmodules and submodule entry:
```bash
git add .gitmodules year-1/semester-1/SOK-1003/resources/external/course-repo
git commit -m "Add submodule for SOK-1003 external repo"
```

## Exchange semester (Waseda)
Path: year-3/semester-5/exchange-waseda

Use the README there to:
- List courses taken at Waseda and their UiT equivalences
- Keep syllabi, coursework, and transfer credit documentation
- Link to any Waseda course repos (as submodules or links)

## Bachelor thesis (SOK-2209)
A dedicated structure is created to keep research reproducible:
- data/raw, data/processed
- notebooks, src
- writing (LaTeX/Word), references, figures

## Auto-generated Table of Contents
A GitHub Actions workflow keeps the Table of Contents up to date for README files on push/PR. No manual maintenance needed.