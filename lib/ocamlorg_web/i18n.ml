module Default =
(val Gettext.create
       ~failsafe:Ignore
       ~path:[ "_build/default/gettext" ]
       ~categories:[ LC_MESSAGES, "en"; LC_MESSAGES, "fr" ]
       ~language:"en"
       ~codeset:"UTF-8"
       ~realize:GettextCamomile.Map.realize
       "default")

include Default
