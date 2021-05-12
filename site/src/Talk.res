type t = {
  id: int,
  name: string,
  author: string,
  creationDate: string,
  link: string,
}

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", int),
    name: json |> field("name", string),
    author: json |> field("author", string),
    creationDate: json |> field("creationDate", string),
    link: json |> field("link", string),
  }
}

let readAll = () => {
  "data/talks.yaml"->Fs.readFileSync->JsYaml.load()->Json.Decode.array(decode)(_)
}
