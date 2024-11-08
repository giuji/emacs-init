;; -*- eval: (outline-minor-mode); outline-regexp: ";;; \\*+ "; -*-
;; Emacs init file 18/07/2024 00:04 - Rome
;; outline-minor-mode seems NOT to respect heading levels under
;; emacs-lisp-mode (all headings are treated as the same level), this
;; makes it lowkey useless stupid fucking emacs i hate you

;;; * Set non-package-specific stuff

;;; Package manager config

;; Add package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; Force autoloading as default
(setq use-package-always-defer t)

;;; Misc

;; Disbale lock files
(setq create-lockfiles nil)

;; Keep custom variables in a different file
(setq custom-file (expand-file-name "custom-vars.el" user-emacs-directory))
(load custom-file 'nomessage 'noerror)

;; Bakcup files
(make-directory (expand-file-name "tmp/backups" user-emacs-directory) t)
(make-directory (expand-file-name "tmp/autosave" user-emacs-directory) t)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "tmp/backups" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "tmp/backups" user-emacs-directory) t)))
(setq backup-by-copying t)

;;; Behaviour

;; Remove useless UI
(tab-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq ring-bell-function 'ignore)
(setq make-pointer-invisible t)

;; Disable toolkit dialogs
(setq use-dialog-box nil)

;; Disable splashscreen
(setq inhibit-startup-message t)

;; Change default scratch buffer message
(setq initial-scratch-message (concat ";; Welcome to Emacs!! Today is "
				      (format-time-string "%d/%B (EU), %Y. " (current-time))
				      "Have fun!!\n"))

;; Disable implicit frame resizing
(setq frame-inhibit-implied-resize t)

;; Good scrolling
(setq scroll-step 1)
(setq scroll-margin 2)
(setq scroll-conservately 15)
(setq hscroll-setp 1)
(setq hscroll-margin 2)

;; Follow focus
(setq focus-follows-mouse t)
(setq mouse-autoselect-window-window t)

;; Remember minibuffer hisotry
(setq history-length 16)
(savehist-mode 1)

;; Window management
(setq switch-to-buffer-obey-display-action t)

;; Show active region
(transient-mark-mode t)

;; Enable auto-fill
(setq-default fill-column 72)
(add-hook 'text-mode-hook 'auto-fill-mode)

;; Font
(set-face-attribute 'default nil :font "Cascadia Code-10")

;;; * Custom modules to load

;; Custom modules dir
(add-to-list 'load-path (file-name-concat user-emacs-directory "custom"))

;; Custom mode-line (be sure to load this after loading the theme)
(require 'custom-mode-line)

;; Custom functions and utils
(require 'custom-functions)

;;; * Packages Config

;; Structure and interpretation of computer programs
(use-package sicp
  :ensure t)

;; Enable completion
(use-package icomplete
  :custom (icomplete-scroll t)
  ;; disable completion buffer (redundant with icomplete enabled)
  (completion-auto-help nil)
  :bind (:map minibuffer-mode-map
	 ("C-<return>" . icomplete-force-complete-and-exit)))
(icomplete-vertical-mode 1)

;; Config eldoc 
(use-package eldoc
  :custom (eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly)
  ;; Need to find a way to hide echo area messages when eldoc buffer exists
  :config (add-to-list 'display-buffer-alist
		       '("\\*eldoc\\*" display-buffer-below-selected
			 (window-height . 10))))

;; Company for at point tooltip completition
(use-package company
  :ensure t
  :custom (company-tooltip-flip-when-above t)
  (company-format-margin-function 'company-text-icons-margin)
  (company-text-icons-add-background t))

;; Theme
;; (use-package nord-theme
;;   :ensure t
;;   :defer nil
;;   :config (load-theme 'nord t))
(use-package ef-themes
  :ensure t
  :config (mapc #'disable-theme custom-enabled-themes)
  :custom (ef-themes-to-toggle '(ef-melissa-dark ef-melissa-light))
  :bind ("C-c e" . ef-themes-toggle)
  :hook (ef-themes-post-load . (lambda ()
				 (ef-themes-with-colors
				   (set-face-attribute 'font-lock-comment-face nil
						       :foreground fg-dim))))
  ;; Check custom/custom-mode-line.el these custom faces are defined there
  (ef-themes-post-load . (lambda ()
			   (let ((suc (face-attribute 'success :foreground))
				 (err (face-attribute 'error :foreground))
				 (war (face-attribute 'warning :foreground))
				 (mod-l (face-attribute 'mode-line :foreground))
				 (fg (face-attribute 'default :background)))
			     (set-face-attribute 'mode-line--inverted-success nil
						 :background suc
						 :foreground fg)
			     (set-face-attribute 'mode-line--inverted-error nil
						 :background err
						 :foreground fg)
			     (set-face-attribute 'mode-line--inverted-warning nil
						 :background war
						 :foreground fg)
			     (set-face-attribute 'mode-line--inverted-name nil
						 :background mod-l
						 :foreground fg)))))
(ef-themes-select 'ef-melissa-dark)

;; Show matching parens
(use-package paren
  :custom (show-paren-delay 0)
  :config (show-paren-mode 1))

(use-package window
  :bind ("C-c t" . window-toggle-side-windows))

;; Highlight cursor line
(use-package hl-line
  :hook (prog-mode text-mode))

;; Config help mode
(use-package help
  :custom (help-window-keep-selected t)
  (help-window-select t)
  (help-clean-buttons t)
  :config (add-to-list 'display-buffer-alist
		       '("\\*Help\\*"
			 (display-buffer-reuse-window display-buffer-pop-up-window))))

;; Enable eletric pair for parens pairing
(use-package elec-pair
  :defer t
  :hook ((prog-mode text-mode) . electric-pair-local-mode))

;; avy-mode
(use-package avy
  :ensure t
  :config (add-to-list 'avy-styles-alist
		       '(avy-goto-word-1 . at-full)
		       '(avy-goto-char-timer . at))
  :custom (avy-all-windows t)
  (avy-style 'pre)
  :bind (("M-g a" . avy-goto-char-timer)
	 ("M-g l" . avy-goto-line)))

;; Display line numbers when writing code
(use-package display-line-numbers
  :custom (display-line-numbers-type t)
  :hook prog-mode)

;; Enable magit and disable built in version control helper
(use-package magit
  :ensure t
  :custom (magit-define-global-key-bindings 'recommended)
  ;; disable builtin vc package
  (vc-handled-backends nil))

;; Racket mode
(use-package racket-mode
  :ensure t
  :config (add-to-list 'display-buffer-alist
		       '("\\*Racket REPL </>\\*" display-buffer-below-selected
			 (window-height . 0.25))))

;; Haskell mode
(use-package haskell-mode
  :ensure t
  :config (add-to-list 'display-buffer-alist
		       '("\\*haskell\\*" display-buffer-below-selected
			 (window-height . 0.25))))

;; CC mode
(use-package cc-mode
  ;; set C style to match k&r 2nd edition
  :config (setcdr (assoc 'other c-default-style) "k&r")
  :custom (c-basic-offset 4))

;; Enable direnv
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

;; Enable nix-mode
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;; display eshell on the bottom
(use-package eshell
  :bind ("C-c z" . eshell)
  :config (add-to-list 'display-buffer-alist
		       '("\\*e?shell\\*" display-buffer-in-side-window
			 (side . bottom)
			 (slot . 0)
			 (window-height . 0.25))))

(use-package info
  :config (add-to-list 'display-buffer-alist
		       '("\\*info\\*" (display-buffer-in-side-window)
			 (side . left)
			 (slot . 0)
			 (window-width . 92))))

;; Autorevert
(use-package autorevert
  :custom (global-auto-revert-non-file-buffer t))

;; Recentf
(use-package recentf
  :ensure t
  :bind ("C-c C-r" . recentf-open-files)
  :custom (recentf-max-saved-itmes 25)
  (recentf-max-menu-times 25)
  :config (recentf-mode 1))

(use-package dired
  :bind ("C-c C-d" . dired))
  
;; Use ibuffer instead of buffer menu
(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

;; Windmove setup
(use-package windmove
  :bind ("M-o p" . windmove-up)
  ("M-o n" . windmove-down)
  ("M-o f" . windmove-right)
  ("M-o b" . windmove-left))

;; (use-package doc-view
;;   :custom (doc-view-resolution 200)
;;   :bind (:map doc-view-mode-map
;; 	 ("c c" . doc-view-clear-cache)))

;; whick-key package (remember this is turning built-in from next emacs version...)
(use-package which-key
  :ensure t
  :defer nil ; i have to defer or the package doesnt work
  :config (which-key-mode)
  (which-key-setup-side-window-bottom))

(use-package mpc
  :custom (mpc-browser-tags '(AlbumArtist Album))
  :bind (:map mpc-tagbrowser-mode-map
	 ("C-<return>" . mpc-play-at-point)
	 :map mpc-songs-mode-map
	 ("C-<return>" . mpc-play-at-point)))

;; org mode stuff
(use-package org
  :custom (org-latex-compiler "lualatex")
  (org-preview-latex-default-process 'dvisvgm)
  :config (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
  (add-to-list 'org-structure-template-alist '("H" . "src haskell")))
