open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
  }
  include Jsonable.Unsafe

  @react.component
  let make = (~content: t) => <>
    <ConstructionBanner />
    <Page.TopImage title=content.title pageDescription=content.pageDescription>
      {<> </>}
    </Page.TopImage>
  </>

  module Params = Pages.Params.Lang

  let contentEn = {
    title: `What is OCaml`,
    pageDescription: `A description of OCaml's features.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
