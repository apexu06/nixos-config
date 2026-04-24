;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "apexu"
      user-mail-address "jj.zelger@proton.me")

(setq doom-font (font-spec :family "IosevkaTerm Nerd Font" :size 18 :weight 'semi-bold)
      doom-variable-pitch-font (font-spec :family "IosevkaTerm Nerd Font" :size 18))
(setq custom-theme-directory (expand-file-name "themes/" doom-user-dir))
(setq doom-theme 'doom-sora)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

(setq evil-want-fine-undo t)
(setq lsp-auto-configure t)

(after! lsp-mode
  (require 'lsp-ui-doc))

(after! lsp-ui
  (setq
   lsp-ui-sideline-enable nil
   lsp-ui-doc-position 'at-point
   lsp-ui-doc-show-with-cursor nil))


(map! :leader
      :n "`" #'evil-switch-to-windows-last-buffer
      :g "DEL" #'kill-buffer-and-window
      :n "o" #'dired-jump

      :n "s f" #'projectile-find-file
      :n "s F" #'find-file
      :n "s g" #'+vertico/project-search
      :n "s b" #'consult-buffer
      :n "s r" #'consult-recent-file

      :n "r n" #'lsp-rename
      :n "g d" #'+lookup/definition
      :n "g I" #'+lookup/implementations
      :n "g y" #'+lookup/type-definition
      :n "g r" #'+lookup/references

      :n "m r" #'recompile
      :n "m R" #'compile

      :n "l g" #'magit

      :n "x" #'flycheck-list-errors
      :n "] e" #'flycheck-next-error
      :n "[ e" #'flycheck-previous-e)

(map!
 :n "L" #'next-buffer
 :n "H" #'previous-buffer
 :g "C-h" #'evil-window-left
 :g "C-j" #'evil-window-down
 :g "C-k" #'evil-window-up
 :g "C-l" #'evil-window-right)

(map!
 :n "K" #'lsp-ui-doc-glance
 :leader "RET" #'+workspace:new
 :leader "d" #'+workspace:delete)
