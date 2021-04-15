type t = {
  id: int,
  name: string,
  author: string,
  creationDate: string,
  link: string,
}

let readAll: unit => array<t>
