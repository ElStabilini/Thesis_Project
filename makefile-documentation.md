# LaTeX Document Compilation Makefile

## Overview
This Makefile automates the compilation process of LaTeX documents, handling both complete documents and individual chapters. It manages the compilation workflow and coordinates bibliography processing when needed.

## Prerequisites
- A LaTeX distribution (e.g., TeX Live, MiKTeX)
- `pdflatex` command-line tool
- `biber` for bibliography processing
- Basic Unix tools (`cp`, `rm`, etc.)

## Variables
- `dir`: Default working directory (set to current directory)
- `note`: Main document to compile (either `main.tex` or a specific chapter)
- `tex_files`: All TeX files needed for compilation, including main document, chapters, and cover

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
1. Runs pdflatex for initial compilation
2. Processes bibliography with biber if present
3. Runs additional pdflatex passes for references
4. Copies the final PDF to the root directory

### `chapter`
```bash
make chapter CHAPTER=chapter_name
```
Compiles a single chapter from the `chapters/` directory.
- `CHAPTER` parameter should be specified without the `.tex` extension
- Outputs the compiled chapter as a standalone PDF

### `clean`
```bash
make clean
```
Removes all generated files:
- Temporary build files in `tmp/`
- Generated PDFs
- LaTeX auxiliary files (`.aux`, `.log`, `.bbl`, etc.)

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
- The Makefile uses a `tmp/` directory for temporary build files
- Bibliography compilation is optional and only runs if `bibliography.bib` exists
- The compilation process uses batch mode with error checking for subsequent passes
- Final PDFs are copied to the root directory for easy access
