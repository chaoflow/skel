;; color theme handling: tweak color theme for tty frames
;; otherwise gnome-terminal sets a weird background color.
;; this also sets the default font for X frames

(require 'color-theme)
(setq-default color-theme-is-global nil)
(defun frame-select-color-theme (&optional frame)
  "Set the right color theme for a new frame."
  (let* ((frame (or frame (selected-frame))))
    (select-frame frame)
    ;; default color theme
    (color-theme-blackboard)
    ;; modify modeline
    ;;(face-spec-set 'mode-line '((t (:background "darkred" :foreground "white" :box (:line-width -1 :style released-button)))) (selected-frame))
    (if (and (fboundp 'window-system)
             (window-system))

        ;; default font
;;        (set-default-font "Terminus-14")

      ;; else tty - fix up background
      (face-spec-set 'default '((t (:background "black"))) (selected-frame)))))
(add-hook 'after-make-frame-functions 'frame-select-color-theme)

;; set color theme for this frame
(frame-select-color-theme)
