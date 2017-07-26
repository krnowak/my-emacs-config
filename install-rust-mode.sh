#!/usr/bin/bash

set -e

rust_mode_dir="${1}"
if [[ -z "${rust_mode_dir}" ]]; then
    rust_mode_dir="${HOME}/projects/rust/rust-mode"
    echo "No directory for rust mode given, defaulting to ${rust_mode_dir}"
fi

mkdir -p "$(dirname "${rust_mode_dir}")"
git clone 'https://github.com/rust-lang/rust-mode.git' "${rust_mode_dir}"

mkdir -p ~/emacs
cat <<EOF >~/emacs/rust-mode.el
(add-to-list 'load-path "${rust_mode_dir}")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
EOF
