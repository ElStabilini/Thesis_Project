# Default directory
dir=.

# Define the main document or chapter to compile
note := $(if $(CHAPTER),chapters/$(CHAPTER),main)

# Collect all tex files
tex_files := $(note).tex $(wildcard chapters/*.tex) cover.tex

# Compile the document
note: $(tex_files) png
	pdflatex -halt-on-error -file-line-error -output-directory=tmp $(note).tex
	if [ -f tmp/$(note).bcf ] && [ -f bibliography.bib ]; then \
		biber --output-directory=tmp tmp/$(note); \
		pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=tmp $(note).tex; \
	fi
	pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=tmp $(note).tex
	cp tmp/$(note).pdf .

# Main target - avoids recursive calls
all: note

# Compile a single chapter
chapter:
	if [ -z "$(CHAPTER)" ]; then \
		echo "Error: Specify CHAPTER=name (without .tex)"; \
		exit 1; \
	fi
	echo "Compiling chapter: $(CHAPTER).tex"
	$(MAKE) note

# Clean generated files
clean:
	rm -rf tmp/*
	rm -f main.pdf main_backup.pdf
	rm -f *.log *.aux *.bbl *.blg *.out *.toc *.lof *.lot *.bcf *.run.xml

.PHONY: all png note chapter clean