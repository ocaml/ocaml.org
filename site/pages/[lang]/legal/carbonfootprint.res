open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content: t, ~params as {Params.lang: _}) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=931%3A6483`
    />
    <Page.TopImage title=content.title pageDescription=content.pageDescription>
      {<> </>}
    </Page.TopImage>
  </>

  let contentEn = {
    title: `Carbon Footprint`,
    pageDescription: `Over the years, the OCaml community has become more and more proactive when it comes to reducing its environmental impact. As part of this journey we have documented our efforts towards becoming Carbon Zero.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
