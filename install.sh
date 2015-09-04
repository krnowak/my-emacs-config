#!/usr/bin/bash

set -e

d=$(dirname $0)
ed=~/.emacs.d

mkdir -p "${ed}/init-lisp" ~/emacs

for f in init.el init-lisp/load-directory.el
do
	o="${ed}/${f}"
	n="${d}/$(basename "${f}")"
	if test -e "${o}"
	then
		if cmp --silent "${o}" "${n}"
		then
			mv "${o}" "${o}.old"
		fi
	fi
	if test ! -e "${o}"
	then
		cp "${n}" "${o}"
	fi
done

for f in ~/.emacs ~/.emacs.el
do
	if test -f "${f}"
	then
		echo "${ed}/init.el is going to be ignored unless you remove/rename ${f}"
	fi
done
