;(when (memq window-system '(mac ns))
;  mac-only-code))
;(when window-system
;  gui-only-code)
;(when (eq window-system 'x)
;  linux-only-code)

;(server-start)

(defun prepend-path ( my-path ) 
  (setq load-path (cons (expand-file-name my-path) load-path)))

(defun append-path ( my-path ) 
  (setq load-path (append load-path (list (expand-file-name my-path)))))

(prepend-path "~/.emacs.d/library")
(setq backup-directory-alist `(("." . "~/.saves")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package Manager
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
;(add-to-list 'package-archives ;; more stable repository
;             '("marmalade" . "http://marmalade-repo.org/packages/"))
;(add-to-list 'package-archives ;; bleeding-edge melpa
;             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; initialize packages

;; Comment out if you've already loaded this package...
(require 'cl-lib)

(defvar my-packages
  '(ack-and-a-half zenburn-theme ivy counsel diff-hl flycheck flymake-yaml flymake-shell flymake-ruby auto-complete yasnippet nyan-mode tabbar web-mode color-theme yaml-mode exec-path-from-shell)
  "A list of packages to ensure are installed at launch.")
;; linux-unsupported: magit 

(defun my-packages-installed-p ()
  (cl-loop for p in my-packages
           when (not (package-installed-p p)) do (cl-return nil)
           finally (cl-return t)))

(unless (my-packages-installed-p)
  ;; check for new packages (package versions)
  (package-refresh-contents)
  ;; install the missing packages
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs Invocation Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(nyan-mode t)
(scroll-bar-mode -1)
(global-hi-lock-mode 1)
(global-diff-hl-mode) ;VCS file diff hightlighting

(setq inhibit-startup-message t)

(add-hook 'find-file-hook (lambda () (linum-mode 1))) ;line numbers
(add-hook 'after-init-hook 'global-flycheck-mode) ;flycheck (flymake replacement)

(when (memq window-system '(mac ns)) 
  (setq inhibit-splash-screen t) ; Speedup boot time, but causes issues for Linux
  (delete-file "~/Library/Colors/Emacs.clr") ; Failed to initialize color list unarchiver error
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance Customizations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(require 'color-theme)

(if (window-system)
    (require 'desert)
  (require 'zenburn))

(eval-after-load "color-theme"
  '(progn
     (if (window-system)
         (color-theme-desert)
       (color-theme-zenburn))))

;; Tab Bar
(when (memq window-system '(mac ns))
  (require 'awesome-tab)
  (awesome-tab-mode t)
  (global-set-key (kbd "M-{") 'awesome-tab-backward)
  (global-set-key (kbd "M-}") 'awesome-tab-forward)
  )
(when (eq window-system 'x)
  (require 'tabbar)
  (tabbar-mode t)
  (global-set-key (kbd "M-{") 'tabbar-backward)
  (global-set-key (kbd "M-}") 'tabbar-forward)
  )

;; Mode-line (my custom)
(load "mode-line")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shortcuts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\M-w" 'tony-kill-buffer)
(global-set-key "\M-s" 'multi-occur-in-matching-buffers)
(global-set-key "\C-q" 'mark-whole-buffer)
(global-set-key [C-tab] 'other-window)
(global-set-key (kbd "C-c C-f") 'ffap)
(global-set-key (kbd "C-c i r b") 'inf-ruby)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "C-i") 'scroll-down) ; C-v
(global-set-key (kbd "C-j") 'scroll-up)   ; M-v
(global-set-key (kbd "<M-up>") 'scroll-down)
(global-set-key (kbd "<M-down>") 'scroll-up)
(setq x-super-keysym 'meta)

; Make Command act as Meta, Option as Alt, right-Option as Super
(when (memq window-system '(mac ns))
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'alt)
  (setq mac-right-option-modifier 'super)
  )

; Increase/decrease font size
(global-set-key "\M-=" 'text-scale-increase)
(global-set-key "\M--" 'text-scale-decrease)

; C++ Jump to header/implementation
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (eq window-system 'x)
  (require 'cl-lib)
;  (if window-system
;      (require 'p4))
  )

(linum-mode t)
(delete-selection-mode 1) ;; typing over selected text overwrites it
(setq-default indent-tabs-mode nil) ;; turn tabs into all spaces

;;; projectile (only useful if emacs is used as an IDE)
(when (memq window-system '(mac ns))
  (projectile-global-mode t)) ; project management

;;; yasnippet, should be loaded before auto complete so that they can work together
;(when (memq window-system '(mac ns))
;  (require 'yasnippet)
;  (yas-global-mode 1)
;  )

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(when window-system
  (require 'auto-complete-config)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (ac-config-default)
  ;;; set the trigger key so that it can work together with yasnippet on tab key,
  ;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
  ;;; activate, otherwise, auto-complete will
  (ac-set-trigger-key "TAB")
  (ac-set-trigger-key "<tab>")
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Parenthesis Matching
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(show-paren-mode 1) ;Parentheses matching
;(set-face-foreground 'show-paren-match-face "#d30102")
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert
the character typed."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
    ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t                    (self-insert-command (or arg 1))) ))
;; Use "%" to jump to the matching parenthesis.
(global-set-key "%" `goto-match-paren)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ivy + Counsel + Swiper
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key (kbd "C-M-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Large File Hook
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Display ANSI colors for read-only files
(when window-system

  (defun display-ansi-colors ()
    (interactive)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))

  (defun ac ()
    (interactive)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (region-beginning) (region-end))))

  (defun color-medium-size-files-hook ()
    "If a file is under a given size, allow ANSI colors."
    (when (< (buffer-size) (* 10 1024 1024))
      (interactive)
      (let ((inhibit-read-only t))
        (ansi-color-apply-on-region (point-min) (point-max)))))

  ;; Make large files read only (likely log files)
  (defun make-large-file-read-only-hook ()
    "If a file is over a given size, make the buffer read only."
    (when (> (buffer-size) (* 1024 1024))
      (setq buffer-read-only t)
      (buffer-disable-undo)))

  (add-hook 'find-file-hook 'color-medium-size-files-hook)
  (add-hook 'find-file-hook 'make-large-file-read-only-hook)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUA Mode Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (memq window-system '(mac ns))
  (require 'web-mode)
  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-indent-style 2)
    )
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-hook 'web-mode-hook 'my-tab-fix)
  (add-hook 'web-mode-hook  'my-web-mode-hook)
  (setq css-indent-offset 2)
  )

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'log-mode)
(add-to-list 'auto-mode-alist '("\\(log\\|log2\\|txt\\|retry\\|out\\)\\'" . log-mode))

