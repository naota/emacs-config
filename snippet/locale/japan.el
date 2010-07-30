(create-config
 (comment
  (ja "日本語環境の設定")))

(set-language-environment 'Japanese)

(define-translation-table 'my-utf-8-decode (list (cons 65374 12316)))
(coding-system-put 'utf-8 :decode-translation-table 
		   'my-utf-8-decode)
(define-translation-table 'my-cp932-encode (list (cons 12316 65374)))
(coding-system-put 'cp932 :encode-translation-table 
		   'my-cp932-encode)
(define-translation-table 'my-cp932-decode (list (cons 65374 12316)))
(coding-system-put 'cp932 :decode-translation-table 
		   'my-cp932-decode)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8))
