(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-a") 'back-to-indentation)
(global-set-key (kbd "M-a") 'move-beginning-of-line)
(global-set-key (kbd "C-c s") 'replace-string)
(global-set-key (kbd "C-c f") 'find-file-at-point)
(global-set-key "\C-y" 'yank-and-indent)
(global-set-key "\C-Y" 'yank)
(global-set-key "\C-cw" 'kill-forward-whitespace)
(global-set-key (kbd "C-c d") 'duplicate-line-or-region)

(global-set-key (kbd "C-'") 'company-complete)

(global-set-key (kbd "C-S-<right>") 'shift-right)
(global-set-key (kbd "C-S-<left>") 'shift-left)

(global-set-key "\C-ct" 'multi-term)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c C-r") 'sudo-edit-current-file)

;; i hit this accidentally all the time
(global-unset-key (kbd "M-c"))

;; quicker archiving
;(define-key org-mode-map (kbd "C-c C-a") 'org-archive-to-archive-sibling)


(provide './bindings)
