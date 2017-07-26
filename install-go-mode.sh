#!/usr/bin/bash

set -e

go_mode_dir="${1}"
if [[ -z "${go_mode_dir}" ]]; then
    go_mode_dir="${HOME}/projects/go/go-mode"
    echo "No directory for go mode given, defaulting to ${go_mode_dir}"
fi

mkdir -p "$(dirname "${go_mode_dir}")"
git clone 'https://github.com/dominikh/go-mode.el' "${go_mode_dir}"

mkdir -p ~/emacs
cat <<EOF >~/emacs/go-mode.el
(add-to-list 'load-path "${go_mode_dir}")
(require 'go-mode-autoloads)
EOF
