module Paper = struct
  type t = {
    title : string;
    publication : string;
    authors : string list;
    abstract : string;
    tags : string list;
    year : int;
    links : string list;
  }
end

type t = { papers : Paper.t list }
