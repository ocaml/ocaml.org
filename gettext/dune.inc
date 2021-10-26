; assumes it's included from one of the language folder (en, fr, ..)

(subdir
 LC_MESSAGES
 (rule
  (target messages.po.merged)
  (deps ../../messages.pot.expected messages.po)
  (action
   (with-stdout-to
    %{target}
    (run ocaml-gettext merge %{deps})))))

(subdir
 LC_MESSAGES
 (rule
  (alias gen-po)
  (action
   (diff messages.po messages.po.merged))))
