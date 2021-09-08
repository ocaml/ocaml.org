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
    <Page.Basic
      titleHeadingHeaderClassName="mt-1"
      addBottomBar=true
      addContainer=#NoContainer
      title=content.title
      pageDescription=content.pageDescription>
      {<> </>}
    </Page.Basic>
  </>

  let contentEn = {
    title: `Best Practices`,
    pageDescription: `Some guides to commonly used tools in OCaml development workflows.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
