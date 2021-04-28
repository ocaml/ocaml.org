module Meeting = struct
  type t = {
    title : string;
    url : string;
    date : string;
    online : bool;
    location : string;
  }
end

type t = { meetings : Meeting.t list }
