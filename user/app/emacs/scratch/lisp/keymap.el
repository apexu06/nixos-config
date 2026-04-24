;;; keymap.el --- Keybinding definitions -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:

(use-package evil
  :init
  (setq
    evil-want-keybinding nil
    evil-want-integration t
    evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package general)
(use-package which-key
  :config
  (which-key-mode 1))


;; ─────────────────────────────────────────────
;; Leader key definers
;; ─────────────────────────────────────────────

(general-create-definer my/leader
  :states '(normal visual motion)
  :keymaps 'override
  :prefix "SPC")

(general-create-definer my/local-leader
  :states '(normal visual motion)
  :keymaps 'override
  :prefix "SPC m")
;; ─────────────────────────────────────────────
;; Leader bindings
;; ─────────────────────────────────────────────

(my/leader
  "s" '(:ignore t :which-key "Search")
  "s f" '(consult-fd :which-key "Search files")
  "s r" '(consult-recent-file :which-key "Search recent files")
  "s g" '(consult-ripgrep :which-key "Grep")
  "s b" '(consult-buffer :which-key "Switch buffer")

  "f" '(:ignore t :which-key "Find")
  "f f" '(find-file :which-key "Find files")

  "b" '(:ignore t :which-key "Buffers")
  "w" '(:ignore t :which-key "Windows")

  "`" '(evil-switch-to-windows-last-buffer :which-key "Last buffer")
  "o" '(dired-jump :which-key "Dired")
  "e" '(flycheck-display-error-at-point :which-key "Show Error")
  "x" '(flycheck-list-errors :which-key "Show error list")
  ";" '(execute-extended-command :which-key "M-x")
  "DEL" '(kill-buffer-and-window :which-key "Close buffer")
)


(general-define-key
  :keymaps 'corfu-map
  "K" #'corfu-popupinfo-documentation)


(defun my/next-file-buffer ()
  "Cycle to the next buffer backed by a file."
  (interactive)
  (let ((current (current-buffer))
        (bufs (buffer-list)))
    ;; Move current buffer to the end of the list to start searching after it
    (setq bufs (append (cdr (memq current bufs)) bufs))
    (let ((next (cl-find-if #'buffer-file-name bufs)))
      (when next (switch-to-buffer next)))))

(defun my/prev-file-buffer ()
  "Cycle to the previous buffer backed by a file."
  (interactive)
  (let ((current (current-buffer))
        (bufs (reverse (buffer-list))))
    ;; Move current buffer to the end of the reversed list to search backwards
    (setq bufs (append (cdr (memq current bufs)) bufs))
    (let ((prev (cl-find-if #'buffer-file-name bufs)))
      (when prev (switch-to-buffer prev)))))

(general-define-key
  :states '(normal visual motion)
  "H" '(my/prev-file-buffer :which-key "Previous Buffer")
  "L" '(my/next-file-buffer :which-key "Next Buffer"))


;; ─────────────────────────────────────────────
;; Evil normal-state
;; ─────────────────────────────────────────────

(general-define-key
  :states 'normal
  "K" #'lsp-ui-doc-show
)


;; ─────────────────────────────────────────────
;; Evil insert-state
;; ─────────────────────────────────────────────

(general-define-key
 :states 'insert
 ;; "j k" #'evil-normal-state
 )


;; ─────────────────────────────────────────────
;; Evil visual-state
;; ─────────────────────────────────────────────

(general-define-key
 :states 'visual
 ;; "<" #'evil-shift-left
 ;; ">" #'evil-shift-right
 )


;; ─────────────────────────────────────────────
;; Global (all states, including minibuffer)
;; ─────────────────────────────────────────────

(general-define-key
 ;; "C-s" #'save-buffer
 )

(provide 'keymap)
;;; keymap.el ends here


