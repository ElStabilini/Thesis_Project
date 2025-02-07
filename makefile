#------------------------------------------------------------------------------
# Primary source: .eps
# The script converts .eps files into .png and.pdf
#------------------------------------------------------------------------------

dir=.

note := main

tex_files := $(note).tex $(wildcard *.tex) 

pdfs := $(patsubst figures/eps/%.eps, figures/pdf/%.pdf, $(wildcard figures/eps/*.eps)) \
        $(patsubst figures/png/%.png, figures/pdf/%.pdf, $(wildcard figures/png/*.png))
pngs := $(patsubst figures/eps/%.eps, figures/png/%.png, $(wildcard figures/eps/*.eps)) \
        $(wildcard figures/png/*.png)
jpgs := $(patsubst figures/eps/%.eps, figures/jpg/%.jpg, $(wildcard figures/eps/*.eps ))

figures/pdf/%.pdf: figures/png/%.png
	convert $? $@

figures/pdf/%.pdf: figures/eps/%.eps
	ps2pdf -dEPSCrop $? $@

figures/png/%.png: figures/eps/%.eps
	convert -density 400 -depth 8 -quality 85 -trim $? $@

pdf: $(pdfs) 
png: $(pngs) 
jpg: $(jpgs) 

note: $(tex_files) pdf 
	if [ ! -d tmp ] ; then mkdir tmp ; fi ; \
	pdflatex -output-directory=tmp $(note).tex ; \
	if [ -f tmp/$(note).aux ]; then bibtex tmp/$(note); fi ; \
	pdflatex -output-directory=tmp $(note).tex ; \
	pdflatex -output-directory=tmp $(note).tex

all: pdf note
	echo $(pdfs)
	echo $?

.DEFAULT_GOAL := all