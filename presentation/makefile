# === CONFIGURATION ===

# Main presentation file (without .tex extension)
MAIN := presentation

# Output and temporary directory
OUTDIR := tmp

# Source directories
FIGDIR := images

# Bibliography file
BIBFILE := bibliography.bib

# Files to watch for changes
TEX_SRCS := $(MAIN).tex $(wildcard $(FIGDIR)/*) $(wildcard *.sty) colors.tex

# === TARGETS ===

all: $(MAIN).pdf

# Build the PDF
$(MAIN).pdf: $(TEX_SRCS)
	mkdir -p $(OUTDIR)
	pdflatex -halt-on-error -file-line-error -output-directory=$(OUTDIR) $(MAIN).tex
ifneq ("$(wildcard $(BIBFILE))","")
	if [ -f $(OUTDIR)/$(MAIN).bcf ]; then \
		biber --output-directory=$(OUTDIR) $(OUTDIR)/$(MAIN); \
		pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=$(OUTDIR) $(MAIN).tex; \
	fi
endif
	pdflatex -interaction=batchmode -halt-on-error -file-line-error -output-directory=$(OUTDIR) $(MAIN).tex
	cp $(OUTDIR)/$(MAIN).pdf .

# Clean auxiliary files
clean:
	rm -rf $(OUTDIR)
	rm -f $(MAIN).pdf

.PHONY: all clean