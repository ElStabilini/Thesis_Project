# Beamer Presentation Makefile Documentation

This Makefile builds a LaTeX Beamer presentation, with optional bibliography support and automatic handling of figures and temporary build files.

## Directory Structure

An example project layout:

```
project/
├── main.tex
├── bibliography.bib # Optional
├── figures/
│ ├── fig1.pdf
│ └── fig2.png
├── tmp/ # Temporary build output
├── Makefile
```

## Targets

### `make` or `make all`

Compiles the presentation from `main.tex` into `main.pdf`.

Build steps:
- Runs `pdflatex` to generate auxiliary files
- If `bibliography.bib` exists and `main.bcf` is generated:
  - Runs `biber` to process bibliography
  - Re-runs `pdflatex` to resolve citations
- Final output `main.pdf` is copied to the project root

### `make clean`

Removes all generated output:
- Deletes the `tmp/` directory
- Deletes `main.pdf` and other LaTeX auxiliary files

## Variables

The following Makefile variables control the build process:

| Variable    | Description                                 |
|-------------|---------------------------------------------|
| `MAIN`      | Name of the main `.tex` file (no extension) |
| `OUTDIR`    | Directory used for intermediate files        |
| `FIGDIR`    | Directory containing figure assets           |
| `BIBFILE`   | Bibliography file used with Biber            |

## Including a Bibliography in the Presentation

To include references in your Beamer presentation, add the following frame to `main.tex`:

```latex
\begin{frame}[allowframebreaks]{References}
    \bibliographystyle{plain}
    \bibliography{bibliography}
\end{frame}
```