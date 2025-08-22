#!/usr/bin/env python3
import os
import sys
from pathlib import Path

try:
    import yaml  # type: ignore
except Exception as e:
    print("This script requires PyYAML. Install with: pip install pyyaml")
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]

COURSE_SUBDIRS = ["notes", "assignments", "projects", "exam", "resources"]
THESIS_EXTRA = [
    "data/raw",
    "data/processed",
    "notebooks",
    "src",
    "writing",
    "references",
    "figures",
]

COURSE_README_TEMPLATE = """# {code} — {name}

- Year: {year}
- Semester: {term}
- Program: Economics with Data Science (UiT)
- Language: English (repo content)

## Overview
Short description of the course, learning goals, and how this folder is organized.

## External resources
- Official course page: (add link)
- Public GitHub repos (add links here or add them as submodules under resources/external):
  - …

## Plan
- Notes: key concepts and summaries
- Assignments: problem sets and solutions
- Projects: course projects
- Exam: past exams (if allowed), prep notes, solutions
- Resources: datasets, readings, references

## Setup
- Python version / environment (if relevant)
- Dependencies (if relevant)
"""

EXCHANGE_README = """# Exchange — Waseda University

- Year: {year}
- Semester: {term}
- Provider: Waseda University

## Courses taken
List the courses taken abroad and their UiT equivalences. Include syllabi and grade documentation.

## Resources
- syllabi/
- coursework/
- transfer-credits/

## Notes
Keep any mapping/approval documentation required by UiT.
"""

THESIS_README = """# {code} — {name}

- Year: {year}
- Semester: {term}
- Program: Economics with Data Science (UiT)

## Overview
Use this folder to manage your bachelor thesis in a reproducible way.

## Structure
- data/raw: immutable, original data
- data/processed: cleaned/derived data
- notebooks: exploratory analysis
- src: reusable analysis code
- writing: manuscript (LaTeX/Word)
- references: bibliography, citation files
- figures: generated figures

## Research log
- Topic, research questions, methodology, datasets, timeline.

## Reproducibility
Document environment, versions, and steps to reproduce results.
"""

def slugify_code(code: str) -> str:
    return code.strip().upper()

def ensure_file(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text(content, encoding="utf-8")
        print(f"Created: {path}")
    else:
        print(f"Exists:  {path}")

def touch_gitkeep(dir_path: Path):
    dir_path.mkdir(parents=True, exist_ok=True)
    keep = dir_path / ".gitkeep"
    if not keep.exists():
        keep.write_text("", encoding="utf-8")

def load_curriculum():
    with open(ROOT / "curriculum.yaml", "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def create_course(year: int, term: int, code: str, name: str, thesis: bool = False):
    code_dir = slugify_code(code)
    base = ROOT / f"year-{year}" / f"semester-{term}" / code_dir
    base.mkdir(parents=True, exist_ok=True)

    # README
    if thesis:
        readme = THESIS_README.format(code=code_dir, name=name, year=year, term=term)
    else:
        readme = COURSE_README_TEMPLATE.format(code=code_dir, name=name, year=year, term=term)
    ensure_file(base / "README.md", readme)

    # Subdirs
    for sub in COURSE_SUBDIRS:
        d = base / sub
        touch_gitkeep(d)

    # Thesis extras
    if thesis:
        for sub in THESIS_EXTRA:
            d = base / sub
            touch_gitkeep(d)

    # resources/external placeholder
    external = base / "resources" / "external"
    touch_gitkeep(external)

def create_exchange(year: int, term: int, provider: str, code: str):
    base = ROOT / f"year-{year}" / f"semester-{term}" / code.lower().replace(" ", "-")
    base.mkdir(parents=True, exist_ok=True)
    ensure_file(base / "README.md", EXCHANGE_README.format(year=year, term=term))
    for sub in ["syllabi", "coursework", "transfer-credits"]:
        touch_gitkeep(base / sub)

def main():
    data = load_curriculum()
    for y in data.get("years", []):
        year = y["year"]
        for s in y.get("semesters", []):
            term = s["term"]
            # Exchange entry
            if "exchange" in s and s["exchange"]:
                ex = s["exchange"]
                create_exchange(year, term, ex.get("provider", "Exchange"), ex.get("code", "EXCHANGE"))
            # Courses
            for c in s.get("courses", []):
                code = c["code"]
                name = c.get("name", "")
                thesis = (slugify_code(code) == "SOK-2209")
                create_course(year, term, code, name, thesis=thesis)
    print("Done.")

if __name__ == "__main__":
    main()