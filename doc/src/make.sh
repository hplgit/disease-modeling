#!/bin/sh
set -x

function system {
  "$@"
  if [ $? -ne 0 ]; then
    echo "make.sh: unsuccessful command $@"
    echo "abort!"
    exit 1
  fi
}

name=disease_modeling
opt="--encoding=utf-8"

html=${name}-reveal
system doconce format html $name --pygments_html_style=native --keep_pygments_html_bg --html_links_in_new_window --html_output=$html $opt
system doconce slides_html $html reveal --html_slide_theme=darkgray
doconce replace 'pre style="' 'pre style="font-size: 80%; ' $html.html

html=${name}-reveal-beige
system doconce format html $name --pygments_html_style=perldoc --keep_pygments_html_bg --html_links_in_new_window --html_output=$html $opt
system doconce slides_html $html reveal --html_slide_theme=beige
doconce replace 'pre style="' 'pre style="font-size: 80%; ' $html.html

# LaTeX Beamer slides
beamertheme=red_shadow
system doconce format pdflatex $name --latex_title_layout=beamer $opt
system doconce ptex2tex $name envir=minted
system doconce slides_beamer $name --beamer_slide_theme=$beamertheme
cp $name.tex ${name}-beamer-${beamertheme}.tex
system pdflatex -shell-escape ${name}-beamer-$beamertheme

html=${name}-reveal-white
system doconce format html $name --pygments_html_style=default --keep_pygments_html_bg --html_links_in_new_window --html_output=$html $opt
system doconce slides_html $html reveal --html_slide_theme=simple
doconce replace 'pre style="' 'pre style="font-size: 80%; ' $html.html

html=${name}-deck
system doconce format html $name --pygments_html_style=perldoc --keep_pygments_html_bg --html_links_in_new_window --html_output=$html $opt
system doconce slides_html $html deck --html_slide_theme=sandstone.default

# Plain HTML documents
html=${name}-solarized
system doconce format html $name --pygments_html_style=perldoc --html_style=solarized3 --html_links_in_new_window --html_output=$html $opt
#system doconce slides_html $html doconce

# Publish
cp -r *.html .*.html *.pdf *.js fig ../pub
exit

html=${name}-plain
system doconce format html $name --pygments_html_style=default --html_style=bloodish --html_links_in_new_window --html_output=$html $opt
system doconce split_html $html.html
# Remove top navigation in all parts
doconce subst -s '<!-- begin top navigation.+?end top navigation -->' '' ${name}-plain.html ._${name}*.html

# One big HTML file with space between the slides
html=${name}-1
system doconce format html $name --html_style=bloodish --html_links_in_new_window --html_output=$html $opt
# Add space between splits
system doconce split_html $name --method=space8

# LaTeX documents
system doconce format pdflatex $name --minted_latex_style=trac $opt
system doconce ptex2tex $name envir=minted
doconce replace 'section{' 'section*{' $name.tex
system pdflatex -shell-escape $name
mv -f $name.pdf ${name}-minted.pdf
cp $name.tex ${name}-minted.tex
