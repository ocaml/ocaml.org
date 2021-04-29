@react.component
let make = (~children) =>
  // TODO: change element to body, move to document.res
  <div className="bg-white">
    <Milestones content=GlobalData.milestonesContentEn />
    <div className="relative shadow"> <HeaderNavigation content=GlobalData.headerContentEn /> </div>
    <main className="relative bg-graylight pb-1">
      // pb-1 is used to prevent margin-bottom from collapsing on last child
      children
    </main>
    <div className="relative"> <Footer content=GlobalData.footerContentEn /> </div>
  </div>
