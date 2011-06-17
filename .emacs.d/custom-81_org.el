(add-to-list 'load-path "~/.nix-profile/share/org/contrib/lisp" )
(require 'org-install)
;; XXX: turned off until we have something that handles multiple
;; languages
(add-hook 'org-mode-hook 'flyspell-mode-off)

(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq-default org-default-notes-file "~/.capture.org")
(setq-default org-log-done t)
(setq-default org-startup-indented t)

;; XXX: This should be separate from the variable that can be
;; customized and both together should form `org-agenda-files`
;; add .org files of all projects to agenda-files
;;(setq-default org-agenda-files)

;; (mapc
;;  (lambda (f)
;;    (add-to-list 'org-agenda-files f t)
;;    )
;;  (directory-files "~/projects/" t "^[^.].+")
;;  )
