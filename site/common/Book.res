type t = {
  id: int,
  name: string,
  link: string,
  image: string,
}

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", int),
    name: json |> field("name", string),
    link: json |> field("link", string),
    image: json |> field("image", string),
  }
}

let readAll = () => {
  "data/books.yaml"->Fs.readFileSync->JsYaml.load()->Json.Decode.array(decode)(_)
}
