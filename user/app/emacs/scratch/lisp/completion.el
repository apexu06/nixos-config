;;; completion.el --- Autocomplete with corfu -*- lexical-binding: t; -*-

;;; Code:

;; ─────────────────────────────────────────────
;; Corfu — inline completion popup
;; ─────────────────────────────────────────────

(use-package corfu
  :init
  (setq corfu-auto t           ; complete without pressing TAB first
      corfu-auto-delay 0.01   ; seconds before popup appears
      corfu-auto-prefix 0    ; minimum characters before triggering
      corfu-cycle t)        ; cycle through candidates with TAB/S-TAB
  :config 
  (global-corfu-mode)
  (require 'corfu-popupinfo)
  (setq corfu-popupinfo-delay (cons nil 0.1))
  (corfu-popupinfo-mode))

;; ─────────────────────────────────────────────
;; Cape — extra completion sources fed into corfu
;; ─────────────────────────────────────────────

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)    ; file paths
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)) ; words in open buffers
