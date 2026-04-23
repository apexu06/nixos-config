(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (rust-ts-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

(use-package lsp-ui 
  :init
  (setq 
    lsp-ui-sideline-enable nil)
  :commands lsp-ui-mode)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
  (setq treesit-font-lock-level 5)


(use-package flycheck
  :ensure t
  :config
  (setq 
  ;   flycheck-display-errors-delay nil
  ;   flycheck-display-errors-function nil
    flycheck-help-echo-function nil)
  (add-hook 'after-init-hook #'global-flycheck-mode))


;; ------------ LANGUAGES --------------

(use-package rust-mode
  :init
  (setq 
    rust-format-on-save t
    rust-mode-treesitter-derive t))

