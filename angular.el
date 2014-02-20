

;;
;; Paths to the specific files
;; 
(defcustom  angular-controller-path "app/scripts/controllers"
  "The relative path to your AngularJS controllers from your project root."
)

(defcustom  angular-view-path "app/views"
  "The relative path to your AngularJS views from your project root."
)

(defcustom  angular-test-path "test/spec/controllers"
  "The relative path to your AngularJS tests from your project root."
)


(defun angular-visit-controller ()
  (interactive)
  (let ((controller-path (expand-file-name (concat (file-name-base buffer-file-name) ".js")
                                           (expand-file-name angular-controller-path 
                                                             (projectile-project-root)))))
    (message controller-path)
    (if (file-exists-p controller-path)
        (find-file controller-path)
      )
  ))

(defun angular-visit-view ()
  (interactive)
  (let ((view-path (expand-file-name (concat (file-name-base buffer-file-name) ".html")
                                           (expand-file-name angular-view-path 
                                                             (projectile-project-root)))))
    (message angular-view-path)
    (message view-path)
    (find-file view-path)
    )
  )

(defun angular-visit-test ()
  (interactive)
  (let ((test-path (expand-file-name (concat (file-name-base buffer-file-name) ".js")
                                           (expand-file-name angular-test-path 
                                                             (projectile-project-root)))))
    (message test-path)
    (find-file test-path)
    )
  )


;;
;; Define keyboard shortcuts
;; 
(define-key projectile-mode-map "\C-cac" 'angular-visit-controller)
(define-key projectile-mode-map "\C-cav" 'angular-visit-view)
(define-key projectile-mode-map "\C-cat" 'angular-visit-test)


(provide 'angular)
