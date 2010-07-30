(create-config
 (comment
  (en "Emacs frame Transparency")
  (ja "Emacs の背景透過"))
 (param
  (alpha :integer
	 (comment
	  (en "Transparent percent 0-100")
	  (ja "透過率 0(透明)〜100(不透明)")))))

(let ((alpha (or alpha 80)))
  (set-frame-parameter nil 'alpha alpha)
  (add-to-list 'default-frame-alist (cons 'alpha alpha)))
