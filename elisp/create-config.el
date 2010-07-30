;;; API

;;;###autoload
(defun create-config-dump-one-file (config-file snipet-dir output-file)
  (interactive)
  (let ((config-list (create-config-file-to-config-list config-file)))
    (with-temp-buffer
      (mapcar (lambda (x)
		(insert (create-config-expand-config
			 snipet-dir
			 (car x) (cdr x))))
	      config-list)
      (write-region (point-min) (point-max) output-file))))

;;;###autoload
(defun create-config-dump-directory (config-file output-directory)
  (interactive)
  ;; まーだだよ
  (when (y-or-n-p "relax? ")
    (cond
     ((fboundp 'bubbles)
      (bubbles))
     ((fboundp 'tetris)
      (tetris))
     (t (doctor)))))

;;; internal util

(defun create-config-file-to-config-list (config-file)
  (with-temp-buffer
    (insert-file-contents config-file)
    (goto-char (point-min))
    (let (clist result)
      (while (setq clist (create-config-maybe-read))
	(setq result (cons (cons (symbol-name (car clist))
				 (cdr clist))
			   result)))
      (setq reslut (nreverse result)))))

(defun create-config-expand-config 
  (snippet-dir config-snippet &rest snippet-args)
  (let ((filename (locate-library (expand-file-name config-snippet
						    snippet-dir))))
    (if filename
      (with-temp-buffer
	(insert-file-contents filename)
	(goto-char (point-min))
	(let ((pos (point-min))
	      params lisp)
	  (while (setq lisp (create-config-maybe-read))
	    (when (eq (car lisp) 'create-config)
	      (setq lisp (cdr lisp))
	      (while lisp
		(when (eq (caar lisp) 'param)
		  (setq params
			(nconc params
			       (mapcar 'car (cdar lisp)))))
		(setq lisp (cdr lisp)))
	      (delete-region pos (point)))
	    (setq pos (point)))
	  (concat "(let ("
		  (let ((len (length snippet-args))
			(i 0))
		    (mapconcat (lambda (x)
				 (concat "("
					 (symbol-name x)
					 " "
					 (with-temp-buffer
					   (prin1 (when (< i len)
						    (nth i snippet-args))
						  (current-buffer))
					   (buffer-string))
					 ")"))
			       params
			       " "))
		  ")"
		  (buffer-string)
		  ")")))
      "")))

(defun create-config-maybe-read (&optional stream)
  (condition-case nil
      (read (or stream (current-buffer)))
    (error nil)))
