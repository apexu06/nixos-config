;;; util.el --- Utility functions and packages -*- lexical-binding: t; -*-

;;; Commentary:
;;; Code:

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:

(use-package envrc
  :init
  (envrc-global-mode))

(setq-default indent-tabs-mode nil)

(setq
  use-dialog-box nil
  ring-bell-function 'ignore
  inhibit-startup-message t
  make-backup-files nil
  auto-save-default nil
  global-auto-revert-non-file-buffers t
)

(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)


(provide 'util)
;;; util.el ends here


