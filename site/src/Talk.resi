type t = {
  id: int,
  name: string,
  author: string,
  creationDate: string,
  link: string,
}

let decode: Js.Json.t => t

let readAll: unit => array<t>
