;;; ui.el --- UI -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:

(use-package lsp-ui
  :init
  (setq
    lsp-ui-sideline-enable nil
    lsp-ui-doc-position 'at-point
  )
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
  :init
  (setq
     flycheck-auto-display-errors-after-checking nil
     flycheck-help-echo-function nil)
  :config
  (global-flycheck-mode)
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*Flycheck errors*" eos)
                (display-buffer-reuse-window
                 display-buffer-in-side-window)
                (side            . bottom)
                (reusable-frames . visible)
                (window-height   . 0.33))))

(use-package flycheck-pos-tip
   :after flycheck
   :config
   (setq
      flycheck-pos-tip-timeout 999999)
   :init
   (flycheck-pos-tip-mode))

(use-package indent-bars
  :custom
  (indent-bars-starting-column 0)
  (indent-bars-no-descend-lists 'skip) ; prevent extra bars in nested lists + skip intermediate bars
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  :hook (prog-mode . indent-bars-mode))

(use-package diff-hl
  :straight t
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)  ; update signs without saving
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
  (setq diff-hl-fringe-bmp-function #'diff-hl-fringe-bmp-from-type))
  (custom-set-faces
    '(diff-hl-insert ((t (:background "#1e3a2a" :foreground "#1e3a2a"))))
    '(diff-hl-change ((t (:background "#1a2a3a" :foreground "#1a2a3a"))))
    '(diff-hl-delete ((t (:background "#3a1a1a" :foreground "#3a1a1a")))))


(use-package tokyonight-themes
  :straight (:host github :repo "xuchengpeng/tokyonight-themes")
  :config
  (load-theme 'tokyonight-night :no-confirm))

(set-face-attribute 'default nil :family "IosevkaTerm Nerd Font" :height 135)
(set-face-attribute 'fixed-pitch nil :family "IosevkaTerm Nerd Font" :height 135)
(set-face-attribute 'variable-pitch nil :family "IosevkaTerm Nerd Font" :height 135)


(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)


(provide 'ui)
;;; ui.el ends here
