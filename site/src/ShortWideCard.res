let s = React.string

@react.component
let make = (~name: string, ~url: string, ~logoSrc: string) => {
  // TODO: for accessibilty, add visual indicator that link opens a tab
  let cardStyle = "bg-white rounded-md shadow-md overflow-hidden px-8 py-4"
  <a
    className={`font-roboto flex items-center justify-start space-x-8 ${cardStyle}`}
    href=url
    target="_blank">
    <img className="w-12 h-12 lg:w-20 lg:h-20" src=logoSrc />
    <span className="text-2xl"> {s(name)} </span>
  </a>
}
