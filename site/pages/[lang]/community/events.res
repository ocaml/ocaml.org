open! Import

module T = {
  type t = {
    title: string,
    pageDescription: string,
    events: array<Ood.Event.t>,
  }
  include Jsonable.Unsafe

  let dedicatedPage = (event: Ood.Event.t) => {
    // OCaml workshop pages
    switch List.find_opt(String.equal("ocaml-workshop"), event.tags) {
    | Some(_) =>
      switch Js.Date.fromString(event.date)->Js.Date.getFullYear {
      | 2020. => Some(#CommunityEventOud2020)
      | _ => None
      }
    | None => None
    }
  }

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: lang}) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1176%3A0`
    />
    <Page.TopImage title=content.title pageDescription=content.pageDescription>
      <div className="mb-16">
        <SectionContainer.MediumCentered>
          <Table.Simple
            content={{
              headers: ["Date", "Event Name", "Location", "Description"],
              data: Array.map((event: Ood.Event.t) => [
                <p> {React.string(event.date |> Js.Date.fromString |> Js.Date.toDateString)} </p>,
                switch dedicatedPage(event) {
                | Some(page) =>
                  <Next.Link href={page->Route.toString(lang)}>
                    <a className="text-orangedark underline"> {React.string(event.title)} </a>
                  </Next.Link>
                | None => <p> {React.string(event.title)} </p>
                },
                <p>
                  {React.string(
                    switch event.textual_location {
                    | Some(v) =>
                      if event.online {
                        v ++ " (virtual)"
                      } else {
                        v
                      }
                    | None =>
                      if event.online {
                        "Virtual"
                      } else {
                        "Unknown"
                      }
                    },
                  )}
                </p>,
                <p> {React.string(event.description)} </p>,
              ], content.events),
            }}
          />
        </SectionContainer.MediumCentered>
      </div>
    </Page.TopImage>
  </>

  let contentEn = {
    let events = Ood.Event.all->Belt.List.toArray
    {
      title: `Events`,
      pageDescription: `Several events take place in the OCaml community over the course of each year, in countries all over the world. This calendar will help you stay up to date on what is coming up in the OCaml sphere.`,
      events: events,
    }
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
