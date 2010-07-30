(create-config
 (comment
  (en "Web browser configs.")
  (ja "ウェブブラウザとの連携設定。"))
 (param
  (prefered-browser :list
		    (items
		     ("Opera" 'opera)
		     ("emacs-w3m" 'emacs-w3m))
		    (comment
		     (en "Browser you want to use.")
		     (ja "使用したいブラウザ")))))

(cond
 ((eq prefered-browser 'opera)
  (cond
   ((eq system-type 'darwin)
    ;; FIXME: assume that the default browser is set to opera
    (setq browse-url-browser-function 'browse-url-generic)
    (setq browse-url-generic-program "open"))
   ((eq system-type 'gnu/linux)
    (setq browse-url-browser-function 'browse-url-generic)
    (setq browse-url-generic-program "opera"))))
 ((eq prefered-browser 'emacs-w3m)
  (setq browse-url-browser-function 'w3m-browse-url)))
