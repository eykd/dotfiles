;;; Buffer scrolling w/o moving the cursor
;;; http://www.emacswiki.org/cgi-bin/wiki/BufferScrolling
(global-set-key "\M-n"  (lambda () (interactive) (scroll-up   1)) )
(global-set-key "\M-p"  (lambda () (interactive) (scroll-down 1)) )

