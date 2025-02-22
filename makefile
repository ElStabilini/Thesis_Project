# Default directory
dir=.

# Define the main document or chapter to compile
note := $(if $(CHAPTER),chapters/$(CHAPTER),main)

# Collect all tex files
tex_files := $(note).tex $(wildcard chapters/*.tex) cover.tex

# Only handle PNG images as final format
pngs := $(wildcard figures/png/*.png)

# Make sure output directories exist
$(shell mkdir -p figures/png tmp)

# Convert images to PNG format
png: $(pngs)

# Compile the document
note: $(tex_files) png
	pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=tmp $(note).tex
	if [ -f tmp/$(note).aux ] && [ -f bibliography.bib ]; then \
		bibtex tmp/$(note); \
		pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=tmp $(note).tex; \
	fi
	pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=tmp $(note).tex
	cp tmp/$(note).pdf .

# Main target - avoids recursive calls
all: note

# Compile a single chapter
chapter:
	@if [ -z "$(CHAPTER)" ]; then \
		echo "Error: Specify CHAPTER=name (without .tex)"; \
		exit 1; \
	fi
	@echo "Compiling chapter: $(CHAPTER).tex"
	@$(MAKE) note

# Clean generated files
clean:
	rm -rf tmp/*
	rm -f *.pdf
	rm -f figures/png/*.png
	rm -f *.log *.aux *.bbl *.blg *.out *.toc *.lof *.lot

.PHONY: all png note chapter clean
