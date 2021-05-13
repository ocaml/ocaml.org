type t = Ood.Papers.Paper.t

let decode = json => {
  open Json.Decode
  {
    // TODO: add an id field to faciliate
    //  referencing specific papers from pages like
    //  resources/language
    Ood.Papers.Paper.title: json |> field("title", string),
    publication: json |> field("publication", string),
    authors: json |> field("authors", list(string)),
    abstract: json |> field("abstract", string),
    tags: json |> field("tags", list(string)),
    year: json |> field("year", int),
    // TODO: consider refactoring this into
    //  multiple link fields.
    links: json |> field("links", list(string)),
  }
}
