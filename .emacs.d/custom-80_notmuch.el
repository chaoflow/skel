(setq sendmail-program "sendmail")
(add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)

(require 'notmuch)
