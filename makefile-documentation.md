# Makefile for LaTeX Document Compilation structure

## Overview

This Makefile handles:
- LaTeX document compilation with bibliography processing
- Automatic conversion of figures between different formats (EPS, PDF, PNG, JPG)
- Directory management and temporary file handling

## Structure and Components

### Directory Configuration
```makefile
dir := .
```
The current directory is assigned to the `dir` variable using immediate evaluation (`:=`).

### Base Name Configuration
```makefile
note := main
```
Defines the main LaTeX file name (without extension) that will be compiled.

### File Discovery
```makefile
tex_files := $(note).tex $(wildcard *.tex)
```
Uses GNU Make's `wildcard` function to find all `.tex` files in the directory.

### Figure Conversion Setup
```makefile
pdfs := $(patsubst figures/eps/%.eps, figures/pdf/%.pdf, $(wildcard figures/eps/*.eps)) \
        $(patsubst figures/png/%.png, figures/pdf/%.pdf, $(wildcard figures/png/*.png))
pngs := $(patsubst figures/eps/%.eps, figures/png/%.png, $(wildcard figures/eps/*.eps)) \
        $(wildcard figures/png/*.png)  
jpgs := $(patsubst figures/eps/%.eps, figures/jpg/%.jpg, $(wildcard figures/eps/*.eps))
```
Sets up pattern substitution for converting between different image formats.

### Figure Conversion Rules
```makefile
figures/pdf/%.pdf: figures/png/%.png
	convert $? $@

figures/pdf/%.pdf: figures/eps/%.eps
	ps2pdf -dEPSCrop $? $@

figures/png/%.png: figures/eps/%.eps
	convert -density 400 -depth 8 -quality 85 -trim $? $@
```
Defines rules for converting between different image formats using ImageMagick and ps2pdf.

### Phony Targets
```makefile
pdf: 
	@if [ -z "$(pdfs)" ]; then echo "No figures found. Skipping figure conversion."; else make $(pdfs); fi
png: $(pngs) 
jpg: $(jpgs) 
```
Convenience targets for generating all files of a specific type.

### Main Document Compilation
```makefile
note: $(tex_files)
	@if [ -z "$(pdfs)" ]; then echo "No figures to process."; fi
	if [ ! -d tmp ] ; then mkdir tmp ; fi ; \
	pdflatex -output-directory=tmp $(note).tex ; \
	if [ -f tmp/$(note).aux ]; then bibtex tmp/$(note); fi ; \
	pdflatex -output-directory=tmp $(note).tex ; \
	pdflatex -output-directory=tmp $(note).tex
```
Handles the full LaTeX compilation process, including:
1. Figure processing check
2. Temporary directory creation
3. Initial LaTeX pass
4. Bibliography processing with BibTeX
5. Additional LaTeX passes for reference resolution

### Default Target
```makefile
all: pdf note
	echo $(pdfs)
	echo $?

.DEFAULT_GOAL := all
```
Ensures all PDFs are generated before compiling the document.

## Special Variables and Symbols

| Symbol | Description |
|--------|-------------|
| `:=` | Immediate variable assignment |
| `$@` | The target file |
| `$?` | Dependencies newer than the target |
| `$<` | The first dependency |
| `%` | Wildcard in pattern rules |
| `@` | Prevents command from being printed |
| `-z` | Shell test for empty string |
| `\` | Line continuation character |

## Usage

1. Place your LaTeX main file (default: `main.tex`) in the same directory as the Makefile
2. Organize your figures in the appropriate directories:
   - `figures/eps/` for EPS files
   - `figures/png/` for PNG files
   - `figures/pdf/` for PDF files
   - `figures/jpg/` for JPG files
3. Run one of the following commands:
   - `make` or `make all` to compile everything
   - `make pdf` to convert figures to PDF
   - `make png` to convert figures to PNG
   - `make jpg` to convert figures to JPG
   - `make note` to compile the LaTeX document only

## Requirements

- LaTeX distribution (e.g., TexLive, MikTeX)
- ImageMagick for image conversion
- Ghostscript (for ps2pdf)
- Make utility
