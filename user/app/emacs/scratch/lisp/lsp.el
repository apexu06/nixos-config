;;; lsp.el --- Treesitter and lsp definitions -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:

(use-package lsp-mode
  :init
  :config
  (setq lsp-idle-delay 0.0
	lsp-response-timeout 5)
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (rust-ts-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

;; ------------ LANGUAGES --------------

(use-package rust-mode
  :init
  (setq
    rust-format-on-save t
    rust-mode-treesitter-derive t))

(use-package nix-mode
    :mode "\\.nix\\'")

(provide 'editing)
;;; lsp.el ends here

