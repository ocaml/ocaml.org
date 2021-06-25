type t = {
  title: string,
  pageDescription: string,
  events: array<Ood.Event.t>,
}

let s = React.string

let dedicated_page = (event: Ood.Event.t) => {
  // OCaml workshop pages
  switch List.find_opt(String.equal("ocaml-workshop"), event.tags) {
  | Some(_) =>
    switch Js.Date.fromString(event.date)->Js.Date.getFullYear {
    | 2020. => Some(InternalUrls.communityEventOud2020)
    | _ => None
    }
  | None => None
  }
}

@react.component
let make = (~content) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1176%3A0`
  />
  <Page.TopImage title=content.title pageDescription=content.pageDescription>
    <SectionContainer.MediumCentered marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())}>
      <Table.Simple
        content={{
          headers: ["Date", "Event Name", "Location", "Description"],
          data: Array.map((event: Ood.Event.t) => [
            <p> {s(event.date |> Js.Date.fromString |> Js.Date.toDateString)} </p>,
            switch dedicated_page(event) {
            | Some(page) =>
              <Next.Link href={page}>
                <a className="text-orangedark underline"> {s(event.title)} </a>
              </Next.Link>
            | None => <p> {s(event.title)} </p>
            },
            <p>
              {s(
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
            <p> {s(event.description)} </p>,
          ], content.events),
        }}
      />
    </SectionContainer.MediumCentered>
  </Page.TopImage>
</>

type props = {content: t}

type pageContent = {
  title: string,
  pageDescription: string,
}

let getStaticProps = _ctx => {
  let pageContentEn = {
    title: `Events`,
    pageDescription: `Several events take place in the OCaml community over the course of each year, in countries all over the world. This calendar will help you stay up to date on what is coming up in the OCaml sphere.`,
  }
  let events = Array.of_list(Ood.Event.all->Next.stripUndefined)
  Js.Promise.resolve({
    "props": {
      content: {
        title: pageContentEn.title,
        pageDescription: pageContentEn.pageDescription,
        events: events,
      },
    },
  })
}

let default = make
