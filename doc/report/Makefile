latex:
	mkdir -p out
	# cd src && lualatex -shell-escape --output-directory ../out main
	# cd src && bibtex main
	cd src && lualatex -shell-escape --output-directory ../out main
	cd src && lualatex -shell-escape --output-directory ../out main
	mv out/main.pdf informe.pdf
	rm -rf out

watch:
	fswatch -e ".*" -i "\.tex" -o ./ | xargs -n1 -I{} make latex
