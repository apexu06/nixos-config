;;; completion.el --- Autocomplete with corfu -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:


(use-package corfu
  :init
  (setq corfu-auto t           ; complete without pressing TAB first
      corfu-auto-delay 0.0   ; seconds before popup appears
      corfu-preview-current nil
      corfu-auto-prefix 0    ; minimum characters before triggering
      corfu-cycle t)        ; cycle through candidates with TAB/S-TAB
  :config
  (global-corfu-mode)
  (require 'corfu-popupinfo)
  (setq corfu-popupinfo-delay (cons nil 0.1))
  (corfu-popupinfo-mode))


(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)    ; file paths
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)) ; words in open buffers

(use-package vertico
  :config
  (vertico-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package consult
  :config
   (setq consult-async-min-input 0))



(provide 'completion)
;;; completion.el ends here

