open! Import

type t = {
  level: string,
  introduction: string,
}

@react.component
let make = (~content, ~marginBottom=?) => {
  <SectionContainer.SmallCentered ?marginBottom otherLayout="flex items-center space-x-20">
    <div className="text-5xl font-bold text-orangedark flex-shrink-0">
      {React.string(content.level ++ ` -`)}
    </div>
    <div className="font-bold text-xl"> {React.string(content.introduction)} </div>
  </SectionContainer.SmallCentered>
}
