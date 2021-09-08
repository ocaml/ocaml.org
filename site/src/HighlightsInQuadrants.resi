module LabelledLink: {
  type t = {
    label: string,
    link: string,
  }
}

open! Import

module Story: {
  type t = {
    title: string,
    link: string,
  }
}

module CategoryHeader: {
  type t = {
    title: string,
    icon: [#Meet | #Package | #Profit | #Calendar],
  }
}

module Category: {
  type t = {
    header: CategoryHeader.t,
    stories: array<Story.t>,
    seeAllInCategory: LabelledLink.t,
  }
}

type t = {
  title: string,
  topLeftCategory: Category.t,
  topRightCategory: Category.t,
  bottomLeftCategory: Category.t,
  bottomRightCategory: Category.t,
  goToArchive: LabelledLink.t,
}

@react.component
let make: (~t: t) => React.element
