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
  [ { header = s_ "Principles"
    ; entries =
        [ { label = s_ "Why OCaml"
          ; url = Url.principles_what_is_ocaml
          ; icon = Icon_template.camel
          ; text =
              s_
                "Find out about OCaml's history and how it became what it is \
                 today."
          }
        ; { label = s_ "Industrial Users"
          ; url = Url.principles_industrial_users
          ; icon = Icon_template.industry
          ; text =
              s_
                "Discover the organisations that use OCaml to accomplish their \
                 goals."
          }
        ; { label = s_ "Academic Excellence"
          ; url = Url.principles_academic
          ; icon = Icon_template.academic
          ; text =
              s_
                "Learn about the academics that research programming language \
                 technology."
          }
        ; { label = s_ "Success Stories"
          ; url = Url.principles_successes
          ; icon = Icon_template.success
          ; text =
              s_ "Read about the things that have been achieved using OCaml."
          }
        ]
    }
  ; { header = s_ "Resources"
    ; entries =
        [ { label = s_ "Language"
          ; url = Url.resources_language
          ; icon = Icon_template.language
          ; text =
              s_ "Read through the OCaml tutorial, official manual and books."
          }
        ; { label = s_ "Packages"
          ; url = "/packages"
          ; icon = Icon_template.packages
          ; text =
              s_
                "Browse the third-party packages published in the OCaml \
                 ecosystem."
          }
        ; { label = s_ "Applications"
          ; url = Url.resources_applications
          ; icon = Icon_template.applications
          ; text =
              s_
                "Learn techniques for building tools and applications in OCaml."
          }
        ; { label = "Best Practices"
          ; url = Url.resources_best_practices
          ; icon = Icon_template.best_practices
          ; text =
              s_
                "Adopt the best known methods for development from the OCaml \
                 community."
          }
        ]
    }
  ; { header = s_ "Community"
    ; entries =
        [ { label = s_ "Opportunities"
          ; url = Url.community_opportunities
          ; icon = Icon_template.opportunities
          ; text =
              s_
                "Explore vacancies in projects and companies and see where you \
                 could fit in."
          }
        ; { label = s_ "News"
          ; url = Url.community_news
          ; icon = Icon_template.news
          ; text = s_ "Catch up on the latest news from the OCaml sphere!"
          }
        ; { label = s_ "Around the Web"
          ; url = Url.community_around_web
          ; icon = Icon_template.web
          ; text =
              s_
                "A bit of everything, this page encapsulates OCaml's presence \
                 online, blogposts, videos, and mailing lists all live here."
          }
        ; { label = s_ "Archive"
          ; url = Url.resources_archive
          ; icon = Icon_template.archive
          ; text =
              s_
                "Can't find what you're looking for? Try searching the Archive."
          }
        ]
    }
  ]
