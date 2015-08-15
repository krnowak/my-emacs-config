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

(defmacro with-library (symbol &rest body)
      `(condition-case nil
           (progn
             (require ',symbol)
             ,@body)

         (error (message (format "I guess we don't have %s available." ',symbol))
                nil)))
    (put 'with-library 'lisp-indent-function 1)

(load-file "~/.emacs.d/init-lisp/load-directory.el")
(with-library load-directory
  (load-directory "~/emacs"))
