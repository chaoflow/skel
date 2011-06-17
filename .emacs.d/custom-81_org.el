;; include the contrib code for org-notmuch
(add-to-list 'load-path "~/.nix-profile/share/org/contrib/lisp" )
(require 'org-install)
(require 'org-notmuch)

;; XXX: turned off until we have something that handles multiple
;; languages
(add-hook 'org-mode-hook 'flyspell-mode-off)

(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq-default
 org-capture-templates
 '(
   ("b" "buy" entry (file+headline org-default-notes-file "Notes to buy something")
    "* %? :buy:\n  %i\n  %a")
   ("e" "Event" entry (file+headline org-default-notes-file "Events")
    "* %? %^T :event:\n  %i\n  %a")
   ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org.gpg"))
    "* %?\nEntered on %U\n  %i\n  %a")
   ("m" "Meeting" entry (file+headline org-default-notes-file "Meetings")
    "* %? :meeting:\n  %i\n  %a")
   ("t" "Task" entry (file+headline org-default-notes-file "Tasks")
    "* TODO %?\n  %i\n  %a")
   ))
(setq-default org-default-notes-file (concat org-directory "/capture.org.gpg"))
(setq-default org-log-done t)
(setq-default org-startup-indented t)

(setq-default org-todo-keywords '((sequence "TODO" "NEXT" "DONE")))

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
