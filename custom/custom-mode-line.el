(defface mode-line--inverted-name
  `((t :background ,(face-attribute 'mode-line :foreground)
       :foreground ,(face-attribute 'default :background)
       :inherit bold))
  "Custom face for buffer name on the mode line")

(defface mode-line--inverted-warning
  `((t :background ,(face-attribute 'warning :foreground)
       :foreground ,(face-attribute 'default :background)
       :inherit bold))
  "Custom face for warnings on the mode line")

(defface mode-line--inverted-error
  `((t :background ,(face-attribute 'error :foreground)
       :foreground ,(face-attribute 'default :background)
       :inherit bold))
  "Custom face for errors on the mode line")

(defface mode-line--inverted-success
  `((t :background ,(face-attribute 'success :foreground)
       :foreground ,(face-attribute 'default :background)
       :inherit bold))
  "Custom face for success on the mode line")

(setq-default mode-line-format
	      '("%e"
		(:eval (mode-line--buffer-status))
		(:eval (mode-line--file-location))
		(:eval (mode-line--buffer-name))
		(:eval (mode-line--major-mode))
		(:eval (mode-line--git-branch))
		(:eval (mode-line--line-column))))

(defun format-propertize (string face)
    (format "%s" (propertize (concat " " string " ") 'face face)))

(defun mode-line--buffer-name ()
  (format-propertize "%b" (if (mode-line-window-selected-p)
			      'mode-line--inverted-name
			    'italic)))

(defun mode-line--buffer-status ()
  (when (mode-line-window-selected-p)
    (let ((buffer-status-face 'mode-line--inverted-warning))
      (cond (buffer-read-only (format-propertize "RO" buffer-status-face))
	    ((buffer-modified-p) (format-propertize "M" buffer-status-face))
	    (else " ")))))

(defun mode-line--line-column ()
  (when (mode-line-window-selected-p)
    (let ((line-column-face 'bold))
      (format " L:%s C:%s "
	      (propertize "%l" 'face line-column-face)
	      (propertize "%c" 'face (if (> (current-column) fill-column)
					 'error
				       line-column-face))))))

(defun mode-line--file-location ()
  (when (and (mode-line-window-selected-p)
	     buffer-file-name)
    (let ((buffer-path (replace-regexp-in-string abbreviated-home-dir
					    "~/"
					    (file-name-directory buffer-file-name)))
	  (length-max 16))
      (format-propertize (if (< (length buffer-path) length-max)
			     buffer-path
			   (mapconcat (lambda (dir)
					(if (equal (substring dir 0 1) ".")
					    (substring dir 0 2)
					  (substring dir 0 1)))
				      (split-string buffer-path "/" t)
				      "/"))
			 'italic))))

(defun mode-line--git-branch ()
    (when (and (mode-line-window-selected-p)
	       buffer-file-name)
      (let ((git-root (locate-dominating-file buffer-file-name ".git")))
	;; i would use magit-git-string here instead of this monstrosity,
	;; but it doesnt autoload... 
	  (if git-root
	      (format-propertize (substring (with-temp-buffer
					      (call-process "git" nil t nil "branch" "--show-current")
					      (buffer-string))
					    0
					    -1)
				 'mode-line--inverted-success)
	    (format-propertize "No Git" 'mode-line--inverted-error)))))

(defun mode-line--major-mode ()
  (when (mode-line-window-selected-p)
    (let ((mm (symbol-name major-mode)))
      (format-propertize (capitalize (replace-regexp-in-string "-mode" "" mm)) 'bold))))

(provide 'custom-mode-line)
