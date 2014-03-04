(setq data-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path data-dir)

(require 'package)

(add-hook 'after-init-hook 
	  '(lambda () 
             (require './packages)
             (require './settings)
             (require './utils)
             (require './bindings)
             (require './sessions)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("4dacec7215677e4a258e4529fac06e0231f7cdd54e981d013d0d0ae0af63b0c8" default)))
 '(safe-local-variable-values (quote ((eval setq flycheck-jshintrc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".jshintrc" (projectile-project-root))) (eval setq flycheck-flake8rc (expand-file-name ".flake8rc" (projectile-project-root))) (eval setq flycheck-jshintrc (expand-file-name ".jshintrc" ".")) (eval setq flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (eval expand-file-name ".tidyrc" ".")) (flycheck-tidyrc (expand-file-name ".tidyrc" ".")) (flycheck-jshintrc (expand-file-name ".jshintrc" ".")))))
 '(sp-autoescape-string-quote nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :family "inconsolata"))))
 '(flycheck-error ((t (:underline "red"))))
 '(flycheck-fringe-error ((t (:inherit error :foreground "red" :weight bold))))
 '(flycheck-fringe-warning ((t (:inherit warning :foreground "yellow3" :weight bold))))
 '(flycheck-warning ((t (:underline "yellow3"))))
 '(git-gutter-fr:added ((t (:foreground "green4" :weight bold))))
 '(git-gutter-fr:deleted ((t (:foreground "firebrick" :weight bold))))
 '(git-gutter-fr:modified ((t (:foreground "darkorange1" :weight bold))))
 '(git-gutter:added ((t (:foreground "dark green" :inverse-video t :weight bold))))
 '(git-gutter:deleted ((t (:foreground "dark red" :inverse-video t :weight bold))))
 '(git-gutter:modified ((t (:foreground "DarkOrange1" :inverse-video t :weight bold))))
 '(mode-line ((t (:background "#2b2b2b" :foreground "#8fb28f" :box nil))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#383838" :foreground "#5f7f5f" :box nil :weight light)))))
