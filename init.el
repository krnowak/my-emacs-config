;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(font-use-system-font t)
 '(package-archives
   '(("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(modern-cpp-font-lock groovy-mode rust-mode go-mode flymake-rust flymake-go better-defaults))
 '(safe-local-variable-values
   '((js2-basic-offset . 4)
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

(setq my-packages '(flymake-go flymake-rust better-defaults go-mode rust-mode))
(setq my-packages-to-install '())
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (push p my-packages-to-install)))

(if (not (equal (car my-packages-to-install) nil))
    (progn
      (package-refresh-contents)
      (dolist (p my-packages-to-install)
	(package-install p)))
  nil)

(setq line-number-mode 1)
(setq column-number-mode 1)

(require 'whitespace)
(setq whitespace-style
  '(face empty tabs trailing))
(setq whitespace-global-modes t)
(global-whitespace-mode 1)

(defun load-directory (directory)
  "Load recursively all `.el' files in DIRECTORY."
  (dolist (element (directory-files-and-attributes directory nil nil nil))
    (let* ((path (car element))
           (fullpath (concat directory "/" path))
           (isdir (car (cdr element)))
           (ignore-dir (or (string= path ".") (string= path ".."))))
      (cond
       ((and (eq isdir t) (not ignore-dir))
        (load-directory fullpath))
       ((and (eq isdir nil) (string= (substring path -3) ".el"))
                (load (file-name-sans-extension fullpath)))))))

(if (file-directory-p "~/emacs")
    (load-directory "~/emacs"))
(require 'better-defaults)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
