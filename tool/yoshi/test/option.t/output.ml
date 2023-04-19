type t = {
  title: string;
  author: string option;
  duration: int;
}

let videos_list = [
  { title = "Introduction to OCaml"; author = None; duration = 120 };
  { title = "Functional Programming in OCaml"; author = Some ("John Smith"); duration = 180 }
]
