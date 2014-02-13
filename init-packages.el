
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; (unless (require 'el-get nil 'noerror)
;;   (with-current-buffer
;;       (url-retrieve-synchronously
;;        "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;;     (let (el-get-master-branch)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp))))
;; (el-get 'sync)

;; this normally gets filtered from our environment PATH
;(add-to-list 'exec-path "/usr/local/bin")

;; start clean
(setq initial-scratch-message "")
(setq inhibit-startup-echo-area-message "brett")
(setq inhibit-startup-message t)

;; on mac exec-path doesn't pick up the PATH from the shell
(when (package-installed-p 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;;
;; disable some packages that come with vanilla emacs that we don't use
;;
(setq vc-handled-backends nil)


;;
;; zenburn-theme
;;
(when (package-installed-p 'zenburn-theme)
  (load-theme `zenburn t))

;;
;; multi-web-mode
;;
(when (package-installed-p 'multi-web-mode)

   (setq mweb-default-major-mode 'html-mode)
   (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                      (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                      (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
   (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
   ;(multi-web-global-mode 1)
)

;
;; html-mode
(defun html-mode-hook ()
  (yas-minor-mode -1) ;; disable snippets in html mode
  ;(define-key html-mode-map (kbd "M-/") 'zencoding-expand-yas)
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t) ;; local hook
  )


(when (package-installed-p 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-hook 'web-mode-hook 'html-mode-hook)
  )


;;
;; lusty-explorer
;;
;; (when (package-installed-p 'lusty-explorer)
;;   (lusty-explorer-mode t))

;;
;; autopair
;;
;; (when (package-installed-p 'autopair)
;;   (autopair-global-mode t))

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



(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click))


(when (package-installed-p 'goto-last-change)
  (global-set-key (kbd "C-\\") 'goto-last-change)
)

;;
(when (package-installed-p 'ace-jump-mode)
  (global-set-key (kbd "C-c jw") 'ace-jump-word-mode)
  (global-set-key (kbd "C-c jc") 'ace-jump-char-mode) 
  (global-set-key (kbd "C-c jl") 'ace-jump-line-mode)
  (global-set-key (kbd "C-c jb") 'ace-jump-mode-pop-mark)
  )

(when (package-installed-p 'key-chord)
  (key-chord-mode t)
  (key-chord-define-global "jw" 'ace-jump-word-mode)
  (key-chord-define-global "jc" 'ace-jump-char-mode)
  (key-chord-define-global "jl" 'ace-jump-line-mode)
  (key-chord-define-global "jb" 'ace-jump-mode-pop-mark)
)

(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)
)

(when (package-installed-p 'auto-complete)
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t)
  ;; Start auto-completion after 2 characters of a word
  (setq ac-auto-start 2)
  ;; case sensitivity is important when finding matches
  (setq ac-ignore-case nil)
  (add-to-list 'ac-sources 'ac-source-yasnippet)
  )


;;
;; Project for project management
;;
(when (package-installed-p 'projectile)
  (projectile-global-mode)
  (define-key projectile-mode-map "\C-cpv" 'magit-status)
  ;(setq projectile-completion-system 'grizzl)
  (setq projectile-completion-system 'ido)
  
  ;; (global-set-key "\C-cpv" 'magit-status) ; projectile-like
  ;; the "native indexing" takes too long
  ;(setq projectile-use-native-indexing t)
  ;(setq projectile-enable-caching t)
)


;;
;; magit
;;
(when (package-installed-p 'magit)
  (global-set-key "\C-cvs" 'magit-status)
  (global-set-key "\C-cpv" 'magit-status) ; projectile-like
  (global-set-key "\C-cvP" 'magit-push)
  (setq vc-handled-backends nil)
  )


;;
;; js/js2-mode
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

(when (package-installed-p 'js2-mode)
  ;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

  ;; (defun js2-tab-properly ()
  ;;   (interactive)
  ;;   (let ((yas/fallback-behavior 'return-nil))
  ;;     (unless (yas/expand)
  ;;       (indent-for-tab-command)
  ;;       (if (looking-back "^\s*")
  ;;           (back-to-indentation)))))
  ;; (define-key js2-mode-map (kbd "TAB") 'js2-tab-properly)

  (add-hook 'js2-mode-hook 'js-mode-hook)

)

(add-hook 'js-mode-hook 'js-mode-hook)


(when (package-installed-p 'js-comint)
  (setq inferior-js-program-command "node")
  (setq inferior-js-mode-hook
        (lambda ()
          ;; We like nice colors
          (ansi-color-for-comint-mode-on)
          ;; Deal with some prompt nonsense
          (add-to-list 'comint-preoutput-filter-functions
                       (lambda (output)
                         (replace-regexp-in-string ".*1G\.\.\..*5G" "..."
                                                   (replace-regexp-in-string ".*1G.*3G" "> " output))))
          )))

;;
;; yasnippet
;;
(when (package-installed-p 'yasnippet)
  (yas-global-mode 1)
  (setq yas-snippet-dirs
        (concat data-dir "snippets"))
  )

;;
;; scss-mode
;;
(when (package-installed-p 'scss-mode)
  (setq scss-compile-at-save nil)
  (add-hook 'scss-mode-hook
            #'(lambda ()
                (rainbow-mode t)
                (ansi-color-for-comint-mode-on)
                (autopair-mode -1)  ;; autopair cause lock ups in scss mode
                ))
  (autopair-mode -1) ;; autopair cause lock ups in scss mode
  )

;;
;; flycheck-mode
;;
(when (package-installed-p 'flycheck)
  (add-hook 'after-init-hook #'global-flycheck-mode) ; all modes get flycheck
  (setq flycheck-highlighting-mode 'lines)
)

(when (package-installed-p 'git-gutter)
  ;; use the fringe for git-gutter-mode
  (require 'git-gutter-fringe)
  ;;(global-git-gutter-mode +1)
  ;; (setq git-gutter:modified-sign "  ") ;; two space
  ;; (setq git-gutter:added-sign "++")    ;; multiple character is OK
  ;; (setq git-gutter:deleted-sign "--")

  (setq git-gutter:modified-sign "=") ;; two space
  (setq git-gutter:added-sign "+")    ;; multiple character is OK
  (setq git-gutter:deleted-sign "-")

  (set-face-background 'git-gutter:modified "purple") ;; background color
  (set-face-foreground 'git-gutter:added "green")
  (set-face-foreground 'git-gutter:deleted "red")
)

;;
;; expand-region
;;
(when (package-installed-p 'expand-region)
  (global-set-key (kbd "C-=") 'er/expand-region)
  )


;; show matches other than just parens, e.g. html tags
(when (package-installed-p 'smartparens)
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  )

;; show matches other than just parens, e.g. html tags
(when (package-installed-p 'rainbow-mode)
  (rainbow-mode t)
  )

;; load local libs
(require 'duplicate-line)
(require 'shift-region)


; enable auto indent and auto pair
;(electric-indent-mode t)
;(electric-pair-mode t)


(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(when (package-installed-p 'flx-ido)
  (flx-ido-mode 1)
  (setq ido-use-faces nil)
  )

(when (package-installed-p 'ido-vertical-mode)
  (ido-vertical-mode t)
  )




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

(global-set-key "\C-a" 'back-to-indentation)
(global-set-key "\M-a" 'move-beginning-of-line)

(global-set-key "\C-cs" 'replace-string)

(global-subword-mode t)
(delete-selection-mode 1)

;; handle indentation and whitespace
(setq-default indent-tabs-mode nil)
(setq c-basic-indent 4)
(setq tab-width 4)

;; auto-indent on paste
(defun yank-and-indent ()
      "Yank and then indent the newly formed region according to mode."
      (interactive)
      (yank)
      (call-interactively 'indent-region))
(global-set-key "\C-y" 'yank-and-indent)
(global-set-key "\C-Y" 'yank)

; don't use another window for ediff control, was completely
; crashing my computer
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; color shell text
(add-hook 'shell-mode-hook
          #'(lambda ()
              (ansi-color-for-comint-mode-on)
              (autopair-mode -1)))

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
(global-set-key "\C-ct" 'multi-term)

; allow recusrive deletes in dired
(setq dired-recursive-deletes t)
(when (package-installed-p 'dired+)
  ; reuse the same buffer while browsing files
  (toggle-diredp-find-file-reuse-dir 1))

; automatically revert changed buffers
(global-auto-revert-mode 1)


;; buffer management
; uniquify has to be loaded after Pymacs or we get lots of
; max-lisp-eval-depth errors
(load-library "uniquify") ; uniquify buffer names
(setq uniquify-buffer-name-style 'post-forward)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(defun kill-forward-whitespace ()
  "Kill the whitespace from the current position until the next
non-whitespace character"
  (interactive)
  (let ((start-point (point))
	(end (skip-chars-forward " \t\n\r")))
    (kill-region start-point (+ end start-point))
  ))
(global-set-key "\C-cw" 'kill-forward-whitespace)

(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

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


;;
;; desktop sessions
;;
(require 'desktop)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")
(desktop-save-mode 1)
(defun my-desktop-autosave ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      ;(desktop-save desktop-dirname))
      (desktop-save data-dir))
  )
(add-hook 'auto-save-hook 'my-desktop-autosave)

(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
	  (desktop-save-in-desktop-dir)
	(message "Session not saved."))
  (desktop-save-in-desktop-dir)))

;; ask user whether to restore desktop at start-up
(if (saved-session)
    (if (y-or-n-p "Restore desktop? ")
	(session-restore)))
;; (add-hook 'after-init-hook
;; 	  '(lambda ()
;; 	     (if (saved-session)
;; 		 (if (y-or-n-p "Restore desktop? ")
;; 		     (session-restore)))))
