type t =
  { name : string
  ; email : string option
  ; github_username : string
  ; avatar : string
  }

let all =
  [ { name = {js|Xavier Leroy|js}
    ; email = None
    ; github_username = {js|xavierleroy|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/3845810?v=4|js}
    }
  ; { name = {js|Damien Doligez|js}
    ; email = None
    ; github_username = {js|damiendoligez|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/19104?v=4|js}
    }
  ; { name = {js|David Allsopp|js}
    ; email = None
    ; github_username = {js|dra27|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/5250680?v=4|js}
    }
  ; { name = {js|Alain Frisch|js}
    ; email = None
    ; github_username = {js|alainfrisch|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/3305274?v=4|js}
    }
  ; { name = {js|Gabriel Scherer|js}
    ; email = None
    ; github_username = {js|gasche|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/426238?v=4|js}
    }
  ; { name = {js|Jacques Garrigue|js}
    ; email = None
    ; github_username = {js|garrigue|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/870242?v=4|js}
    }
  ; { name = {js|Thibaut Mattio|js}
    ; email = Some {js|thibaut.mattio@gmail.com|js}
    ; github_username = {js|tmattio|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/6162008?v=4|js}
    }
  ; { name = {js|Anton Bachin|js}
    ; email = None
    ; github_username = {js|aantron|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/12073668?v=4|js}
    }
  ; { name = {js|Patrick Ferris|js}
    ; email = None
    ; github_username = {js|patricoferris|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/20166594?v=4|js}
    }
  ; { name = {js|Didier Rémy|js}
    ; email = None
    ; github_username = {js|diremy|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/1357930?v=4|js}
    }
  ; { name = {js|Gabriel Radanne|js}
    ; email = None
    ; github_username = {js|Drup|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/801124?v=4|js}
    }
  ; { name = {js|Daniel Bünzli|js}
    ; email = None
    ; github_username = {js|dbuenzli|js}
    ; avatar = {js|https://avatars.githubusercontent.com/u/485596?v=4|js}
    }
  ]
