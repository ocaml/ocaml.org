type t = {
  id: int,
  link: string,
  name: string,
  description: string,
  image: string,
  imageHeight: string,
}

let decode: Js.Json.t => t

let readAll: unit => array<t>
