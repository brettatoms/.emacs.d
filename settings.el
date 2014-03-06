
;; start clean
(setq initial-scratch-message "")
(setq inhibit-startup-echo-area-message "brett")
(setq inhibit-startup-message t)

;; don't open a new frame when files are drag-n-dropped on emacs windowv
(setq ns-pop-up-frames nil)


;; mode line settings
(column-number-mode t) ; show column number

;(setq linum-format "%d ")
(global-linum-mode)  ; show the line number in all buffers
(tool-bar-mode -1) ; don't show the toolbar

(setq visible-bell nil) ; flash instead of beep
(setq ring-bell-function 'ignore)

;; highlight the current line
(global-hl-line-mode 1)
;(show-paren-mode t)  ;; handled by smartparens now

; copy and paste with clipboard
(setq x-select-enable-clipboard t)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

(setq scroll-step 3)

;; set paragraph start for paragraph-fill so it doesn't automatically
;; wrap for our "text bullets"
(setq paragraph-start "\\*+\\|\\-\\|$"
      paragraph-separate "$")
(setq-default fill-column 79)

(global-subword-mode t)
(delete-selection-mode 1)

;; handle indentation and whitespace
(setq-default indent-tabs-mode nil)
(setq c-basic-indent 4)
(setq tab-width 4)

;;
;; disable some packages that come with vanilla emacs that we don't use
;;
(setq vc-handled-backends nil)

;;
;; ido mode
;;
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)

; enable auto indent and auto pair
;(electric-indent-mode t)
;(electric-pair-mode t)

; don't use another window for ediff control, was completely
; crashing my computer
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

; allow recusrive deletes in dired
(setq dired-recursive-deletes t)

; automatically revert changed buffers
(global-auto-revert-mode 1)

;; buffer management
; uniquify has to be loaded after Pymacs or we get lots of
; max-lisp-eval-depth errors
(load-library "uniquify") ; uniquify buffer names
(setq uniquify-buffer-name-style 'post-forward)


;; delete trailing whitespace by default in all modes
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;
;; python mode hook
;;
(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)
            (flycheck-mode t)

            ;; jedi mode
            (when (package-installed-p 'jedi-mode)
              (auto-complete-mode)
	      (jedi:ac-setup)
              (setq show-trailing-whitespace t))
            ))

;;
;; js/js2-mode hook
;;
(defun js-mode-hook ()
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t) ;; local hook
  (git-gutter-mode)
  (rainbow-mode t)

  ;; walk up the directory tree looking for a jshint rc
  (setq flycheck-jshintrc  (concat (locate-dominating-file buffer-file-name ".jshintrc") ".jshintrc"))

  (when (projectile-project-p)
    ;; use the .jshintrc from the project root
    ;(setq flycheck-jshintrc (concat (projectile-project-root) ".jshintrc"))
    )
  (flycheck-mode 1)
  (setq-default indent-tabs-mode nil)
  ;; (setq c-basic-indent 4)
  ;; (setq tab-width 4)
  (setq c-basic-indent 2)
  (setq tab-width 2)
  (setq js-indent-level 2)
  ;;(highlight-tabs)
  (setq show-trailing-whitespace t)
  )

(add-hook 'js-mode-hook 'js-mode-hook)

;;
;;  shell-mode-hook
;;
(add-hook 'shell-mode-hook
          #'(lambda ()
              ;; color shell text
              (ansi-color-for-comint-mode-on)
              (autopair-mode -1)))

;;
;; term-mode-hook
;;
(add-hook 'term-mode-hook
          #'(lambda ()
              ; zenburn like term colors (which for some reason
              ; stopped working in 24.3)
              (setq multi-term-program nil)
              (add-to-list 'term-bind-key-alist '("C-c C-c" . term-interrupt-subjob))
              (add-to-list 'term-bind-key-alist '("C-c C-z" . term-stop-subjob))
              (when (string-match "^24\.[0-2].*?$" emacs-version)
                (setq ansi-term-color-vector [unspecified "#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"]))
              ;(ansi-color-for-comint-mode-off)
              (yas-minor-mode -1)
              (autopair-mode -1)))


(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
;; (ignore-errors
;;   (require 'ansi-color)
;; (defun my-colorize-compilation-buffer ()
;;   (when (eq major-mode compilation-mode)
;;     (ansi-color-apply-on-region compilation-filter-start (point-max))))
;; (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer)
;;)


(provide './settings)
