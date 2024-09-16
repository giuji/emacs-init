;; -*- eval: (outline-minor-mode); outline-regexp: ";;; \\*+"; eval: (outline-hide-body); -*-
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
(setq initial-scratch-message (concat ";; Welcome to Emacs!! today is the "
				      (format-time-string "%dth of %B, %Y. " (current-time))
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

;;; * Packages Config

;; Structure and interpretation of computer programs
(use-package sicp
  :ensure t)

;; Enable completion
(use-package icomplete
  :defer nil
  :custom (icomplete-scroll t)
  ;; disable completion buffer (redundant with icomplete enabled)
  (completion-auto-help nil)
  :config
  (icomplete-vertical-mode 1))

;; Theme
(use-package nord-theme
  :ensure t
  :defer nil
  :config (load-theme 'nord t))

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
  :hook ((prog-mode text-mode) . electric-pair-mode))

;; avy-mode
(use-package avy
  :ensure t
  :config (add-to-list 'avy-styles-alist
		      '(avy-goto-word-1 . at-full))
  :custom (avy-all-windows nil)
  (avy-style 'pre)
  :bind (("M-g e" . avy-goto-word-0)
	 ("M-g w" . avy-goto-word-1)
	 ("M-g f" . avy-goto-line)))

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
(use-package vc
  :disabled)

;; Racket mode
(use-package racket-mode
  :ensure t
  :config (add-to-list 'display-buffer-alist
		       '("\\*Racket REPL </>\\*" display-buffer-below-selected
			 (window-height . 0.25))))

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

(use-package doc-view
  :custom (doc-view-resolution 200)
  :bind (:map doc-view-mode-map
	 ("c c" . doc-view-clear-cache)))

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

;;; * Custom modules to load

;; Custom modules dir
(add-to-list 'load-path (file-name-concat user-emacs-directory "custom"))

;; Custom mode-line (be sure to load this after loading the theme)
(require 'custom-mode-line)
