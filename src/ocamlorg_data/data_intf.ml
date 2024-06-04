module Academic_institution = struct
  type location = { lat : float; long : float } [@@deriving of_yaml, show]

  type course = {
    name : string;
    acronym : string option;
    online_resource : string option;
  }
  [@@deriving of_yaml, show]

  type t = {
    name : string;
    slug : string;
    description : string;
    url : string;
    logo : string option;
    continent : string;
    courses : course list;
    location : location option;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end
