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
    <Page.Basic
      marginTop=`mt-1`
      addBottomBar=true
      addContainer=Page.Basic.NoContainer
      title=content.title
      pageDescription=content.pageDescription>
      {<> </>}
    </Page.Basic>
  </>

  let contentEn = {
    title: `Best Practices`,
    pageDescription: `Some guides to commonly used tools in OCaml development workflows.`,
  }

  module Params = Pages.Params.Lang

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
