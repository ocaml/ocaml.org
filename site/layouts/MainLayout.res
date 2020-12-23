@react.component
let make = (~children, ~editpath) => {
  let minWidth = ReactDOMRe.Style.make(~minWidth="20rem", ()); // TODO: replace w/tailwind class
  <div style=minWidth className="flex lg:justify-center">

    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">

      <HeaderNavigation editpath={editpath} />

      <main className="mt-4 mx-4">
        children 
      </main>

    </div>

  </div>;
};
