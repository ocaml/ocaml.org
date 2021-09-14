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
  [ { header = "Content"
    ; entries =
        [ { label = "Papers Archive"; url = "/papers"; icon = ""; text = "" }
        ; { label = "Success Stories"
          ; url = "/success-stories"
          ; icon = ""
          ; text = ""
          }
        ; { label = "Industrial Users"
          ; url = "/industrial-users"
          ; icon = ""
          ; text = ""
          }
        ; { label = "Academic Excellence"
          ; url = "/academic-excellence"
          ; icon = ""
          ; text = ""
          }
        ; { label = "Consortium"; url = "/consortium"; icon = ""; text = "" }
        ; { label = "Books"; url = "/books"; icon = ""; text = "" }
        ; { label = "Events"; url = "/events"; icon = ""; text = "" }
        ; { label = "Videos"; url = "/videos"; icon = ""; text = "" }
        ; { label = "watch"; url = "/watch"; icon = ""; text = "" }
        ; { label = "Tutorials"; url = "/tutorials"; icon = ""; text = "" }
        ; { label = "Workshops"; url = "/workshops"; icon = ""; text = "" }
        ; { label = "Platform"; url = "/tools"; icon = ""; text = "" }
        ; { label = "News"; url = "/news"; icon = ""; text = "" }
        ]
    }
  ]
