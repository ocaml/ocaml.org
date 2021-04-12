type t = {
  id: int,
  name: string,
  link: string,
  image: string,
}

@module("js-yaml") external load: (string, ~options: 'a=?, unit) => array<t> = "load"

let forceInvalidException: JsYaml.forceInvalidException<t> = b => {
  let _ = (
    Js.Int.toString(b.id),
    Js.String.length(b.name),
    Js.String.length(b.link),
    Js.String.length(b.image),
  )
}

let readAll = () => {
  let booksDatabasePath = "data/books.yaml"
  let fileContents = Fs.readFileSync(booksDatabasePath)
  let books = load(fileContents, ())
  Js.Array.forEach(forceInvalidException, books)
  books
}
