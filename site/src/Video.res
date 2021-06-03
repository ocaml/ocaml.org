type t = Ood.Videos.Video.t

let decode = json => {
  open Json.Decode
  {
    Ood.Videos.Video.title: json |> field("title", string),
    description: json |> field("description", string),
    people: json |> field("people", list(string)),
    kind: json |> field("kind", string) |> Ood.Videos.Video.kind_of_string |> Belt_Result.getExn,
    tags: json |> field("tags", list(string)),
    paper: json |> optional(field("paper", string)),
    link: json |> field("link", string),
    embed: json |> optional(field("embed", string)),
    year: json |> field("year", int),
  }
}

external fromJson: Js.Json.t => t = "%identity"
external toJson: t => Js.Json.t = "%identity"

let find_paper = (video: t, papers: list<Paper.t>) => {
  switch video.paper {
  | Some(paper) => List.find_opt((p: Paper.t) => String.equal(p.title, paper), papers)
  | None => None
  }
}
