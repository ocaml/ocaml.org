let s = React.string

module MediaSection = {
  module Item = {
    type t = {
      name: string,
      author: string,
      creationDate: string, // TODO: date type
      link: string,
    }
  }

  // TODO: define complete content type; factor out content
  type t = {
    title: string,
    image: string,
    items: array<Item.t>,
  }

  @react.component
  let make = (~content) =>
    <div className="container mx-auto pt-6 px-4">
      <div className="rounded-lg shadow overflow-y-auto relative"> <img src=content.image /> </div>
      <h2 className="font-semibold text-2xl py-9 sm:text-3xl"> {s(content.title)} </h2>
      // Generic Highlight Component
      <div className="rounded-lg shadow overflow-y-auto relative">
        <ul>
          {content.items
          |> Array.mapi((idx, item: Item.t) =>
            // TODO: ensure link is accessible; indicator that link opens tab
            <a href=item.link target="_blank" key={Js.Int.toString(idx)}>
              <li className="p-6 grid grid-cols-8 w-full cursor-pointer hover:bg-gray-100">
                <p className="text-yellow-600 col-span-5 font-semibold">
                  {s(item.name ++ ` by ` ++ item.author)}
                </p>
                <p className="text-gray-400 text-sm col-span-2 ml-4"> {s(item.creationDate)} </p>
                <p className="text-right"> {s(` -> `)} </p>
              </li>
            </a>
          )
          |> React.array}
        </ul>
      </div>
      // TODO: enable link and create video archive page
      <p className="text-right py-6 cursor-pointer hover:underline font-semibold text-yellow-600">
        {s(`Browse More ` ++ content.title)}
      </p>
    </div>
}

type prop = {
  title: string,
  pageDescription: string,
  videosContent: MediaSection.t,
  talksContent: MediaSection.t,
  papersContent: MediaSection.t,
}

@react.component
let make = (~title, ~pageDescription, ~videosContent, ~talksContent, ~papersContent) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A25378`
    playgroundLink=`/play/resources/mediaarchive`
  />
  <div className="max-w-3xl mx-auto">
    <TitleHeading.Large title pageDescription />
    <MediaSection content=videosContent />
    <MediaSection content=talksContent />
    <MediaSection content=papersContent />
  </div>
</>

let getStaticProps = _ctx => {
  // TODO: define and read highlight items for each list
  let talks = Array.map(t => {
    MediaSection.Item.name: t.Talk.name,
    author: t.author,
    creationDate: t.creationDate,
    link: t.link,
  }, Talk.readAll())
  let fillerContent = [
    {
      MediaSection.Item.name: `How to Code a Camel 1`,
      author: `Dr. Dromedary`,
      creationDate: `02-01-2021`,
      link: `https://youtube.com`,
    },
    {
      MediaSection.Item.name: `How to Code a Camel 2`,
      author: `Dr. Dromedary`,
      creationDate: `02-01-2021`,
      link: `https://youtube.com`,
    },
    {
      MediaSection.Item.name: `How to Code a Camel 3`,
      author: `Dr. Dromedary`,
      creationDate: `02-01-2021`,
      link: `https://youtube.com`,
    },
  ]

  // TODO: read videos
  let videosContent = {
    MediaSection.title: `Videos`,
    image: `https://images.unsplash.com/photo-1485846234645-a62644f84728?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1640&q=80`,
    items: fillerContent,
  }
  let talksContent = {
    MediaSection.title: `Talks and Slides`,
    image: `https://images.unsplash.com/photo-1560523160-754a9e25c68f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1320&q=80`,
    items: talks,
  }
  // TODO: read papers
  // TODO: read interviews
  let papersContent = {
    MediaSection.title: `Papers and Interviews`,
    image: `https://www.cst.cam.ac.uk/sites/www.cst.cam.ac.uk/files/view_from_nw.jpg`,
    items: fillerContent,
  }

  let title = `Media Archive`
  let pageDescription = `This is where you can find archived videos, slides from talks, and other media produced by people in the OCaml Community.`
  {
    "props": {
      title: title,
      pageDescription: pageDescription,
      videosContent: videosContent,
      talksContent: talksContent,
      papersContent: papersContent,
    },
  }
}

let default = make
