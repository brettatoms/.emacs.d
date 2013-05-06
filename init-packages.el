
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
(add-to-list 'exec-path "/usr/local/bin")

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
;; jedi-mode
;;
(when (package-installed-p 'jedi-mode)
  (add-hook 'python-mode-hook 
	    (lambda ()	    
	      (auto-complete-mode)
	      (jedi:ac-setup))))


(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click))


(when (package-installed-p 'goto-last-change)
  (global-set-key (kbd "C-\\") 'goto-last-change)
)

;;
;; Project for project management
;; 
(when (package-isntalled-p 'projectile)
  (projectile-global-mode)
)
projectile


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

;; set paragraph start for paragraph-fill so it doesn't automatically
;; wrap for our "text bullets"
(setq paragraph-start "\\*+\\|\\-\\|$"
      paragraph-separate "$")
(set-fill-column 79)


; don't use another window for ediff control, was completely
; crashing my computer
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; color shell text
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

; allowe recusrive deletes in dired
(setq dired-recursive-deletes t)


;; buffer management
; uniquify has to be loaded after Pymacs or we get lots of
; max-lisp-eval-depth errors
(load-library "uniquify") ; uniquify buffer names
(setq uniquify-buffer-name-style 'post-forward)

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


