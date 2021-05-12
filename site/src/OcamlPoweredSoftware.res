type t = {
  id: int,
  name: string,
  link: string,
  linkDescription: string,
  image: string,
  imageHeight: string,
  description: string,
}

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", int),
    name: json |> field("name", string),
    link: json |> field("link", string),
    linkDescription: json |> field("linkDescription", string),
    image: json |> field("image", string),
    imageHeight: json |> field("imageHeight", string),
    description: json |> field("description", string),
  }
}

let readAll = () => {
  "data/ocaml_powered_software.yaml"->Fs.readFileSync->JsYaml.load()->Json.Decode.array(decode)(_)
}
