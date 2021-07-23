module LargeCentered = {
  @react.component
  let make = (~left: React.element, ~right: React.element) =>
    <SectionContainer.LargeCentered>
      <div className="grid gird-cols-1 sm:grid-cols-2 gap-4 bg-white ">
        <div> {left} </div> <div> {right} </div>
      </div>
    </SectionContainer.LargeCentered>
}

module MediumCentered = {
  @react.component
  let make = (~left: React.element, ~right: React.element) =>
    <SectionContainer.MediumCentered>
      <div className="grid gird-cols-1 sm:grid-cols-2 gap-4 bg-white ">
        <div> {left} </div> <div> {right} </div>
      </div>
    </SectionContainer.MediumCentered>
}
