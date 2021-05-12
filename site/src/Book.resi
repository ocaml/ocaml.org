type t = {
  id: int,
  name: string,
  link: string,
  image: string,
}

let decode: Js.Json.t => t

let readAll: unit => array<t>
