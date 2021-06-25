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
    <Page.Basic title=content.title pageDescription=content.pageDescription> {<> </>} </Page.Basic>
  </>

  module Params = Pages.Params.Lang

  let contentEn = {
    title: `News Archive`,
    pageDescription: `Archive of news presented in the News page.`,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
