open Alcotest

let fixture_1 =
  [
    ( Gettext_locale.of_string "en",
      Gettext.LC_MESSAGES,
      "messages",
      Gettext_po.read_po
        {|
msgid "Hello World"
msgstr ""

msgid "I ate a %s"
msgstr ""

msgid "A horse"
msgid_plural "Horses"
msgstr[0] ""
msgstr[1] ""

msgid "I have %i pen"
msgid_plural "I have %i pens"
msgstr[0] ""
msgstr[1] ""

domain "my_domain"

msgid "Hi"
msgstr ""
|}
    );
    ( Gettext_locale.of_string "fr",
      Gettext.LC_MESSAGES,
      "messages",
      Gettext_po.read_po
        {|
msgid "Hello World"
msgstr "Bonjour le monde"

msgid "I ate a %s"
msgstr "J'ai mangé un %s"

msgid "A horse"
msgid_plural "Horses"
msgstr[0] "Un cheval"
msgstr[1] "Des chevaux"

msgid "I have %i pen"
msgid_plural "I have %i pens"
msgstr[0] "J'ai %i stylot"
msgstr[1] "J'ai %i stylots"

domain "my_domain"

msgid "Hi"
msgstr "Salut"
|}
    );
  ]

module I18n = Gettext.Make (struct
  let default_locale = "en"
  let default_domain = "messages"
  let allowed_locales = Some [ "en"; "fr" ]
  let po = fixture_1
end)

let suite =
  [
    ( "can translate default string",
      `Quick,
      fun () ->
        let translated = I18n.gettext "Hello World" in
        check string "same string" "Hello World" translated );
    ( "can change the locale",
      `Quick,
      fun () ->
        let translated =
          I18n.with_locale "fr" (fun () -> I18n.gettext "Hello World")
        in
        check string "same string" "Bonjour le monde" translated );
    ( "fails if the domain is different",
      `Quick,
      fun () ->
        Alcotest.check_raises "raises"
          (Gettext.Unknown_msgid ("fr", Gettext.LC_MESSAGES, "messages", "Hi"))
          (fun () ->
            let _ = I18n.with_locale "fr" (fun () -> I18n.gettext "Hi") in
            ()) );
    ( "can query a different domain",
      `Quick,
      fun () ->
        let translated =
          I18n.with_locale "fr" (fun () -> I18n.dgettext "my_domain" "Hi")
        in
        check string "same string" "Salut" translated );
    ( "can translate plural sentences",
      `Quick,
      fun () ->
        let translated_0 =
          I18n.with_locale "fr" (fun () -> I18n.ngettext "A horse" "Horses" 1)
        in
        let translated_1 =
          I18n.with_locale "fr" (fun () -> I18n.ngettext "A horse" "Horses" 2)
        in
        check string "same string" "Un cheval" translated_0;
        check string "same string" "Des chevaux" translated_1 );
    ( "can translate with format",
      `Quick,
      fun () ->
        let translated_0 =
          I18n.with_locale "en" (fun () -> I18n.fgettext "I ate a %s" "bob")
        in
        let translated_1 =
          I18n.with_locale "fr" (fun () -> I18n.fgettext "I ate a %s" "bob")
        in
        check string "same string" "I ate a bob" translated_0;
        check string "same string" "J'ai mangé un bob" translated_1 );
    ( "can translate with format",
      `Quick,
      fun () ->
        let translated_0 =
          I18n.with_locale "en" (fun () ->
              (I18n.fngettext "I have %i pen" "I have %i pens" 1) 1)
        in
        let translated_1 =
          I18n.with_locale "en" (fun () ->
              (I18n.fngettext "I have %i pen" "I have %i pens" 2) 2)
        in
        let translated_2 =
          I18n.with_locale "fr" (fun () ->
              (I18n.fngettext "I have %i pen" "I have %i pens" 1) 1)
        in
        let translated_3 =
          I18n.with_locale "fr" (fun () ->
              (I18n.fngettext "I have %i pen" "I have %i pens" 2) 2)
        in
        check string "same string" "I have 1 pen" translated_0;
        check string "same string" "I have 2 pens" translated_1;
        check string "same string" "J'ai 1 stylot" translated_2;
        check string "same string" "J'ai 2 stylots" translated_3 );
  ]

let () = Alcotest.run "gettext" [ ("Gettext", suite) ]
