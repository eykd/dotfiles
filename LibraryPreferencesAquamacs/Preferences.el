;; This is the Aquamacs Preferences file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Aquamacs Emacs. If errors occur, Aquamacs will stop
;; evaluating this file and print errors in the *Messags* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

(server-start)

;; Settings
(tool-bar-mode -1)
(set-fringe-style t)

(require 'color-theme)
(color-theme-initialize)
(color-theme-tango)

(setq rnc-enable-flymake t
      rnc-jing-jar-file (expand-file-name "/usr/local/Cellar/jing/20091111/libexec/bin/jing.jar")
)
