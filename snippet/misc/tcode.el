(create-config
 (comment
  (en "T-Code setup.")
  (ja "T-Code の設定")))

(require 'tc-setup)
(set-input-method 'japanese-T-Code)
(unless (fboundp 'isearch-last-command-char)
  (defun isearch-printing-char ()
    "Add this ordinary printing character to the search string and search."
    (interactive)
    (let ((char last-command-char))
      (if (and (boundp 'tcode-mode) tcode-mode)
	  ;; isearch for T-Code
	  (let* ((decoded (tcode-decode-chars last-command-char))
		 (action (car decoded))
		 (prev (tcode-isearch-bushu)))
	    (cond ((null action)
		   (ding))
		  ((stringp action)
		   (setq action
			 (mapconcat 'char-to-string
				    (tcode-apply-filters 
				     (string-to-list action))
				    nil))
		   (tcode-isearch-process-string action prev))
		  ((char-or-string-p action)
		   (tcode-isearch-process-string 
		    (char-to-string (car (tcode-apply-filters (list action))))
		    prev))
		  ((and (not (tcode-function-p action))
			(consp action))
		   (tcode-isearch-process-string 
		    (mapconcat 'char-to-string
			       (tcode-apply-filters
				(mapcar 'string-to-char
					(delq nil action)))
			       nil)
		    prev))
		  ((tcode-function-p action)
		   (let ((func (assq action
				     tcode-isearch-special-function-alist)))
		     (if func
			 (funcall (or (cdr func)
				      action))
		       (tcode-isearch-process-string
			(mapconcat 'char-to-string (cdr decoded) nil)
			prev))))
		  (t
		   (ding))))
	;; original behaviour
	(if (= char ?\S-\ )
	    (setq char ?\ ))
	(if (and enable-multibyte-characters
		 (>= char ?\200)
		 (<= char ?\377))
	    (if (keyboard-coding-system)
		(isearch-process-search-multibyte-characters char)
	      (isearch-process-search-char (unibyte-char-to-multibyte char)))
	  (if current-input-method
	      (isearch-process-search-multibyte-characters char)
	    (isearch-process-search-char char)))))))

