
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (require 'package)
;; (setq package-enable-at-startup nil)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;; (package-initialize)

;; (put 'dired-find-alternate-file 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://github.com/jwiegley/use-package
;;
;;  (use-package color-moccur
;;
;;    :ensure t  <- automatically install package if it's not installed
;;
;;    :defer t   <- prevent the package from loading until it detects it's needed
;;
;;    :hook  <- allows adding functions onto package hooks.
;;
;;    :commands  <- it creates autoloads for those commands and defers loading of the module until they are used.
;;    (isearch-moccur isearch-all)
;;
;;    :bind (("M-s O" . moccur)    <- for key bindings (M-x describe-personal-keybindings)
;;           :map isearch-mode-map  <- binding within local keymaps
;;           ("M-o" . isearch-moccur)
;;           ("M-O" . isearch-moccur-all))
;;
;;    :bind-keymap
;;    ("C-c p" . isearch-mode-map)
;;
;;    :init   <- excute 'setq isearch-lazy-highlight t' before package is load
;;    (setq isearch-lazy-highlight t)
;;
;;    :config <- can be used to execute code after a package is loaded
;;    (use-package moccur-edit))
;;
;;    :custom  <- allows customization of package custom variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(recentf-mode 1)
(setq recentf-max-saved-items 50)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(package-install 'auctex)
(package-install 'flyspell)
(package-install 'projectile)
(package-install 'ag)
(package-install 'pdf-tools)

(eval-when-compile
  (require 'use-package))



(require 'bind-key)




(use-package use-package
  :config
  (package-install 'diminish)
  (package-install 'bind-key))



(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :custom (hs-hide-comments-when-hiding-all t)
  :diminish hs-minor-mode
  :bind (("C-(" . hs-hide-all)
         ("C-)" . hs-show-all)
         ("C-_" . hs-toggle-hiding)
         ("C-+" . hs-hide-level)))

;;(require 'javaimp)
;;(add-to-list 'javaimp-import-group-alist
;;             '("\\`my.company\\." . 80))
;;(keymap-global-set "C-c J v" #'javaimp-visit-project)
;;(add-hook 'java-mode-hook #'javaimp-minor-mode)

(use-package pdf-tools
   :pin manual
   :config
   (pdf-tools-install)
   (setq-default pdf-view-display-size 'fit-width)
   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
   :custom
   (pdf-annot-activate-created-annotations t "automatically annotate highlights"))


(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

(global-set-key (kbd "C-c f") 'flyspell-buffer )

(require 'clang-format)

(use-package lsp-mode
  :ensure t
  :hook ((c++-mode    . lsp)
         (c-mode      . lsp)
         (python-mode . lsp)
         (java-mode   . lsp)
         (lsp-mode    . lsp-enable-which-key-integration))

  :custom
  ;; (cquery-executable "~/tools/cquery/build/release/bin/cquery")
  ;; (ccls-executable "~/ccls/Release/ccls")
  (lsp-log-io nil)
  (lsp-keymap-prefix "C-'")
  (lsp-headerline-breadcrumb-enable nil))

(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :ensure t
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map ("M-9" . lsp-treemacs-error-list)))


(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :diminish lsp-ui-mode
  :commands lsp-ui-mode
  :bind ("C-c u" . lsp-ui-imenu)
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
  (lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic)))))

  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-update-mode t)



  :config
  ;; Use lsp-ui-doc-webkit only in GUI
  (setq lsp-ui-doc-use-webkit t)
  ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
  ;; https://github.com/emacs-lsp/lsp-ui/issues/243
  (defadvice lsp-ui-imenu (after hide-lsp-ui-imenu-mode-line activate)
    (setq mode-line-format nil)))

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package tex
  :ensure auctex)

(use-package lsp-ivy
  :ensure t
  :defer t
  :diminish lsp-ivy-mode
  :bind
  ("C-' i w" . lsp-ivy-workspace-symbol)
  ("C-' i g" . lsp-ivy-global-workspace-symbol))



(use-package lsp-java
  :hook (java-mode .
                   (lambda ()
                     (setq-default c-basic-offset 4
                                   c-set-style "java")
                     (lsp-deferred)))
  :init
  (setq lsp-java-inhibit-message nil)
  (setq lsp-java-java-path "/usr/lib/jvm/java-11-openjdk-amd64/bin/java")
  (setq lsp-java-save-actions-organize-imports t)
  :ensure t
  :defer t)



(use-package abbrev
  :diminish abbrev-mode)



(use-package eldoc
  :diminish eldoc-mode)



(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (which-key-mode))



;(use-package flycheck
;  :ensure t
;  :diminish flycheck-mode
;  :commands global-flycheck-mode)



(use-package company
  :ensure t
  :defer t
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay              0
        company-minimum-prefix-length   3
        company-show-numbers            nil
        company-tooltip-limit           5
        company-dabbrev-downcase        nil)
  :bind ("C-;" . company-complete-common))



(use-package dap-mode
  :ensure t
  :defer t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))



(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method         'bitmap
        highlight-indent-guides-bitmap-funtion 'highlight-indent-guides-crep-bitmap-line))



(use-package multi-term
  :ensure t
  :bind ("C-c C-j" . term-line-mode)
        ("C-c C-k" . term-char-mode)
        ("C-c t" . multi-term))



(use-package magit :ensure t)



(use-package xcscope
  :ensure t
  :hook (prog-mode . cscope-minor-mode))



(use-package cmake-mode
  :ensure t
  :defer t)



(use-package cquery
  :ensure t)



(use-package ccls
  :ensure t
  :bind ("C-' g c" . ccls-call-hierarchy)
        ("C-' g m" . ccls-member-hierarchy))



(use-package lsp-jedi
  :ensure t)



(use-package multiple-cursors
  :ensure t
  :bind ("C-<" . mc/mark-all-like-this))

;(setq calendar-holidays (append calendar-holidays korean-holidays))

(use-package ace-mc
  :ensure t
  :bind ("C->" . ace-mc-add-multiple-cursors)
        ("C-M->" . ace-mc-add-single-cursors))


;(autoload 'TeX-load-hack
;  (expand-file-name "tex-site.el"
;                    (file-name-directory load-file-name)))
;(TeX-load-hack)
(setq TeX-auto-save t)
(setq TeX-parse-self t)


;;;;;; dissable tab-key from indenting ;;;;;;
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(defvaralias 'python-indent-shift-right 'tab-width)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;; My Function ;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-doc-comment () (interactive)
       (insert "/**\n * Brief description. Long description. \n * @param \n * @return \n * @exception \n * @see \n * @author \n */"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;; Personal global-set-key ;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-n") (lambda () (interactive) (forward-line 10)))
(global-set-key (kbd "M-p") (lambda () (interactive) (previous-line 10)))
(global-set-key (kbd "M-\\") 'replace-string)
;(global-set-key (kbd "C-M-c") 'insert-doc-comment)



(global-set-key (kbd "C-M-p") 'previous-buffer)
(global-set-key (kbd "C-M-n") 'next-buffer)
(global-set-key [f4] 'toggle-truncate-lines)

(global-set-key [(control f3)]  'cscope-set-initial-directory)
(global-set-key [(control f4)]  'cscope-unset-initial-directory)
(global-set-key [(control f5)]  'cscope-find-this-symbol)
(global-set-key [(control f6)]  'cscope-find-global-definition)
(global-set-key [(control f7)]
  'cscope-find-global-definition-no-prompting)
(global-set-key [(control f8)]  'cscope-pop-mark)
(global-set-key [(control f9)]  'cscope-history-forward-line)
(global-set-key [(control f10)] 'cscope-history-forward-file)
(global-set-key [(control f11)] 'cscope-history-backward-line)
(global-set-key [(control f12)] 'cscope-history-backward-file)
     (global-set-key [(meta f9)]  'cscope-display-buffer)
     (global-set-key [(meta f10)] 'cscope-display-buffer-toggle)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(display-time)
(setq display-time-day-and-date t)



(put 'forward-list 'disabled nil)
(put 'backward-list 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
