(create-config
 (comment
  (en)
  (ja)))

(if (string= current-language-environment "Japanese")
    (setq howm-menu-lang 'ja)
  (setq howm-menu-lang 'en))
(require 'howm)

