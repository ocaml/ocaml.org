type t = Ood.Papers.t

let decode = json => {
  open Json.Decode
  {
    Ood.Papers.papers: json |> field("papers", list(Paper.decode)),
  }
}

let readAll = () => {
  "vendor/ood/data/papers.yml"->Fs.readFileSync->JsYaml.load()->decode
}
