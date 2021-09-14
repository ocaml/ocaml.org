open I18n

type menu_item =
  { label : string
  ; url : string
  ; icon : string
  ; text : string
  }

type menu =
  { header : string
  ; entries : menu_item list
  }

type t = menu list

let t () =
  [ { header = gettext "Principles"
    ; entries =
        [ { label = gettext "Why OCaml"
          ; url = Url.principles_what_is_ocaml
          ; icon = Icon_template.camel
          ; text =
              gettext
                "Find out about OCaml's history and how it became what it is \
                 today."
          }
        ; { label = gettext "Industrial Users"
          ; url = Url.principles_industrial_users
          ; icon = Icon_template.industry
          ; text =
              gettext
                "Discover the organisations that use OCaml to accomplish their \
                 goals."
          }
        ; { label = gettext "Academic Excellence"
          ; url = Url.principles_academic
          ; icon = Icon_template.academic
          ; text =
              gettext
                "Learn about the academics that research programming language \
                 technology."
          }
        ; { label = gettext "Success Stories"
          ; url = Url.principles_successes
          ; icon = Icon_template.success
          ; text =
              gettext
                "Read about the things that have been achieved using OCaml."
          }
        ]
    }
  ; { header = gettext "Resources"
    ; entries =
        [ { label = gettext "Language"
          ; url = Url.resources_language
          ; icon = Icon_template.language
          ; text =
              gettext
                "Read through the OCaml tutorial, official manual and books."
          }
        ; { label = gettext "Packages"
          ; url = "/packages"
          ; icon = Icon_template.packages
          ; text =
              gettext
                "Browse the third-party packages published in the OCaml \
                 ecosystem."
          }
        ; { label = gettext "Applications"
          ; url = Url.resources_applications
          ; icon = Icon_template.applications
          ; text =
              gettext
                "Learn techniques for building tools and applications in OCaml."
          }
        ; { label = "Best Practices"
          ; url = Url.resources_best_practices
          ; icon = Icon_template.best_practices
          ; text =
              gettext
                "Adopt the best known methods for development from the OCaml \
                 community."
          }
        ]
    }
  ; { header = gettext "Community"
    ; entries =
        [ { label = gettext "Opportunities"
          ; url = Url.community_opportunities
          ; icon = Icon_template.opportunities
          ; text =
              gettext
                "Explore vacancies in projects and companies and see where you \
                 could fit in."
          }
        ; { label = gettext "News"
          ; url = Url.community_news
          ; icon = Icon_template.news
          ; text = gettext "Catch up on the latest news from the OCaml sphere!"
          }
        ; { label = gettext "Around the Web"
          ; url = Url.community_around_web
          ; icon = Icon_template.web
          ; text =
              gettext
                "A bit of everything, this page encapsulates OCaml's presence \
                 online, blogposts, videos, and mailing lists all live here."
          }
        ; { label = gettext "Archive"
          ; url = Url.resources_archive
          ; icon = Icon_template.archive
          ; text =
              gettext
                "Can't find what you're looking for? Try searching the Archive."
          }
        ]
    }
  ]
