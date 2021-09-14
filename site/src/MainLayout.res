open! Import

@react.component
let make = (~lang, ~children) =>
  // TODO: change element to body, move to document.res
  <div className="bg-white">
    <Milestones content={GlobalData.milestonesContent(lang)} />
    <div className="relative shadow">
      <HeaderNavigation content={GlobalData.headerContent(lang)} />
    </div>
    <main className="relative bg-graylight pb-1">
      // pb-1 is used to prevent margin-bottom from collapsing on last child
      children
    </main>
    <div className="relative"> <Footer content={GlobalData.footerContent(lang)} /> </div>
  </div>
