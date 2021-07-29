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

let t =
  [ { header = "Principles"
    ; entries =
        [ { label = "Why OCaml"
          ; url = Url.principles_what_is_ocaml
          ; icon = Component_icon.camel
          ; text =
              "Find out about OCaml's history and how it became what it is \
               today."
          }
        ; { label = "Industrial Users"
          ; url = Url.principles_industrial_users
          ; icon = Component_icon.industry
          ; text =
              "Discover the organisations that use OCaml to accomplish their \
               goals."
          }
        ; { label = "Academic Excellence"
          ; url = Url.principles_academic
          ; icon = Component_icon.academic
          ; text =
              "Learn about the academics that research programming language \
               technology."
          }
        ; { label = "Success Stories"
          ; url = Url.principles_successes
          ; icon = Component_icon.success
          ; text = "Read about the things that have been achieved using OCaml."
          }
        ]
    }
  ; { header = "Resources"
    ; entries =
        [ { label = "Language"
          ; url = Url.resources_language
          ; icon = Component_icon.language
          ; text = "Read through the OCaml tutorial, official manual and books."
          }
        ; { label = "Packages"
          ; url = "/packages"
          ; icon = Component_icon.packages
          ; text =
              "Browse the third-party packages published in the OCaml \
               ecosystem."
          }
        ; { label = "Applications"
          ; url = Url.resources_applications
          ; icon = Component_icon.applications
          ; text =
              "Learn techniques for building tools and applications in OCaml."
          }
        ; { label = "Best Practices"
          ; url = Url.resources_best_practices
          ; icon = Component_icon.best_practices
          ; text =
              "Adopt the best known methods for development from the OCaml \
               community."
          }
        ]
    }
  ; { header = "Community"
    ; entries =
        [ { label = "Opportunities"
          ; url = Url.community_opportunities
          ; icon = Component_icon.opportunities
          ; text =
              "Explore vacancies in projects and companies and see where you \
               could fit in."
          }
        ; { label = "News"
          ; url = Url.community_news
          ; icon = Component_icon.news
          ; text = "Catch up on the latest news from the OCaml sphere!"
          }
        ; { label = "Around the Web"
          ; url = Url.community_around_web
          ; icon = Component_icon.web
          ; text =
              "A bit of everything, this page encapsulates OCaml's presence \
               online, blogposts, videos, and mailing lists all live here."
          }
        ; { label = "Archive"
          ; url = Url.resources_archive
          ; icon = Component_icon.archive
          ; text =
              "Can't find what you're looking for? Try searching the Archive."
          }
        ]
    }
  ]
