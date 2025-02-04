#------------------------------------------------------------------------------
# Primary source: .eps
# The script converts .eps files into .png and.pdf
#------------------------------------------------------------------------------

dir=.                                                                                                                   #set current directory as root directory

note := main                                                                                                            #define the base name of the main LaTex file

tex_files := $(note).tex $(wildcard *.tex)                                                                              #$(wildcard *.tex) --> can be used to list all the .tex files in the directory 

pdfs := $(patsubst figures/eps/%.eps, figures/pdf/%.pdf, $(wildcard figures/eps/*.eps)) \
        $(patsubst figures/png/%.png, figures/pdf/%.pdf, $(wildcard figures/png/*.png))
pngs := $(patsubst figures/eps/%.eps, figures/png/%.png, $(wildcard figures/eps/*.eps)) \
        $(wildcard figures/png/*.png)  																					# Add PNGs that are already present
jpgs := $(patsubst figures/eps/%.eps, figures/jpg/%.jpg, $(wildcard figures/eps/*.eps ))
                                                                                                                        #Previous lines search for all .eps figures and creates respectively pdfs, pngs, jpgs

#More figure conversion
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

                                                                                                                        # TARGET DESCRIPTION:
                                                                                                                        #generate a target called `note` which depends on two things: the .files and the pdf target
                                                                                                                        # (so before compiling the LateX document it makes sure all the .eps figures are converted)
                                                                                                                        #then creates a tmp directory (if doesn not already exists)
                                                                                                                        #first compilation creates an .aux file (needed for citations and cross-references)
                                                                                                                        #if in the tmp folder exists the .aux fileruns bibtex
                                                                                                                        #runs pdflatex to correctly update figure numbers, references and citations
                                                                                                                        #runs the command again to finalize page numbers and references

all: pdf note
	echo $(pdfs)
	echo $?
                                                                                                                        #when launcing `make` executes the `pdf` and `note` target, then with echo prints the name of the generated pdfs
                                                                                                                        # `$?` expands the list of dependencies that are newer than the target (prints list of dependencies that caused the rule to run)
.DEFAULT_GOAL := all                                                                                                    #make runs `all` by default when launching make