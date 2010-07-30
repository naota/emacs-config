(create-config
 (comment
  (en "General config for those who use Gentoo/Prefix MacOSX")
  (ja "Gentoo/Prefix MacOSX ユーザ向け設定"))
 (param
  (prefix-root :filepath
   (comment
    (en "Gentoo/Prefix root path.")
    (ja "Gentoo/Prefixのルートディレクトリ")))))

(let ((prefix-root (or prefix-root "~/Gentoo")))
  (add-to-list 'exec-path
	       (expand-file-name "bin"
				 prefix-root))
  (add-to-list 'exec-path
	       (expand-file-name "usr/bin"
				 prefix-root))
  (with-temp-buffer
    (cd (expand-file-name "/usr/share/emacs/site-lisp/"
			  prefix-root))
    (load "subdirs.el")))

