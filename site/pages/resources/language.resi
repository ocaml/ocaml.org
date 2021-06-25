module UserLevelIntroduction: {
  type t = {
    level: string,
    introduction: string,
  }
}

module Books: {
  type t = {
    booksLabel: string,
    books: array<Ood.Book.t>,
  }
}

type t = {
  title: string,
  pageDescription: string,
  beginning: UserLevelIntroduction.t,
  growing: UserLevelIntroduction.t,
  booksContent: Books.t,
  expanding: UserLevelIntroduction.t,
  diversifying: UserLevelIntroduction.t,
  researching: UserLevelIntroduction.t,
}

@react.component
let make: (~content: t) => React.element

type props = {content: t}

let getStaticProps: Next.GetStaticProps.t<props, unit, unit>

let default: {"content": t} => React.element
