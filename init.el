;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(font-use-system-font t)
 '(safe-local-variable-values
   '((diff-update-on-the-fly)
     (js2-basic-offset . 4)
     (c-file-offsets
      (innamespace . 0)
      (substatement-open . 0)
      (brace-list-open . 0))
     (c-file-offsets
      (innamespace . 0)
      (substatement-open . 0))
     (eval progn
           (c-set-offset 'innamespace '0)
           (c-set-offset 'inline-open '0))
     (c-set-offset 'innamespace 0)
     (c-file-offsets
      (innamespace . 0)))))

(setq line-number-mode 1)
(setq column-number-mode 1)

(require 'whitespace)
(setq whitespace-style
  '(face empty tabs trailing))
(setq whitespace-global-modes t)
(global-whitespace-mode 1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(use-package better-defaults
  :ensure t
  :demand t
  :config
  (require 'better-defaults))
(use-package glsl-mode
  :ensure t)
(use-package go-mode
  :ensure t)
(use-package meson-mode
  :ensure t)
(use-package odin-ts-mode
  :vc (:url "https://github.com/krnowak/odin-ts-mode.git"
            :branch "krnowak/all-fixes")
  :mode "\\.odin\\'")
(use-package rust-mode
  :ensure t)

(require 'treesit)
(dolist (grammar '((bash . ("https://github.com/tree-sitter/tree-sitter-bash" "v0.25.0"))
                   (c . ("https://github.com/tree-sitter/tree-sitter-c" "v0.24.1"))
                   (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4"))
                   (elisp . ("https://github.com/Wilfred/tree-sitter-elisp" "1.5.0"))
                   (glsl . ("https://github.com/tree-sitter-grammars/tree-sitter-glsl" "v0.2.0"))
                   (go . ("https://github.com/tree-sitter/tree-sitter-go" "v0.23.4"))
                   (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod" "v1.1.0"))
                   (make . ("https://github.com/tree-sitter-grammars/tree-sitter-make" "v1.1.1"))
                   (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "v0.24.0"))
                   (odin . ("https://github.com/krnowak/tree-sitter-odin" "krnowak/proc-body-field"))))
  (add-to-list 'treesit-language-source-alist grammar)
  (unless (treesit-language-available-p (car grammar))
    (treesit-install-language-grammar (car grammar))))
(dolist (mapping '((c-mode . c-ts-mode)
                   (c++-mode . c++-ts-mode)
                   (c-or-c++-mode . c-or-c++-ts-mode)
                   (elisp-mode . elisp-ts-mode)
                   (odin-mode . odin-ts-mode)
                   (glsl-mode . glsl-ts-mode)
                   (go-mode . go-ts-mode)
                   (go-mod-mode . go-mod-ts-mode)
                   (makefile-mode . makefile-ts-mode)
                   (rust-mode . rust-ts-mode)
                   (sh-mode . bash-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))
