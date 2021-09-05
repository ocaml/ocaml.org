open! Import

type item = {
  title: string,
  description: string,
  url: string,
}

@react.component
let make: (
  ~title: string,
  ~buttonText: string,
  ~buttonRoute: Route.t,
  ~lang: Lang.t,
  ~children: (item, item, item),
) => React.element
