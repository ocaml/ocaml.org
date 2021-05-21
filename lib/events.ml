module Event = struct
  type t = {
    title : string;
    description : string;
    url : string;
    date : string;
    tags : string list;
    online : bool;
    textual_location : string option;
    location : string option;
  }
end

type t = { events : Event.t list }
