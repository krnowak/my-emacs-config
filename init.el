(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (deeper-blue)))
 '(font-use-system-font t)
 '(safe-local-variable-values (quote ((js2-basic-offset . 4) (eval progn (c-set-offset (quote innamespace) (quote 0)) (c-set-offset (quote inline-open) (quote 0))) (c-set-offset (quote innamespace) 0) (c-file-offsets (innamespace . 0))))))

(show-paren-mode nil)
(setq line-number-mode 1)
(setq column-number-mode 1)
(if (display-graphic-p)
  (progn
    (tool-bar-mode -1)
    (scroll-bar-mode -1)))

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

(load-directory "~/emacs")
