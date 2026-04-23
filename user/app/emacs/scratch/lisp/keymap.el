;;; keymap.el --- Keybinding definitions -*- lexical-binding: t; -*-

;; ─────────────────────────────────────────────
;; Dependencies
;; ─────────────────────────────────────────────

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
(use-package which-key)

(require 'general)
(require 'which-key)

(which-key-mode 1)
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
  :prefix "SPC m")  ; mode-specific bindings go here


;; ─────────────────────────────────────────────
;; Leader bindings
;; ─────────────────────────────────────────────

(my/leader
  ;; Group headers (no binding, just labels for which-key)
  "s" '(:ignore t :which-key "Search")
  "s f" '(find-file :which-key "File search")
  "b" '(:ignore t :which-key "Buffers")
  "w" '(:ignore t :which-key "Windows")
  ;; ...

  ;; Your bindings go here, e.g.:
  ;; "f f" '(find-file :which-key "Find file")
  )


(general-define-key
  :keymaps 'corfu-map
  "K" #'corfu-popupinfo-documentation)


;; ─────────────────────────────────────────────
;; Evil normal-state
;; ─────────────────────────────────────────────

(general-define-key
 :states 'normal
 ;; "g d" #'xref-find-definitions
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