(add-to-list 'auto-mode-alist '("\\emacs\\'" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\(alias\\|aliases\\|rc\\|_custom\\)\\'" . shell-script-mode))

;; Octave settings
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
(add-hook 'octave-mode-hook (lambda () (linum-mode 1)))

;; Ruby settings
;;
(when (memq window-system '(mac ns))
  (require 'rubocop)
  (add-hook 'ruby-mode-hook 'rubocop-mode)
  (require 'rvm) ; RVM matching with shell settings
  (rvm-use-default)
  )

(add-to-list 'auto-mode-alist '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.export\\'" . makefile-makepp-mode))

;; Verilog Settings
;; 
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t ) 

;; Any files in verilog mode should have their keywords colorized 
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1))) 
;; Any files that end in .v, .sv or .sv should be in verilog mode 
(add-to-list 'auto-mode-alist '("\\.\\(?:v\\|vh\\|vcp\\|vx\\|vxh\\|sv\\|svh\\|svp\\|svp.eperl\\|spec\\)\\'" . verilog-mode))
(add-to-list 'auto-mode-alist '("\\tmp.[0-9]+.[0-9]+\\'" . verilog-mode))

;; User customization for Verilog mode
(setq verilog-indent-level             2
      verilog-indent-level-module      2
      verilog-indent-level-declaration 2
      verilog-indent-level-behavioral  2
;       verilog-indent-level-directive   1
;       verilog-case-indent              2
;       verilog-auto-newline             t
;       verilog-auto-indent-on-newline   t
      verilog-tab-always-indent        nil
;       verilog-auto-endcomments         t
;       verilog-minimum-comment-distance 40
;       verilog-indent-begin-after-if    t
;       verilog-auto-lineup              'declarations
;       verilog-highlight-p1800-keywords nil
;       verilog-linter			 "my_lint_shell_command"
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other Language Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'flymake-ruby)
;(add-hook 'ruby-mode-hook 'flymake-ruby-load)
(add-hook 'sh-mode-hook         'flymake-shell-load)
(add-hook 'yaml-mode-hook       'flymake-yaml-load)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Filename copy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KillBuffer Feature
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tony-kill-buffer ()
   ;; Kill default buffer without the extra emacs questions
   (interactive)
   (kill-buffer (buffer-name))
   (set-name))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SmartTab Feature
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Smart-tab, indent, autocomplete, minibuffer safe
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
  (if (minibufferp)
      (dabbrev-expand nil)
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (dabbrev-expand nil)
        (indent-according-to-mode)))))

