type t = {
  id: int,
  link: string,
  name: string,
  description: string,
  image: string,
  imageHeight: string,
}

let readAll: unit => array<t>
