type t = {
  id: int,
  link: string,
  title: string,
}

let decode: Js.Json.t => t

let readAll: unit => array<t>
