@react.component
let make = (~children /*, ~editpath */ ) =>
  <div className="bg-white"> { /* TODO: change element to body, move to document.res */  React.null }
    <div className="relative shadow">
      { /* <HeaderNavigation editpath={editpath} /> */ React.null }
    </div>
    <main className="relative bg-graylight">
      children
    </main>
    <div className="relative">
      <Footer />
    </div>
  </div>
