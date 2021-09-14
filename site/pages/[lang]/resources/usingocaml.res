open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: _}) => <>
    <ConstructionBanner />
    <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
  </>

  let contentEn = {
    title: `Using OCaml`,
    pageDescription: `Besides developing in the language and making your own applications, there are many useful tools that already exist in OCaml for you to use.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