;;; Indent-or-expand (auto completion)
(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'smart-tab))

(add-hook 'c-mode-hook          'my-tab-fix)
(add-hook 'sh-mode-hook         'my-tab-fix)
(add-hook 'lisp-mode-hook       'my-tab-fix)
(add-hook 'ruby-mode-hook       'my-tab-fix)
(add-hook 'yaml-mode-hook       'my-tab-fix)
(add-hook 'verilog-mode-hook    'my-tab-fix)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated/Disabled Functionalities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialize emacs with shell envvars (not used since currently not running shell in emacs)
;(when (memq window-system '(mac ns))
;  (exec-path-from-shell-initialize))

;; Interactively Do Things
;(ido-mode t)
;(flx-ido-mode t)

;; Display ido results vertically, rather than horizontally
;  (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
;  (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
;  (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
;  (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
;    (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
;    (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
;(add-hook 'ido-setup-hook 'ido-define-keys)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance Customizations
;; (Powerline -- I didn't like it as much as my own)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(set-face-attribute 'mode-line-buffer-id nil :foreground "black")
;(set-face-attribute 'mode-line nil
;                    :foreground "Black"
;                    :background "DarkOrange"
;                    :box nil)
;(require 'powerline)
;(powerline-default-theme)
;(when (memq window-system '(mac ns))
;  (setq ns-use-srgb-colorspace nil)) ;; fix arrow bg color on macos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tramp Mode Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(when (memq window-system '(mac ns))
;  (setq tramp-default-method "ssh")
;  (let ((process-environment tramp-remote-process-environment))
;    (setenv "INSIDE_EMACS" 1)
;    (setq tramp-remote-process-environment process-environment))
;  (add-to-list 'tramp-remote-process-environment "INSIDE_EMACS=1")
;  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(package-selected-packages
   (quote
    (zenburn-theme flx-ido flycheck flymake-yaml flymake-shell flymake-ruby auto-complete yasnippet magit nyan-mode web-mode color-theme yaml-mode exec-path-from-shell)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(add-to-list 'default-frame-alist ;; nice monospaced, anti-aliased font
(when (memq window-system '(mac ns))
  '(font . "DejaVu Sans Mono-14")
  ))
;(if (memq window-system '(mac ns))
;    '(font . "DejaVu Sans Mono-14")
;  '(font . "DejaVu LGC Sans Mono-12") ; '(font . "DejaVu Sans Mono-12")) ; RH6
;  ))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
