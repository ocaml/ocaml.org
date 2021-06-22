let s = React.string

@react.component
let make = (~title, ~graphicUrl, ~body) => {
  <div className="bg-white shadow-md overflow-hidden rounded-md px-10 py-8 sm:px-20 sm:py-12">
    <div className="flex flex-col sm:flex-row items-start sm:justify-between sm:items-center mb-4">
      <div className="order-2 sm:order-1 font-extrabold text-4xl font-serif"> {s(title)} </div>
      // Note: The image is decorative, so we intentionally provide an empty alt description
      <img className="order-1 sm:order-2 h-32" src=graphicUrl alt="" />
    </div>
    {s(body)}
  </div>
}
