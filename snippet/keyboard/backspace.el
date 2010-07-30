(create-config
 (comment
  (en "Use Ctrl-h as backspace.")
  (ja "Ctrl-h をバックスペースとして使う。"))
 (param
  (swap :boolean
	(comment
	 (en "Swap the keys.")
	 (ja "BSとCtrl-hを入れ替える")))))

(keyboard-translate ?\C-h ?\C-?)
(when swap
  (keyboard-translate ?\C-h ?\C-?))
