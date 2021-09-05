open! Import

// TODO: Better bindings for this
type options = {inline: string, behaviour: string, block: string}
@send external scrollIntoView: (Dom.element, options) => unit = "scrollIntoView"

@react.component
let make = (
  ~marginBottom=?,
  ~label,
  ~items: array<'a>,
  ~iconComponent: (int, int, {"item": 'a}) => React.element,
  ~detailsComponent: {"item": 'a} => React.element,
) => {
  let marginBottom = (marginBottom :> option<Tailwind.t>)
  let (idx, setIdx) = React.useState(() => 0)
  let itemsRef = React.useRef(Array.init(Array.length(items), _ => Js.Nullable.null))
  let setItemsRef = (idx, element) => {
    itemsRef.current[idx] = element
  }

  let handleBookChange = index => {
    Js.Nullable.iter(itemsRef.current[index], (. el) =>
      scrollIntoView(el, {inline: "center", behaviour: "smooth", block: "center"})
    )
  }

  let handleClick = (dir, current) => {
    let newIdx = switch dir {
    | #Left => current - 1
    | #Right => current + 1
    }

    let length = Array.length(items)
    let newIdx = if newIdx < 0 {
      length + newIdx
    } else if newIdx >= length {
      newIdx - length
    } else {
      newIdx
    }
    handleBookChange(newIdx)
    newIdx
  }

  // TODO: define content type; extract content
  // TODO: use generic container
  <SectionContainer.LargeCentered paddingY="pt-16 pb-3 lg:pt-24 lg:pb-8">
    <div
      className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-5xl " ++
      Tailwind.Option.toClassName(marginBottom)}>
      <div className="px-4 py-5 sm:px-6 sm:py-9">
        <h2 className="text-center text-orangedark text-5xl font-bold mb-8">
          {React.string(label)}
        </h2>
        <div className="grid grid-cols-8 items-center mb-8 px-6">
          // TODO: define state to track location within books list, activate navigation
          <div
            tabIndex={0}
            className="flex justify-start cursor-pointer"
            // TODO: Improve the navigation using a keyboard
            onKeyDown={e => {
              if ReactEvent.Keyboard.keyCode(e) === 13 {
                setIdx(prev => handleClick(#Left, prev))
              }
            }}
            onClick={_ => setIdx(prev => handleClick(#Left, prev))}>
            // TODO: make navigation arrows accesssible
            <svg
              className="h-20" viewBox="0 0 90 159" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                fillRule="evenodd"
                clipRule="evenodd"
                d="M2.84806 86.0991L72.1515 155.595C76.1863 159.39 82.3571 159.39 86.1546 155.595C89.952 151.8 89.952 145.396 86.1546 141.601L23.734 79.2206L86.1546 16.8403C89.952 12.8081 89.952 6.64125 86.1546 2.84625C82.3571 -0.94875 76.1863 -0.94875 72.1515 2.84625L2.84806 72.105C-0.949387 76.1372 -0.949387 82.3041 2.84806 86.0991Z"
                fill="#ED7109"
              />
            </svg>
          </div>
          <div className="col-span-6 py-2 flex m-w-full overflow-x-hidden">
            {items
            ->Belt.Array.mapWithIndex((id, item) => {
              Js.log(item)
              <div
                className="px-4 flex items-center justify-center"
                key={string_of_int(id)}
                ref={ReactDOM.Ref.callbackDomRef(dom => setItemsRef(id, dom))}>
                {React.createElement(iconComponent(id, idx), {"item": item})}
              </div>
            })
            ->React.array}
          </div>
          <div
            tabIndex={0}
            className="flex justify-end cursor-pointer"
            onKeyDown={e => {
              if ReactEvent.Keyboard.keyCode(e) === 13 {
                setIdx(prev => handleClick(#Right, prev))
              }
            }}
            onClick={_ => setIdx(prev => handleClick(#Right, prev))}>
            <svg
              className="h-20" viewBox="0 0 90 159" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                fillRule="evenodd"
                clipRule="evenodd"
                d="M86.1546 72.3423L16.8512 2.84625C12.8164 -0.948746 6.64553 -0.948746 2.84809 2.84625C-0.949362 6.64127 -0.949362 13.0453 2.84809 16.8403L65.2686 79.2207L2.84809 141.601C-0.949362 145.633 -0.949362 151.8 2.84809 155.595C6.64553 159.39 12.8164 159.39 16.8512 155.595L86.1546 86.3363C89.952 82.3041 89.952 76.1373 86.1546 72.3423Z"
                fill="#ED7109"
              />
            </svg>
          </div>
        </div>
        <div className="w-full px-10">
          {switch items->Belt.Array.get(idx) {
          | Some(item) => React.createElement(detailsComponent, {"item": item})
          | None => <p> {React.string("Somethings gone wrong")} </p>
          }}
        </div>
      </div>
    </div>
  </SectionContainer.LargeCentered>
}
