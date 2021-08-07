// TODO: better name, do not refer to heading use case specifically
module MediumCentered2 = {
  @react.component
  let make = (~children) => <div className="text-lg max-w-prose mx-auto"> children </div>
}

module ResponsiveCentered = {
  @react.component
  let make = (~children, ~marginBottom=?) =>
    <div
      className={marginBottom->Tailwind.Option.toClassName ++ " mx-auto sm:max-w-screen-sm lg:max-w-screen-lg"}>
      children
    </div>
}

module MediumCentered = {
  @react.component
  let make = (
    ~children,
    ~marginBottom=?,
    ~paddingX="",
    ~paddingY="",
    ~otherLayout="",
    ~filled=false,
  ) =>
    <div
      className={marginBottom->Tailwind.Option.toClassName ++
      " max-w-5xl mx-auto " ++
      paddingX ++
      " " ++
      paddingY ++
      " " ++
      otherLayout ++
      switch filled {
      | true => " bg-orangedark"
      | false => ""
      }}>
      children
    </div>
}

module FullyResponsiveCentered = {
  @react.component
  let make = (~children, ~paddingY="", ~paddingX="") =>
    <div className={"container mx-auto " ++ paddingY ++ " " ++ paddingX}> children </div>
}

module NoneFilled = {
  @react.component
  let make = (~children, ~marginBottom=?) =>
    <div className={"bg-orangedark " ++ marginBottom->Tailwind.Option.toClassName}> children </div>
}

module LargeCentered = {
  @react.component
  let make = (~children, ~paddingY="", ~paddingX="", ~bgColor="") =>
    <div className={paddingY ++ " " ++ paddingX ++ " " ++ bgColor}>
      <div className="max-w-7xl mx-auto"> children </div>
    </div>
}

module SmallCentered = {
  @react.component
  let make = (~children, ~marginBottom=?, ~otherLayout="") =>
    <div
      className={"mx-auto max-w-4xl " ++
      otherLayout ++
      " " ++
      marginBottom->Tailwind.Option.toClassName}>
      children
    </div>
}

module VerySmallCentered = {
  @react.component
  let make = (~children, ~marginBottom=?, ~paddingY="", ~paddingX="") => {
    <div
      className={"mx-auto max-w-3xl " ++
      marginBottom->Tailwind.Option.toClassName ++
      " " ++
      paddingY ++
      " " ++
      paddingX}>
      children
    </div>
  }
}
