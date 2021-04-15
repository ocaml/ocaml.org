type t = {
  id: int,
  name: string,
  link: string,
  linkDescription: string,
  image: string,
  imageHeight: string,
  description: string,
}

let readAll: unit => array<t>
