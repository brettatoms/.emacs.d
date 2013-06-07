
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
		    (js2-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
		    (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
  (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
  ;(multi-web-global-mode 1)
)

;;
;; lusty-explorer
;;
(when (package-installed-p 'lusty-explorer)
  (lusty-explorer-mode t))

;;
;; autopair
;;
(when (package-installed-p 'autopair)
  (autopair-global-mode t))

;;
;; python mode hook
;;
(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)

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
  (global-set-key (kbd "C-c s") 'ace-jump-mode)
  )

(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)
)

;;
;; Project for project management
;;
(when (package-installed-p 'projectile)
  (projectile-global-mode)
)


;;
;; magit
;;
(when (package-installed-p 'magit)
  (global-set-key "\C-cvs" 'magit-status)
  (global-set-key "\C-cvP" 'magit-push)
)


;;
;; js2-mode
;;
(when (package-installed-p 'js2-mode)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

  (defun js2-tab-properly ()
    (interactive)
    (let ((yas/fallback-behavior 'return-nil))
      (unless (yas/expand)
	(indent-for-tab-command)
	(if (looking-back "^\s*")
	    (back-to-indentation)))))
  ;;(define-key js2-mode-map (kbd "TAB") 'js2-tab-properly)

  (add-hook 'js2-mode-hook
	    (lambda ()
          (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)
          (setq-default indent-tabs-mode nil)
          (setq c-basic-indent 4)
          (setq tab-width 4)
          ;;(highlight-tabs)
          (setq show-trailing-whitespace t)))
)

;;
;; yasnippet
;;
(when (package-installed-p 'yasnippet)
  (yas-global-mode)
  ;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
)

;;
;; scss-mode
;;
(when (package-installed-p 'scss-mode)
  (setq scss-compile-at-save nil)
)

;;
;; flycheck-mode
;; 
(when (package-installed-p 'flycheck-mode)
  (add-hook 'after-init-hook #'global-flycheck-mode) ; all modes get flycheck
)



;(require 'ido)
;(ido-mode t)

;; mode line settings
(column-number-mode t) ; show column number

;(setq linum-format "%d ")
(global-linum-mode)  ; show the line number in all buffers

(tool-bar-mode -1) ; don't show the toolbar

;(setq visible-bell t) ; flash instead of beep

;; highlight the current line
(global-hl-line-mode 1)
(show-paren-mode t)

; copy and paste with clipboard
(setq x-select-enable-clipboard t)

;; Dont show the GNU splash screen
(setq inhibit-startup-message t)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

(setq scroll-step 3)

;; set paragraph start for paragraph-fill so it doesn't automatically
;; wrap for our "text bullets"
(setq paragraph-start "\\*+\\|\\-\\|$"
      paragraph-separate "$")
(set-fill-column 79)

(global-set-key "\C-a" 'back-to-indentation)
(global-set-key "\M-a" 'move-beginning-of-line)

(global-subword-mode t)

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
