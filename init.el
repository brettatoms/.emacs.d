(setq data-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path data-dir)

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(add-hook 'after-init-hook '(lambda () (load-library "init-packages")))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;(require 'el-get)

(setq my-packages
      '(zenburn-theme

	;; misc modes
	rainbow-mode
	autopair
	flycheck
	markdown-mode
	multiple-cursors
	goto-last-change
	; volatile-highlights
	magit
	lusty-explorer
	projectile
        yasnippet
        exec-path-from-shell
        virtualenv
        expand-region

	;; mode for web dev
	js2-mode
	multi-web-mode
	; css-mode
	scss-mode
	sass-mode

	;; modes for python dev
	jedi
	))


(defun install-my-packages ()
  (interactive)
  (package-refresh-contents)
  (dolist (pkg my-packages)
    (when (not (package-installed-p pkg))
      	(message "** installing %s ... " pkg)
	(package-install pkg)))
  (message "** installed all packages"))


(defun install-el-get ()
  (interactive)
  ;; So the idea is that you copy/paste this code into your *scratch* buffer,
  ;; hit C-j, and you have a working developper edition of el-get.
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp))))
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4dacec7215677e4a258e4529fac06e0231f7cdd54e981d013d0d0ae0af63b0c8" default)))
 '(safe-local-variable-values (quote ((eval setq flycheck-jshintrc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".flake8rc" (projectile-project-root))) (eval setq flycheck-jshintrc (expand-file-name ".jshintrc" ".")) (eval setq flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (eval expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-jshintrc (expand-file-name ".jshintrc" "."))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "apple" :family "Monaco"))))
;'(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight light :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(flycheck-error ((t (:underline "red"))))
 '(flycheck-fringe-error ((t (:inherit error :foreground "red" :weight bold))))
 '(flycheck-fringe-warning ((t (:inherit warning :foreground "yellow3" :weight bold))))
 '(flycheck-warning ((t (:underline "yellow3"))))
 '(mode-line ((t (:background "#2b2b2b" :foreground "#8fb28f" :box nil))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#383838" :foreground "#5f7f5f" :box nil :weight light))))
)
