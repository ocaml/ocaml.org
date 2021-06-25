open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
  }
  include Jsonable.Unsafe

  @react.component
  let make = (~content) => <>
    <ConstructionBanner />
    <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
  </>

  module Params = Pages.Params.Lang

  let contentEn = {
    title: `Platform`,
    pageDescription: `The OCaml Platform represents the best way for developers, both new and old, to write software in OCaml.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
