#!/bin/sh
pdflatex --shell-escape main.tex
rm *.log main.aux main.out
xdg-open main.pdf
