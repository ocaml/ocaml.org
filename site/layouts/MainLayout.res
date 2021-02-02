@react.component
let make = (~children, ~editpath) =>
  <>
  <HeaderNavigation editpath={editpath} />
  <main className="mt-4 mx-4" role="main">
    children
  </main>
  <Footer />
  </>
