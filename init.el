;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
; (add-to-list 'package-archives
;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
;(add-to-list 'package-archives
;             '("tromey" . "http://tromey.com/elpa/") t)
;(add-to-list 'package-archives
;             '("melpa" . "https://melpa.org/packages/") t)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa-stable" .
			  "http://melpa-stable.milkbox.net/packages/")))

;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; private stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tool-bar-mode nil)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Special mark for the column 70 in Java code
(require 'column-marker)
(add-hook 'java-mode-hook (
			   lambda ()
			   (interactive)
			   (column-marker-1 70)
			   (setq tab-width 8)
			   (local-set-key (kbd "RET")
					  'reindent-then-newline-and-indent)
			   (c-set-offset 'arglist-intro '+)
			   (c-set-offset 'case-label '+)
			   ))

(add-hook 'c++-mode-hook (lambda ()
			   (setq indent-tabs-mode nil)
			   (setq tab-width 8)))

(add-hook 'rust-mode-hook (lambda ()
			    (local-set-key (kbd "RET")
					   'reindent-then-newline-and-indent)))

(add-hook 'nxml-mode-hook (
			   lambda ()
			   (setq tab-width 8)))

(add-hook 'c-mode-hook (
			lambda ()
			       (setq indent-tabs-mode nil)
			       (c-set-offset 'case-label '+)
			       (local-set-key (kbd "RET")
					      'reindent-then-newline-and-indent)
			       ))

(add-hook 'js-mode-hook (lambda ()
			  (setq tab-width 8)))

;; Show column numbers in the status line
(setq column-number-mode t)

(defun my-indent-setup ()
  (c-set-offset 'arglist-intro '+))
(add-hook 'java-mode-hook 'my-indent-setup)

(setq nxml-child-indent 4)
(setq c-basic-offset 4)

(global-whitespace-mode 1)

(load "intel-hex-mode.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(fill-column 80)
 '(package-selected-packages
   (quote
    (evil helm intel-hex-mode flycheck-haskell flycheck-clojure flycheck websocket tagedit smex rust-mode rainbow-delimiters projectile paredit nix-mode markdown-mode magit ido-ubiquitous haskell-mode groovy-mode git-rebase-mode git-commit-mode exec-path-from-shell editorconfig clojurescript-mode clojure-mode-extra-font-locking cljdoc cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path "~/.emacs.d/org-redmine/")
(require 'org-redmine)
(setq org-redmine-uri "https://redmine.wertschuetz.de")
(setq org-redmine-auth-netrc-use t)

(add-to-list 'load-path "~/.emacs.d/powerline/")
(require 'powerline)
(powerline-default-theme)
(set-face-attribute 'mode-line nil
		    :foreground "Black"
		    :background "DarkOrange"
		    :box nil)

(global-set-key (kbd "C-x g") 'magit-status)

(evil-mode 1)
