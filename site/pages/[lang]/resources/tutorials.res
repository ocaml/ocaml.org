open! Import

// TODO: A design for this page, this is just a placeholder

module Tutorial = {
  @react.component
  let make = (~tutorial, ~lang) =>
    <div className="py-4 px-4 bg-white rounded-lg">
      <div className="prose">
        <h2> {React.string(tutorial.Ood.Tutorial.title)} </h2>
        <p> {React.string(tutorial.description)} </p>
      </div>
      <Route _to={#ResourcesTutorial(tutorial.slug)} lang>
        <a className="text-orangedark"> {React.string("Read more...")} </a>
      </Route>
    </div>
}

module T = {
  type t = {
    title: string,
    pageDescription: string,
    tutorials: array<Ood.Tutorial.t>,
  }

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: lang}) => {
    <>
      <ConstructionBanner />
      <Page.Basic title=content.title pageDescription=content.pageDescription>
        <div className="pb-8">
          <CardGrid
            cardData=content.tutorials
            renderCard={(t: Ood.Tutorial.t) => <Tutorial tutorial=t lang />}
          />
        </div>
      </Page.Basic>
    </>
  }

  include Jsonable.Unsafe

  let contentEn = {
    title: `Tutorials`,
    pageDescription: ``,
    tutorials: Ood.Tutorial.all->Belt.List.toArray,
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
