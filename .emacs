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
   (:name feature-mode
      :type git
      :url "git://github.com/michaelklishin/cucumber.el.git"
      :features feature-mode
      :compile "feature-mode.el"
      )

   (:name rnc-mode
      :type git
      :url "git://github.com/TreeRex/rnc-mode.git"
      :features rnc-mode
      :compile "rnc-mode.el"
      :after (lambda ()
  						 (autoload 'rnc-mode "rnc-mode")
  						 (add-to-list 'auto-mode-alist '("\\.rnc\\'" . rnc-mode))
  						 )
      )

   (:name haxe-mode
       :description "Haxe mode for emacs"
       :type hg
       :url "https://bitbucket.org/jpsecher/haxe-mode"
       :load "haxe-mode.el"
       :features haxe-mode)

   (:name smex                ; a better (ido like) M-x
      :after (lambda ()
           (setq smex-save-file "~/.emacs.d/.smex-items")
           (global-set-key (kbd "M-x") 'smex)
           (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name zencoding-mode
      :after (lambda ()
           (add-hook 'sgml-mode-hook 'zencoding-mode))) ;; Auto-start on any markup modes

   (:name yasnippet
      :url "git://github.com/capitaomorte/yasnippet.git"
      :description "YASnippet is a template system for Emacs."
      :type git
      :features yasnippet
      :compile "yasnippet.el"
      :after (lambda ()
               (setq yas-snippet-dirs
                     '("~/.emacs.d/snippets"            ;; personal snippets
                       ))
               (yas-global-mode 1)))
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
   fill-column-indicator; show a vertical line at 80 columns
   ;rainbow-identifiers
   switch-window        ; takes over C-x o
   textmate             ; textmate-mode!
   ;whitespace           ; whitespace tricks
   yaml-mode
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

;; ;; Tab width to 2
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

(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  )

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)

;;; Buffer scrolling w/o moving the cursor
;;; http://www.emacswiki.org/cgi-bin/wiki/BufferScrolling
(global-set-key "\M-n"  (lambda () (interactive) (scroll-up   1)) )
(global-set-key "\M-p"  (lambda () (interactive) (scroll-down 1)) )
(global-set-key "\M-\S-n"  (lambda () (interactive) (scroll-up   5)) )
(global-set-key "\M-\S-p"  (lambda () (interactive) (scroll-down 5)) )

;; Join the following line onto this one.
(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

;; Textmate mode!
(textmate-mode t)

;; yasnippet!
(yas-global-mode 1)

;; Kill trailing whitespace!
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Whitespace mode
;; (require 'whitespace)
;; (setq whitespace-style '(face empty tabs trailing))
;; (global-whitespace-mode 1)
;; (defadvice whitespace-cleanup (around whitespace-cleanup-indent-tab
;;                                       activate)
;;   "Fix whitespace-cleanup indent-tabs-mode bug"
;;   (let ((whitespace-indent-tabs-mode indent-tabs-mode)
;;         (whitespace-tab-width tab-width))
;;     ad-do-it))
;; (defun my-tabs-makefile-hook ()
;;   (setq indent-tabs-mode t))
;; (add-hook 'makefile-mode-hook 'my-tabs-makefile-hook)

;; Add a column marker at column 80 in python
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(setq fci-rule-color "darkblue")
(setq fci-rule-column 80)
(add-hook 'python-mode-hook 'fci-mode)

;; ;; Autopair!
(require 'autopair)
(autopair-global-mode 1)

(add-to-list 'auto-mode-alist '("\\.story\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.sls\\'" . yaml-mode))


;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
;;http://www.geocrawler.com/archives/3/338/1994/6/0/1877802/
;;Via http://www.emacswiki.org/emacs/RecreateScratchBuffer
(save-excursion
	(set-buffer (get-buffer-create "*scratch*"))
	(lisp-interaction-mode)
	(make-local-variable 'kill-buffer-query-functions)
	(add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
	;; The next line is just in case someone calls this manually
	(set-buffer (get-buffer-create "*scratch*"))
	;; Kill the current (*scratch*) buffer
	(remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
	(kill-buffer (current-buffer))
	;; Make a brand new *scratch* buffer
	(set-buffer (get-buffer-create "*scratch*"))
	(lisp-interaction-mode)
	(make-local-variable 'kill-buffer-query-functions)
	(add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
	;; Since we killed it, don't let caller do that.
	nil)

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

(require 'uniquify)
(setq
  uniquify-buffer-name-style 'forward)
