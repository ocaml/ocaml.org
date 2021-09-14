type date = {
  date: string,
  text: string,
}

type t = {
  title: string,
  pageDescription: string,
  introduction: string,
  dates: array<date>,
  presentations: array<Ood.Video.t>,
  papers: array<Ood.Paper.t>,
  // Committee too ?
}

include Pages.S with type t := t
