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


(map!
     :leader :n "`" #'evil-switch-to-windows-last-buffer
     :leader :n "DEL" #'doom/kill-this-buffer-in-all-windows

     :leader :n "s f" #'+default/find-file-under-here
     :leader :n "s F" #'find-file
     :leader :n "s g" #'+vertico/project-search
     :leader :n "s b" #'consult-buffer

     :leader :n "r n" #'lsp-rename                  
     :leader :n "c a" #'lsp-execute-code-action              ; <leader>ca - doom has this
     :leader :n "g d" #'lsp-find-definition                  ; <leader>gd - doom has this
     :leader :n "g D" #'lsp-find-declaration                 ; <leader>gD
     :leader :n "g I" #'lsp-find-implementation              ; <leader>gI
     :leader :n "g y" #'lsp-find-type-definition             ; <leader>gy
     :leader :n "g r" #'lsp-find-references                  ; <leader>gr

     :leader :n "m r" #'recompile                            ; <leader>mr
     :leader :n "m R" #'compile                              ; <leader>mR

     :leader :n "l g" #'magit                        ; lazygit → magit
 )
