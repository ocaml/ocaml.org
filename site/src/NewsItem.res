type t = {
  id: int,
  link: string,
  title: string,
}

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", int),
    link: json |> field("link", string),
    title: json |> field("title", string),
  }
}

let readAll = () => {
  "data/news.yaml"->Fs.readFileSync->JsYaml.load()->Json.Decode.array(decode)(_)
}
