;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "apexu"
      user-mail-address "jj.zelger@proton.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "IosevkaTerm Nerd Font" :size 18 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "IosevkaTerm Nerd Font" :size 18))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq custom-theme-directory (expand-file-name "themes/" doom-user-dir))
(setq doom-theme 'doom-sora)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(global-flycheck-mode)
(setq evil-want-fine-undo t)
(setq lsp-auto-configure t)

(after! lsp-mode
  (require 'lsp-ui-doc))

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor nil)
  )


(map! :leader
      :n "`" #'evil-switch-to-windows-last-buffer
      :n "DEL" #'kill-current-buffer
      :n "o" #'dired

      :n "s f" #'projectile-find-file
      :n "s F" #'find-file
      :n "s g" #'+vertico/project-search
      :n "s b" #'consult-buffer



      :n "r n" #'lsp-rename
      :n "g d" #'+lookup/definition
      :n "g I" #'+lookup/implementations
      :n "g y" #'+lookup/type-definition
      :n "g r" #'+lookup/references

      :n "m r" #'recompile                            ; <leader>mr
      :n "m R" #'compile                              ; <leader>mR

      :n "l g" #'magit

      :n "e"       #'flycheck-list-errors               ; <leader>e
      :n "] d"     #'flycheck-next-error                  ; ]d
      :n "[ d"     #'flycheck-previous-error              ; [d
      :n "] e"     #'+diagnostics/next-error              ; ]e
      :n "[ e"     #'+diagnostics/previous-error          ; [e
      )

(map!
 :n "L" #'next-buffer
 :n "H" #'previous-buffer
 :n "K" #'lsp-ui-doc-glance
 :n "C-h" #'evil-window-left
 :n "C-j" #'evil-window-down
 :n "C-k" #'evil-window-up
 :n "C-l" #'evil-window-right
 )
