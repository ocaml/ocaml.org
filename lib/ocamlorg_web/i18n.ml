include Gettext.Make (struct
  let default_locale = "en"

  let default_domain = "messages"

  let allowed_locales = Some [ "en"; "fr" ]

  let po =
    [ ( Gettext_locale.of_string "en"
      , Gettext.LC_MESSAGES
      , "messages"
      , Gettext_po.read_po
          (Gettext_asset.read "en/LC_MESSAGES/messages.po" |> Option.get) )
    ; ( Gettext_locale.of_string "fr"
      , Gettext.LC_MESSAGES
      , "messages"
      , Gettext_po.read_po
          (Gettext_asset.read "fr/LC_MESSAGES/messages.po" |> Option.get) )
    ]
end)