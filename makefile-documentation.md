# LaTeX Makefile Documentation

## Overview
This Makefile automates the compilation process of LaTeX documents, handling both complete documents and individual chapters. It manages PNG images and coordinates the compilation of bibliography when needed.

## Prerequisites
- A LaTeX distribution (e.g., TeX Live, MiKTeX)
- `pdflatex` command-line tool
- `bibtex` for bibliography processing

## Directory Structure
```
.
├── main.tex           # Main LaTeX document
├── chapters/          # Directory containing chapter files
├── figures/
│   └── png/          # PNG images
├── tmp/              # Temporary build files
├── bibliography.bib  # Bibliography file (optional)
└── cover.tex         # Cover page template
```

## Variables
- `dir`: Default working directory (set to current directory)
- `note`: Main document to compile (either `main.tex` or a specific chapter)
- `tex_files`: All TeX files needed for compilation
- `pngs`: List of PNG image files in the figures/png directory

## Main Targets

### `all` (Default)
```bash
make
# or
make all
```
Compiles the complete document by calling the `note` target.

### `note`
```bash
make note
```
Primary compilation target that:
1. Ensures PNG images are available
2. Runs pdflatex for initial compilation
3. Processes bibliography if present
4. Runs additional pdflatex passes for references
5. Copies the final PDF to the root directory

### `chapter`
```bash
make chapter CHAPTER=chapter_name
```
Compiles a single chapter from the `chapters/` directory.
- `CHAPTER` parameter should be specified without the `.tex` extension
- Outputs the compiled chapter as a standalone PDF

### `png`
```bash
make png
```
Ensures PNG images are available in `figures/png/`.

### `clean`
```bash
make clean
```
Removes all generated files:
- Temporary build files in `tmp/`
- Generated PDFs
- PNG images in figures/png
- LaTeX auxiliary files (`.aux`, `.log`, etc.)

## Example Usage

1. Compile full document:
```bash
make
```

2. Compile specific chapter:
```bash
make chapter CHAPTER=introduction
```

3. Clean all generated files:
```bash
make clean
```

## Notes
- The Makefile automatically creates necessary directories (`figures/png/` and `tmp/`)
- Bibliography compilation is optional and only runs if `bibliography.bib` exists
- The compilation process uses batch mode with error checking
- Final PDFs are copied to the root directory for easy access
- Unlike the previous version, this Makefile does not handle EPS to PNG conversion
