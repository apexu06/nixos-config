;;; doom-sora-theme.el --- Sora colorscheme for Doom Emacs -*- lexical-binding: t; -*-
;; Ported from https://github.com/Aejkatappaja/sora

(require 'doom-themes)

(defgroup doom-sora-theme nil
  "Options for the doom-sora theme."
  :group 'doom-themes)

(def-doom-theme doom-sora
    "A deep dark theme with ethereal cyan and muted accents. Ported from Sora.nvim."

  ;; name        default   256       16
  ((bg         '("#0e1018" "black"   "black"))
   (fg         '("#c8d0e0" "#c8d0e0" "brightwhite"))

   (bg-alt     '("#131620" "black"   "black"))
   (fg-alt     '("#8898b8" "#8898b8" "white"))

   (base0      '("#0a0c12" "black"   "black"))
   (base1      '("#131620" "#131620" "brightblack"))
   (base2      '("#1a1e2a" "#1a1e2a" "brightblack"))
   (base3      '("#222636" "#222636" "brightblack"))
   (base4      '("#2e3448" "#2e3448" "brightblack"))
   (base5      '("#8898b8" "#8898b8" "brightblack"))
   (base6      '("#a0aec0" "#a0aec0" "white"))
   (base7      '("#b8c4d8" "#b8c4d8" "white"))
   (base8      '("#c8d0e0" "#c8d0e0" "brightwhite"))

   (grey        base4)
   (red        '("#d0909c" "#d0909c" "red"))
   (orange     '("#d0a888" "#d0a888" "brightred"))
   (green      '("#90c8a0" "#90c8a0" "green"))
   (teal       '("#78b8b0" "#78b8b0" "brightgreen"))
   (yellow     '("#d4b878" "#d4b878" "yellow"))
   (blue       '("#8898b8" "#8898b8" "blue"))
   (dark-blue  '("#6678a0" "#6678a0" "darkblue"))
   (magenta    '("#b0a0d8" "#b0a0d8" "magenta"))
   (violet     '("#b0a0d8" "#b0a0d8" "brightmagenta"))
   (cyan       '("#80c8e0" "#80c8e0" "cyan"))
   (dark-cyan  '("#5aabb8" "#5aabb8" "darkcyan"))

   ;; face categories
   (highlight      cyan)
   (vertical-bar   base2)
   (selection      base3)
   (builtin        cyan)
   (comments      '("#586478" "#586478" "brightblack"))  ; darker than base5
   (doc-comments  '("#586478" "#586478" "brightblack"))  ; darker than base5
   (constants      yellow)
   (functions      cyan)
   (keywords       magenta)
   (methods        cyan)
   (operators      teal)
   (type           teal)
   (strings        green)
   (variables      fg)
   (numbers        yellow)
   (region         base3)
   (error          red)
   (warning        orange)
   (success        green)
   (vc-modified    yellow)
   (vc-added       green)
   (vc-deleted     red)

   (modeline-fg     fg)
   (modeline-bg     base2)
   (modeline-fg-alt base5)
   (modeline-bg-alt base1)
   (-modeline-pad 4))

  ;;;; Base theme face overrides
  (((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground cyan :bold t)
   ((font-lock-comment-face &override) :slant 'italic)
   ((font-lock-doc-face &override) :slant 'italic)
   (fringe :background bg)
   (hl-line :background base2)

   ;;;; doom-modeline
   (doom-modeline-bar :background cyan)
   (doom-modeline-buffer-path :foreground cyan)
   (doom-modeline-buffer-major-mode :foreground cyan :bold t)

   ;;;; magit
   ((magit-diff-added-highlight &override) :background (doom-blend green bg 0.1))
   ((magit-diff-removed-highlight &override) :background (doom-blend red bg 0.1))

   ;;;; org-mode
   (org-block :background base1)
   (org-block-begin-line :background base2 :foreground base5 :slant 'italic)
   ((org-quote &override) :background base1)
   (org-level-1 :foreground cyan :bold t)
   (org-level-2 :foreground magenta)
   (org-level-3 :foreground teal)
   (org-level-4 :foreground yellow)

   ;;;; company
   (company-tooltip :background base2 :foreground fg)
   (company-tooltip-selection :background base3 :foreground cyan)
   (company-tooltip-annotation :foreground base5)
   (company-scrollbar-bg :background base2)
   (company-scrollbar-fg :background base4)

   ;;;; vertico / marginalia
   (vertico-current :background base3)

   ;;;; treemacs
   (treemacs-root-face :foreground cyan :bold t)))

;;; doom-sora-theme.el ends here
