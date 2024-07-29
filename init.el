;;; Emacs init file 18/07/2024 00:04 - Rome



;; [Pakcage management config]

;; Add package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(package-initialize)

;; Set-up use-package

;; Force autoloading as default
(setq use-package-always-defer t)

;; Ensure packages are installed implicitly
;(setq use-package-always-ensure t) ; this thing lowkey doesnt work



;; [Misc]

;; Disbale lock files
(setq create-lockfiles nil)

;; Keep custom variables in a different file
(setq custom-file (expand-file-name "custom-vars.el" user-emacs-directory))
(load custom-file 'nomessage 'noerror)

;; Structure and interpretation of computer programs
(use-package sicp
  :ensure t)



;; [Pretty]

;; Remove useless UI
(tab-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq visible-bell nil)
(setq make-pointer-invisible t)

;; Disable toolkit dialogs
(setq use-dialog-box nil)

;; Disable splashscreen
(setq inhibit-startup-message t)

;; Disable implicit frame resizing
(setq frame-inhibit-implied-resize t)

;; Theme
(use-package nord-theme
  :ensure t
  :defer nil
  :config
  (load-theme 'nord t))

;; Show active region
(transient-mark-mode t)

;; Show matching parens
(use-package paren
  :custom (show-paren-delay 0)
  :config (show-paren-mode 1))

;; Icons
(use-package all-the-icons
  :ensure nil
  :if (display-graphic-p))


;; [Behaviour]

;; Good scrolling
(setq scroll-step 1)
(setq scroll-margin 2)
(setq scroll-conservately 15)
(setq hscroll-setp 1)
(setq hscroll-margin 2)

;; Highlight cursor line
(use-package hl-line
  :hook (prog-mode text-mode))

;; Config help mode
(use-package help
  :custom
  (help-window-keep-selected t)
  (help-window-select t)
  (help-clean-buttons t))

;; Follow focus
(setq focus-follows-mouse t)
(setq mouse-autoselect-window-window t)

;; Enable eletric pair for parens pairing
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'text-mode-hook 'electric-pair-mode)
;(use-package elec-pair
;  :defer t
;  :hook (prog-mode . #'electric-pair-mode)
;        (text-mode . #'electric-pair-mode))
; THIS DOESNT WORK IDK WHY :(

;; Remember minibuffer hisotry
(setq history-lenght 16)
(savehist-mode 1)



;; [Code]

;; Display line numbers when writing code
(use-package display-line-numbers
;  :custom
;  (display-line-numbers-type 'relative)
  :hook prog-mode)

;; Racket mode
(use-package racket-mode
  :ensure t)


;; [Org-text]

;; Enable auto-fill
(setq fill-column 72)
(add-hook 'text-mode-hook 'auto-fill-mode)



;; [Files-dired]

;; Bakcup files
(make-directory (expand-file-name "tmp/backups" user-emacs-directory) t)
(make-directory (expand-file-name "tmp/autosave" user-emacs-directory) t)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "tmp/backups" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "tmp/backups" user-emacs-directory) t)))
(setq backup-by-copying t)

;; Autorevert
(use-package autorevert
  :custom (global-auto-revert-non-file-buffer t))

;; Recentf
(use-package recentf
  :ensure t
  :bind ("C-c C-r" . recentf-open-files)
  :custom
  (recentf-max-saved-itmes 25)
  (recentf-max-menu-times 25)
  :config (recentf-mode 1))

;; Dired thumbnails
(use-package image-dired
  :bind (:map dired-mode-map ; This doesnt work but i dont wanna bind globally
	 ("C-c C-t" . image-dired)))



;; [Keybindings]

;; Use ibuffer instead of buffer menu
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; whick-key package (remember this is turning built-in from next emacs version...)
(use-package which-key
  :ensure t
  :defer nil
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))
