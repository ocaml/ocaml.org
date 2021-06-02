module Video = struct
  type kind = [ `Conference | `Mooc | `Lecture ]

  let kind_of_string = function
    | "conference" -> Ok `Conference
    | "mooc" -> Ok `Mooc
    | "lecture" -> Ok `Lecture
    | _ -> Error (`Msg "Unknown video kind")

  let kind_to_string = function
    | `Conference -> "conference"
    | `Mooc -> "mooc"
    | `Lecture -> "lecture"

  type t = {
    title : string;
    description : string;
    people : string list;
    kind : kind;
    tags : string list;
    paper : string option;
    link : string;
    embed : string option;
    year : int;
  }
end

type t = { videos : Video.t list }
