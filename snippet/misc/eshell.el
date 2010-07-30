

(defun eshell/emacs (&rest args)
  "Open a file in emacs. Some habits die hard."
  (if (null args)
      ;; If I just ran "emacs", I probably expect to be launching
      ;; Emacs, which is rather silly since I'm already in Emacs.
      ;; So just pretend to do what I ask.
      (bury-buffer)
    ;; We have to expand the file names or else naming a directory in an
    ;; argument causes later arguments to be looked for in that directory,
    ;; not the starting directory
    (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))
(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
	(beginning-of-line))))

(add-hook 'eshell-mode-hook
	  '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))
(defun tyler-eshell-view-file (file)
  "A version of `view-file' which properly respects the eshell prompt."
  (interactive "fView file: ")
  (unless (file-exists-p file) (error "%s does not exist" file))
  (let ((had-a-buf (get-file-buffer file))
	(buffer (find-file-noselect file)))
    (if (eq (with-current-buffer buffer (get major-mode 'mode-class))
	    'special)
	(progn
	  (switch-to-buffer buffer)
	  (message "Not using View mode because the major mode is special"))
      (let ((undo-window (list (window-buffer) (window-start)
			       (+ (window-point)
				  (length (funcall eshell-prompt-function))))))
	(switch-to-buffer buffer)
	(view-mode-enter (cons (selected-window) (cons nil undo-window))
			 'kill-buffer)))))

(defun eshell/less (&rest args)
  "Invoke `view-file' on a file. \"less +42 foo\" will go to line 42 in
    the buffer for foo."
  (while args
    (if (string-match "\\`\\+\\([0-9]+\\)\\'" (car args))
	(let* ((line (string-to-number (match-string 1 (pop args))))
	       (file (pop args)))
	  (tyler-eshell-view-file file)
	  (goto-line line))
      (tyler-eshell-view-file (pop args)))))

(defalias 'eshell/more 'eshell/less)
