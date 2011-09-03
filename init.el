; -*- emacs-lisp -*-
;
; init.el
;
; NOTE: to use this file: ln -s ~/<path>/dot.emacs ~/.emacs
; (server-start) ;; don't really use this much
(setq data-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path data-dir)
(setq package-dir (concat data-dir "packages/"))
(add-to-list 'load-path package-dir)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
(require 'smtpmail)

(setq user-mail-address "brettatoms@gmail.com")


(global-set-key (kbd "\C-c c") 'compile)

(add-to-list 'load-path (concat package-dir "eproject"))
(require 'eproject)
;(require 'eproject-extras)
(define-project-type python (generic)
  (look-for "setup.py")
  :relevant-files ("\\.py$"))


(defun my-python-project-file-visit-hook ()

  (set (make-local-variable 'compile-command)
       (format "python %s/setup.py run" (eproject-root)))

  ; visit the TAGS file if it exists
  (if (file-exists-p (concat (eproject-root) "TAGS"))
	(visit-tags-table (concat (eproject-root) "TAGS") t))

  ; enable the project virtualenv if defined in .eproject
   (when (eproject-attribute :virtualenv-name)
     (require 'virtualenv)
     (virtualenv-activate (eproject-attribute :virtualenv-name)))

  ; TODO: setup ropemacs

  ; TODO: setup flymake...probably need to add eproject-root to python
  ; path for local buffer only
  
  )

(add-hook 'python-project-file-visit-hook 'my-python-project-file-visit-hook)
			     
;
; Python related settings
; 
(defun my-python-mode-hook ()
  (require 'virtualenv)
  (c-subword-mode t)     ; add camel case as word boundaries
  (delete-selection-mode t)     ; overwrite selection with typing
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)
  ;; (setq indent-tabs-mode nil) ; disable tab indents

  (setq python-check-command "~/python/bin/pylint --output-format=parseable")
)

; append the hook so semantic loads first
(add-hook 'python-mode-hook 'my-python-mode-hook t)

;; Configure flymake for python
(defun flymake-pylint-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    ;(list "epylint" (list local-file)))
    (list "lintrunner.py" (list (buffer-file-name))))
)

; replace the .py handle created in python.el with ours
(when (load "flymake" t)
  (dolist (item flymake-allowed-file-name-masks)
    (if (string= (car item) "\\.py\\'")
	(setcdr item '(flymake-pylint-init))))
)
(require 'flymake)
(add-to-list 'flymake-allowed-file-name-masks
	     '("\\.py\\'" flymake-pylint-init))


; HTML
;(load (concat package-dir "nxhtml/autostart.el"))

(defvar autosave-dir (concat "/tmp/." (user-login-name) "-emacs-autosaves/"))
(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
	  (if buffer-file-name
	      (concat "#" (file-name-nondirectory buffer-file-name) "#")
	    (expand-file-name (concat "#%" (buffer-name) "#")))))


;; add occur to searching to get all occurences of search string
(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))

;; set paragraph start for paragraph-fill so it doesn't automatically
;; wrap for our "text bullets"
(setq paragraph-start "\\*+\\|\\-\\|$"
      paragraph-separate "$")
(set-fill-column 79)

;; Dont show the GNU splash screen
(setq inhibit-startup-message t)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; mode line settings
(column-number-mode t) ; show column number
(line-number-mode t) ; show the line number

(tool-bar-mode -1) ; don't show the toolbar
(fringe-mode '(nil . 0)) ; left fringe only

(setq visible-bell t) ; flash instead of beep

;; highlight the current line
(global-hl-line-mode 1)
(show-paren-mode t)

; copy and paste with clipboard
(setq x-select-enable-clipboard t)

; scroll bar on the right
(set-scroll-bar-mode 'right)
(setq scroll-step 2)

; don't use another window for ediff control, was completely
; crashing my computer
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(global-set-key (kbd "\C-c r") 'replace-string)

(defun kill-forward-whitespace ()
  "Kill the whitespace from the current position until the next
non-whitespace character"
  (interactive)
  (let ((start-point (point))
	(end (skip-chars-forward " \t\n\r")))
    (kill-region start-point (+ end start-point))
  ))
(global-set-key "\C-cw" 'kill-forward-whitespace)

(require 'goto-last-change)
; on Emacs 22 by default 'C-\' is bound to toggle-input-method but i
; don't use this anyways
(global-set-key (kbd "C-\\") 'goto-last-change)

; TODO: We either need to change this binding or change the default
; ropemacs binding since it also uses C-c f
;(global-set-key (kbd "\C-c ff") 'igrep-find)
(define-key global-map [f5] 'next-error)

; allowe recusrive deletes in dired
(setq dired-recursive-deletes t)

; title format
(setq frame-title-format "%b - emacs")

; edit files with sudo using tramp
(defun sudo-edit (&optional arg)
  (interactive "p")
  (if arg
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
 
(defun sudo-edit-current-file ()
  (interactive)
  (find-alternate-file (concat "/sudo:root@localhost:" 
			       (buffer-file-name (current-buffer)))))
(global-set-key (kbd "C-c C-r") 'sudo-edit-current-file)


(defun annotate-todo ()
  "put fringe marker on TODO: lines in the curent buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "TODO:" nil t)
      (let ((overlay (make-overlay (- (point) 5) (point))))
        (overlay-put overlay 'before-string (propertize (format "A")
                                                        'display '(left-fringe right-triangle)))))))
(add-hook 'find-file-hooks 'annotate-todo)


;; org mode hook
(defun my-org-mode-hook ()
     (auto-fill-mode t)
)
(add-hook 'org-mode-hook 'my-org-mode-hook)

;; shell
(defun my-shell-mode-hook ()
  (require 'ansi-color)
    ; filter colors from out since we don't use the same background
  ; color as a terminal and it looks weird
  (ansi-color-for-comint-mode-filter) ; require ansi-color
  (local-set-key (kbd "\C-p") 'comint-previous-input)
  (local-set-key (kbd "\C-n") 'comint-previous-input)
  (local-set-key (kbd "\C-z") 'self-insert-command) ; send C-z to shell

  ;; (set (make-local-variable 'face-remapping-alist)
  ;;      '((default :background "#000000" :foreground "lightgrey")
  ;; 	 (highlight default)))

  ; set LS_COLORS to change colors

)
(add-hook 'shell-mode-hook 'my-shell-mode-hook)

; i'm not sure if this is really looking here for info files
(add-to-list 'Info-default-directory-list (concat data-dir "info/"))
(eval-after-load "info" '(require 'info+)) ; extra stuff for info mode

;
; DVC
;
;(load-file (concat package-dir "dvc/dvc-load.el"))
;(setq dvc-tips-enabled nil)

;; save the history to an external file
(require 'savehist)
(setq savehist-file (concat data-dir "history"))
(savehist-mode 1)


;; buffer management
; uniquify has to be loaded after Pymacs or we get lots of
; max-lisp-eval-depth errors
(load-library "uniquify") ; uniquify buffer names
(setq uniquify-buffer-name-style  'post-forward)

; use ibuffer for buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

; buffer switch completion
;(iswitchb-mode t)

;; (ido-mode t) ; provides buffer switch and file open completion
;; (setq ido-auto-merge-delay-time 99999) ; don't scrounge around for files
;; (setq ido-enable-flex-matching t) ; fuzzy matching is a must have

; temporarily replace ido with lust-explorer
(require 'lusty-explorer)
(global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
(global-set-key (kbd "C-x b") 'lusty-buffer-explorer)

(require 'color-theme)
; should try solarized
;(require 'color-theme-solarized)
(require 'color-theme-zenburn)
(color-theme-zenburn)
; the following faces don't work that well with zenburn
;; (custom-set-faces 
;;  '(rst-level-1-face ((t (:inherit default :background "#555"))))
;;  '(rst-level-2-face ((t (:inherit default :background "#555"))))
;;  '(rst-level-3-face ((t (:inherit default :background "#555"))))
;;  '(rst-level-4-face ((t (:inherit default :background "#555"))))
;;  '(mumamo-background-chunk-major ((t (:inherit default :background "#default")))))
;; (zenburn)

;; (defun color-theme-me ()
;;   ""
;;   (interactive)
;;   (color-theme-install
;;    '(color-theme-me
;;      ((foreground-color . "black")
;;       (background-mod . dark)
;;       (background-color . "lightgrey"))
;;    (default ((t (nil))))
;;    ;(highlight ((t (:background "lightblue"))))
;;    (hl-line ((t (:foreground "black" :background "#eee"))))
;;    (mode-line ((t (:background "grey75" :box '(:line-width -1 :color "black")))))
;;    (font-lock-string-face ((t (:foreground "ForestGreen"))))
;;    (font-lock-variable-name-face ((t (:foreground "orange4"))))
;;    (font-lock-keyword-face ((t (:foreground "Blue1"))))
;;    (font-lock-type-face ((t (:foreground "Purple4"  :bold t))))
;;    (font-lock-function-name-face ((t (:foreground "black" :bold t))))
;;    )))
;; (color-theme-me)



(setq default-frame-alist 
      '((height . 35)
	(width . 81) ; width to 81 since the left fringe is enabled by default
	))

(defun font-existsp (font)
    (if (null (x-list-fonts font))
        nil t))
(if (font-existsp "Inconsolata")
    (add-to-list 'default-frame-alist '(font . "Inconsolata-13")))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left8" (0.2831858407079646 . 0.2894736842105263) (0.2831858407079646 . 0.23684210526315788) (0.2831858407079646 . 0.2894736842105263) (0.2831858407079646 . 0.15789473684210525))))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
