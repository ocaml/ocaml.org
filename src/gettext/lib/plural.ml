(* Plural data structures borrowed from
   https://github.com/elixir-gettext/gettext/blob/master/lib/gettext/plural.ex *)

exception Unknown_language of string

let one_form =
  [
    (* Aymará *)
    "ay";
    (* Tibetan *)
    "bo";
    (* Chiga *)
    "cgg";
    (* Dzongkha *)
    "dz";
    (* Persian *)
    "fa";
    (* Indonesian *)
    "id";
    (* Japanese *)
    "ja";
    (* Lojban *)
    "jbo";
    (* Georgian *)
    "ka";
    (* Kazakh *)
    "kk";
    (* Khmer *)
    "km";
    (* Korean *)
    "ko";
    (* Kyrgyz *)
    "ky";
    (* Lao *)
    "lo";
    (* Malay *)
    "ms";
    (* Burmese *)
    "my";
    (* Yakut *)
    "sah";
    (* Sundanese *)
    "su";
    (* Thai *)
    "th";
    (* Tatar *)
    "tt";
    (* Uyghur *)
    "ug";
    (* Vietnamese *)
    "vi";
    (* Wolof *)
    "wo";
    (* Chinese [2] *)
    "zh";
  ]

let two_forms_1 =
  [
    (* Afrikaans *)
    "af";
    (* Aragonese *)
    "an";
    (* Angika *)
    "anp";
    (* Assamese *)
    "as";
    (* Asturian *)
    "ast";
    (* Azerbaijani *)
    "az";
    (* Bulgarian *)
    "bg";
    (* Bengali *)
    "bn";
    (* Bodo *)
    "brx";
    (* Catalan *)
    "ca";
    (* Danish *)
    "da";
    (* German *)
    "de";
    (* Dogri *)
    "doi";
    (* Greek *)
    "el";
    (* English *)
    "en";
    (* Esperanto *)
    "eo";
    (* Spanish *)
    "es";
    (* Estonian *)
    "et";
    (* Basque *)
    "eu";
    (* Fulah *)
    "ff";
    (* Finnish *)
    "fi";
    (* Faroese *)
    "fo";
    (* Friulian *)
    "fur";
    (* Frisian *)
    "fy";
    (* Galician *)
    "gl";
    (* Gujarati *)
    "gu";
    (* Hausa *)
    "ha";
    (* Hebrew *)
    "he";
    (* Hindi *)
    "hi";
    (* Chhattisgarhi *)
    "hne";
    (* Armenian *)
    "hy";
    (* Hungarian *)
    "hu";
    (* Interlingua *)
    "ia";
    (* Italian *)
    "it";
    (* Greenlandic *)
    "kl";
    (* Kannada *)
    "kn";
    (* Kurdish *)
    "ku";
    (* Letzeburgesch *)
    "lb";
    (* Maithili *)
    "mai";
    (* Malayalam *)
    "ml";
    (* Mongolian *)
    "mn";
    (* Manipuri *)
    "mni";
    (* Marathi *)
    "mr";
    (* Nahuatl *)
    "nah";
    (* Neapolitan *)
    "nap";
    (* Norwegian Bokmal *)
    "nb";
    (* Nepali *)
    "ne";
    (* Dutch *)
    "nl";
    (* Northern Sami *)
    "se";
    (* Norwegian Nynorsk *)
    "nn";
    (* Norwegian (old code) *)
    "no";
    (* Northern Sotho *)
    "nso";
    (* Oriya *)
    "or";
    (* Pashto *)
    "ps";
    (* Punjabi *)
    "pa";
    (* Papiamento *)
    "pap";
    (* Piemontese *)
    "pms";
    (* Portuguese *)
    "pt";
    (* Romansh *)
    "rm";
    (* Kinyarwanda *)
    "rw";
    (* Santali *)
    "sat";
    (* Scots *)
    "sco";
    (* Sindhi *)
    "sd";
    (* Sinhala *)
    "si";
    (* Somali *)
    "so";
    (* Songhay *)
    "son";
    (* Albanian *)
    "sq";
    (* Swahili *)
    "sw";
    (* Swedish *)
    "sv";
    (* Tamil *)
    "ta";
    (* Telugu *)
    "te";
    (* Turkmen *)
    "tk";
    (* Urdu *)
    "ur";
    (* Yoruba *)
    "yo";
  ]

let two_forms_2 =
  [
    (* Acholi *)
    "ach";
    (* Akan *)
    "ak";
    (* Amharic *)
    "am";
    (* Mapudungun *)
    "arn";
    (* Breton *)
    "br";
    (* Filipino *)
    "fil";
    (* French *)
    "fr";
    (* Gun *)
    "gun";
    (* Lingala *)
    "ln";
    (* Mauritian Creole *)
    "mfe";
    (* Malagasy *)
    "mg";
    (* Maori *)
    "mi";
    (* Occitan *)
    "oc";
    (* Tajik *)
    "tg";
    (* Tigrinya *)
    "ti";
    (* Tagalog *)
    "tl";
    (* Turkish *)
    "tr";
    (* Uzbek *)
    "uz";
    (* Walloon *)
    "wa";
  ]

let three_forms_slavic =
  [
    (* Belarusian *)
    "be";
    (* Bosnian *)
    "bs";
    (* Croatian *)
    "hr";
    (* Serbian *)
    "sr";
    (* Russian *)
    "ru";
    (* Ukrainian *)
    "uk";
  ]

let three_forms_slavic_alt = [ (* Czech *) "cs"; (* Slovak *) "sk" ]

let nplurals lang =
  let lang = Gettext_locale.((of_string lang).language) in
  if List.mem lang one_form then 1
  else if List.mem lang two_forms_1 then 2
  else if List.mem lang two_forms_2 then 2
  else if List.mem lang three_forms_slavic then 3
  else if List.mem lang three_forms_slavic_alt then 3
  else if String.equal lang "ar" then (* Arabic *)
    6
  else if String.equal lang "csb" then (* Kashubian *)
    3
  else if String.equal lang "cy" then (* Welsh *)
    4
  else if String.equal lang "ga" then (* Irish *)
    5
  else if String.equal lang "gd" then (* Scottish Gaelic *)
    4
  else if String.equal lang "is" then (* Icelandic *)
    2
  else if String.equal lang "jv" then (* Javanese *)
    2
  else if String.equal lang "kw" then (* Cornish *)
    4
  else if String.equal lang "lt" then (* Lithuanian *)
    3
  else if String.equal lang "lv" then (* Latvian *)
    3
  else if String.equal lang "mk" then (* Macedonian *)
    3
  else if String.equal lang "mnk" then (* Mandinka *)
    3
  else if String.equal lang "mt" then (* Maltese *)
    4
  else if String.equal lang "pl" then (* Polish *)
    3
  else if String.equal lang "ro" then (* Romanian *)
    3
  else if String.equal lang "sl" then (* Slovenian *)
    4
  else raise (Unknown_language lang)

let plural lang n =
  let locale = Gettext_locale.(of_string lang) in
  if
    String.equal locale.Gettext_locale.language "pt"
    && locale.Gettext_locale.territory = Some "BR"
  then if n < 2 then 0 else 1
  else
    let lang = locale.Gettext_locale.language in
    if List.mem lang one_form then 0
    else if List.mem lang two_forms_1 then if n = 1 then 0 else 1
    else if List.mem lang two_forms_2 then if n = 1 || n = 0 then 0 else 1
    else if List.mem lang three_forms_slavic then
      failwith "locale not supported yet"
    else if List.mem lang three_forms_slavic_alt then
      failwith "locale not supported yet"
    else if String.equal lang "ar" then failwith "locale not supported yet"
    else if String.equal lang "cs" then failwith "locale not supported yet"
    else if String.equal lang "cy" then failwith "locale not supported yet"
    else if String.equal lang "ga" then failwith "locale not supported yet"
    else if String.equal lang "gd" then failwith "locale not supported yet"
    else if String.equal lang "is" then failwith "locale not supported yet"
    else if String.equal lang "jv" then failwith "locale not supported yet"
    else if String.equal lang "kw" then failwith "locale not supported yet"
    else if String.equal lang "lt" then failwith "locale not supported yet"
    else if String.equal lang "lv" then failwith "locale not supported yet"
    else if String.equal lang "mk" then failwith "locale not supported yet"
    else if String.equal lang "mn" then failwith "locale not supported yet"
    else if String.equal lang "mt" then failwith "locale not supported yet"
    else if String.equal lang "pl" then failwith "locale not supported yet"
    else if String.equal lang "ro" then failwith "locale not supported yet"
    else if String.equal lang "sl" then failwith "locale not supported yet"
    else raise (Unknown_language lang)
