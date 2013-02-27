(require 'cl)                ; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes
(setq
 el-get-sources
 '(
   (:name buffer-move            ; have to add your own keys
      :after (lambda ()
           (global-set-key (kbd "<C-S-up>")     'buf-move-up)
           (global-set-key (kbd "<C-S-down>")   'buf-move-down)
           (global-set-key (kbd "<C-S-left>")   'buf-move-left)
           (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name feature-mode
      :type git
      :url "git://github.com/michaelklishin/cucumber.el.git"
      :features feature-mode
      :compile "feature-mode.el"
      )

   (:name expand-region
      :type git
      :url "git://github.com/magnars/expand-region.el.git"
      :features expand-region
      :compile "expand-region.el"
      :after (lambda ()
           (global-set-key (kbd "C-'") 'er/expand-region)
           (global-set-key (kbd "C-,") 'er/contract-region)
           )
      )

   (:name smex                ; a better (ido like) M-x
      :after (lambda ()
           (setq smex-save-file "~/.emacs.d/.smex-items")
           (global-set-key (kbd "M-x") 'smex)
           (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name goto-last-change        ; move pointer back to last change
      :after (lambda ()
           ;; when using AZERTY keyboard, consider C-x C-_
           (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   (:name zencoding-mode
	  :after (lambda ()
		   (add-hook 'sgml-mode-hook 'zencoding-mode) ;; Auto-start on any markup modes
		   ))
   )
 )

;; now set our own packages
(setq
 my:el-get-packages
 '(
   autopair
   color-theme          ; nice looking emacs
   color-theme-tango    ; check out color-theme-solarized
   el-get               ; el-get is self-hosting
   escreen              ; screen for emacs, C-\ C-h
   fill-column-indicator; show a vertical line at 80 columns
   fuzzy-format         ; take a neutral stance in the war of tabs and spaces
   iy-go-to-char        ; https://github.com/emacsmirror/iy-go-to-char
   switch-window        ; takes over C-x o
   python-mode          ; just like it says
   textmate             ; textmate-mode!
   whitespace           ; whitespace tricks
   zencoding-mode       ; http://www.emacswiki.org/emacs/ZenCoding
   )
 )

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (el-get-executable-find "cvs")
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn            ; M-x svn-status
           )
    do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)        ; no splash screen, thanks
(line-number-mode 1)            ; have line numbers and
(column-number-mode 1)            ; column numbers in the mode line

(tool-bar-mode -1)            ; no tool bar with icons


;; Tab width to 4
(setq default-tab-width 2)

(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13")
  (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)            ; highlight current line
(global-linum-mode 1)            ; add line numbers on the left

;; avoid compiz manager rendering bugs
;(add-to-list 'default-frame-alist '(alpha . 100))

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  )

;; Use the clipboard, pretty please, so that copy/paste "works"
;(setq x-select-enable-clipboard t)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
;; (setq ido-show-dot-for-dired t)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
               (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

;;; Buffer scrolling w/o moving the cursor
;;; http://www.emacswiki.org/cgi-bin/wiki/BufferScrolling
(global-set-key "\M-n"  (lambda () (interactive) (scroll-up   1)) )
(global-set-key "\M-p"  (lambda () (interactive) (scroll-down 1)) )
(global-set-key "\M-\S-n"  (lambda () (interactive) (scroll-up   5)) )
(global-set-key "\M-\S-p"  (lambda () (interactive) (scroll-down 5)) )
;; Move more quickly
(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

;; Join the following line onto this one.
(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

;;; Textmate mode!
(textmate-mode t)

;;; yasnippet!
;;(yas-global-mode 1)

;; iy-go-to-char:
(require 'iy-go-to-char)
(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c F") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c ;") 'iy-go-to-char-continue)
(global-set-key (kbd "C-c ,") 'iy-go-to-char-continue-backward)

;; Kill trailing whitespace!
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Whitespace mode
(require 'whitespace)
;; (setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-style '(face empty tabs trailing))
(global-whitespace-mode 1)

;; Add a column marker at column 80 in python
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "darkblue")
(setq fci-rule-column 80)
(add-hook 'python-mode-hook 'fci-mode)

;; (define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;; (global-fci-mode 1)

;; Autopair!
(require 'autopair)
(autopair-global-mode 1)

;; Set up fuzzy formatting
(require 'fuzzy-format)
(setq fuzzy-format-default-indent-tabs-mode nil)
(global-fuzzy-format-mode t)

;; Let SGML-based modes guess at indentation.
(add-hook 'sgml-mode-hook
  (lambda ()
    ;; Default indentation to 2, but let SGML mode guess, too.
    (set (make-local-variable 'sgml-basic-offset) 2)
    (sgml-guess-indent)))

;; Mumamo is making emacs 23.3 freak out:
(when (and (equal emacs-major-version 23)
           (equal emacs-minor-version 3))
  (eval-after-load "bytecomp"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function))
  ;; tramp-compat.el clobbers this variable!
  (eval-after-load "tramp-compat"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function)))

;; Flymake+pyflakes
(when (load "flymake" t)
         (defun flymake-pycheckers-init ()
           (let* ((temp-file (flymake-init-create-temp-buffer-copy
                              'flymake-create-temp-inplace))
              (local-file (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
             (list (expand-file-name "~/bin/pycheckers") (list local-file))))

         (add-to-list 'flymake-allowed-file-name-masks
                  '("\\.py\\'" flymake-pycheckers-init)))

(add-hook 'find-file-hook 'flymake-find-file-hook)
