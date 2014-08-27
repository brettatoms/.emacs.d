(setq data-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path data-dir)

(setq default-height (floor (x-display-pixel-height) (frame-char-height)))
(setq default-width (floor (* (x-display-pixel-width) 0.4) (frame-char-width)))

(add-to-list 'default-frame-alist `(height . ,default-height))
(add-to-list 'default-frame-alist `(width . ,default-width))
(add-to-list 'initial-frame-alist `(height . ,default-height))
(add-to-list 'initial-frame-alist `(width . ,default-width))

;; this sets the window size before the init stuff starts
(when window-system
  (set-frame-size (selected-frame) default-width default-height)
  )


(require 'package)

(add-hook 'after-init-hook
	  '(lambda ()
             (require './packages)
             (require './settings)
             (require './utils)
             (require './bindings)
             (require './sessions)
             ;(redraw-display)
          ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-backends (quote (company-elisp company-bbdb company-nxml company-css company-eclim company-semantic company-clang company-xcode company-cmake company-capf (company-dabbrev-code company-gtags company-etags company-keywords) company-oddmuse company-files company-dabbrev)))
 '(custom-safe-themes (quote ("4dacec7215677e4a258e4529fac06e0231f7cdd54e981d013d0d0ae0af63b0c8" default)))
 '(org-agenda-files (quote ("~/devel/bauble/webapp/bauble.org")))
 '(org-archive-mark-done t t)
 '(org-archive-stamp-time t t)
 '(safe-local-variable-values (quote ((eval setq flycheck-jshintrc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".flake8rc" (projectile-project-root))) (eval setq flycheck-jshintrc (expand-file-name ".jshintrc" ".")) (eval setq flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (eval expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-jshintrc (expand-file-name ".jshintrc" ".")))))
 '(sp-autoescape-string-quote nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :family "inconsolata"))))
 '(flycheck-error ((t (:underline "red"))) t)
 '(flycheck-fringe-error ((t (:inherit error :foreground "red" :weight bold))) t)
 '(flycheck-fringe-warning ((t (:inherit warning :foreground "yellow3" :weight bold))) t)
 '(flycheck-warning ((t (:underline "yellow3"))) t)
 '(git-gutter-fr:added ((t (:foreground "green4" :weight bold))))
 '(git-gutter-fr:deleted ((t (:foreground "firebrick" :weight bold))))
 '(git-gutter-fr:modified ((t (:foreground "darkorange1" :weight bold))))
 '(git-gutter:added ((t (:foreground "dark green" :inverse-video t :weight bold))))
 '(git-gutter:deleted ((t (:foreground "dark red" :inverse-video t :weight bold))))
 '(git-gutter:modified ((t (:foreground "DarkOrange1" :inverse-video t :weight bold))))
 '(lazy-highlight ((t (:background "plum4" :foreground "yellow2" :weight bold))))
 '(mode-line ((t (:background "#2b2b2b" :foreground "#8fb28f" :box nil))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#383838" :foreground "#5f7f5f" :box nil :weight light)))))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
