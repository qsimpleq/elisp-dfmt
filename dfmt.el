;;; dfmt.el - Emacs Interface to D indenting/formatting tool dfmt.

(defgroup dfmt nil
  "Interface to D dfmt."
  :group 'tools)

(defcustom dfmt-command "dfmt" "D format command"
  :group 'dfmt)

(defun dfmt-region (buffer)
  "Format D BUFFER's region from START to END using the
external program GNU format."
  (interactive "bFormat region of buffer: ")
  (when (executable-find dfmt-command)
    (save-buffer)
    (shell-command-on-region (region-beginning) (region-end)
                             dfmt-command
                             buffer t)))

(defun dfmt-buffer (buffer)
  "Format D Buffer using the external program GNU format."
  (interactive "bFormat buffer: ")
  (mark-whole-buffer)
  (dfmt-region buffer))

(defun dfmt-file (file out-file)
  "Format D Source or Header FILE using the external program dfmt and put result in OUT-FILE."
  (interactive "fFormat source file: \nFOutput file (from format): ")
  (when (executable-find dfmt-command)
    (progn (shell-command (concat dfmt-command " " dfmt-flags " " file " -o " out-file))
           (find-file out-file))))

(defun dfmt-setup-keys ()
  (local-set-key [(control c) (F) (r)] 'dfmt-region)
  (local-set-key [(control c) (F) (b)] 'dfmt-buffer)
  (local-set-key [(control c) (F) (f)] 'dfmt-file))
(add-hook 'd-mode-hook 'dfmt-setup-keys)

(define-key menu-bar-tools-menu [dfmt-buffer]
  '(menu-item "Tidy D Buffer (dfmt)..." dfmt-buffer
              :help "Format a D source buffer using dfmt"))
(define-key menu-bar-tools-menu [dfmt-file]
  '(menu-item "Tidy D File (dfmt)..." dfmt-file
              :help "Format a D source file using dfmt"))

(provide 'dfmt)
