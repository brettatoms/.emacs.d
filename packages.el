
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

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;(require 'el-get)

(setq my-packages
      '(zenburn-theme

	;; misc modes
	rainbow-mode
	;;autopair   ; replaced by builtin electric-pair-mode
	flycheck
	markdown-mode
	multiple-cursors
	goto-last-change
        dired+
        ag  ;; https://github.com/Wilfred/ag.el

	; volatile-highlights
	magit
	lusty-explorer
	projectile
        grizzl
        yasnippet
        exec-path-from-shell
        virtualenv
        expand-region
        zencoding-mode
        flx-ido
        ido-vertical-mode
        smartparens
        ace-jump-mode
        key-chord
        smartscan

	;; modes for web dev
	js2-mode
	web-mode

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


;;
;; zenburn-theme
;;
(when (package-installed-p 'zenburn-theme)
  (load-theme `zenburn t))


;;
;; auto-compile
;;
;; auto compile lisp files on save and load
(when (package-installed-p 'auto-compile)
  (require 'auto-compile) ;; not sure why this packages needs a require
  (toggle-auto-compile data-dir 1)
  (auto-compile-on-load-mode 1)
  (auto-compile-on-save-mode 1)
)


;;
;; exect-path-from-shell
;;
;; on mac exec-path doesn't pick up the PATH from the shell
(when (package-installed-p 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;;
;; web-mode - http://web-mode.org
;; 
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
;; multiple-cursors
;;
(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click))

;;
;; goto-last-change
;;
(when (package-installed-p 'goto-last-change)
  (global-set-key (kbd "C-\\") 'goto-last-change)
)

;;
;;  ace-jump-mode
;;
(when (package-installed-p 'ace-jump-mode)
  (global-set-key (kbd "C-c jw") 'ace-jump-word-mode)
  (global-set-key (kbd "C-c jc") 'ace-jump-char-mode) 
  (global-set-key (kbd "C-c jl") 'ace-jump-line-mode)
  (global-set-key (kbd "C-c jb") 'ace-jump-mode-pop-mark)
  )


;;
;; key-chord
;;
(when (package-installed-p 'key-chord)
  (key-chord-mode t)
  (key-chord-define-global "jw" 'ace-jump-word-mode)
  (key-chord-define-global "jc" 'ace-jump-char-mode)
  (key-chord-define-global "jl" 'ace-jump-line-mode)
  (key-chord-define-global "jb" 'ace-jump-mode-pop-mark)
)


;;
;; smartscan - https://github.com/mickeynp/smart-scan
;;
(when (package-installed-p 'smartscan)
  (smartscan-mode t)
)

;;
;; multiple-cursors
;; 
(when (package-installed-p 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)
)

;;
;; auto-complete
;;
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
  (require 'angular)
  
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
;; js2-mode
;;
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

;;
;; js-comint
;;
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

;;
;; git-gutter
;;
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
  ;(sp-autoescape-string-quote nil)
  )

;;
;; show matches other than just parens, e.g. html tags
;;
(when (package-installed-p 'rainbow-mode)
  (rainbow-mode t)
  )

;;
;; flx-ido
(when (package-installed-p 'flx-ido)
  (flx-ido-mode 1)
  (setq ido-use-faces nil)
  )

;;
;; ido-vertical-mode
;;
(when (package-installed-p 'ido-vertical-mode)
  (ido-vertical-mode t)
  )

;;
;; dired+
;;
(when (package-installed-p 'dired+)
  ; reuse the same buffer while browsing files
  (toggle-diredp-find-file-reuse-dir 1))


(provide './packages)
