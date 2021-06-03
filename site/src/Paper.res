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

let get_pdf = (paper: t) => {
  let is_pdf = link => {
    List.exists(String.equal("pdf"), String.split_on_char('.', link))
  }

  List.find_opt(is_pdf, paper.links)
}
