let s = React.string

module MediaSection = {
  // TODO: define complete content type; factor out content
  type t = {
    title: string,
    image: string,
  }

  @react.component
  let make = (~content) =>
    <div className="container mx-auto pt-6 px-4">
      <div className="rounded-lg shadow overflow-y-auto relative"> <img src=content.image /> </div>
      <h2 className="font-semibold text-2xl py-9 sm:text-3xl"> {s(content.title)} </h2>
      // Generic Highlight Component
      <div className="rounded-lg shadow overflow-y-auto relative">
        <ul>
          <li className="p-6 grid grid-cols-8 w-full cursor-pointer hover:bg-gray-100">
            <p className="text-yellow-600 col-span-5 font-semibold">
              {s(`How to Code a Camel by Dr. Dromedary`)}
            </p>
            <p className="text-gray-400 text-sm col-span-2 ml-4"> {s(`02-01-2021`)} </p>
            <p className="text-right"> {s(` -> `)} </p>
          </li>
          <li className="p-6 grid grid-cols-8 w-full border-t cursor-pointer hover:bg-gray-100">
            <p className="text-yellow-600 col-span-5 font-semibold">
              {s(`Innovation in the Open-Source Field by Jane Street`)}
            </p>
            <p className="text-gray-400 text-sm col-span-2 ml-4"> {s(`02-01-2021`)} </p>
            <p className="text-right"> {s(` -> `)} </p>
          </li>
          <li className="p-6 grid grid-cols-8 w-full border-t cursor-pointer hover:bg-gray-100">
            <p className="text-yellow-600 col-span-5 font-semibold">
              {s(`Let Me Know Wherefore by B.C.K Strit-Buoy`)}
            </p>
            <p className="text-gray-400 text-sm col-span-2 ml-4"> {s(`02-01-2021`)} </p>
            <p className="text-right"> {s(` -> `)} </p>
          </li>
        </ul>
      </div>
      // TODO: enable link and create video archive page
      <p className="text-right py-6 cursor-pointer hover:underline font-semibold text-yellow-600">
        {s(`Browse More ` ++ content.title)}
      </p>
    </div>
}

type t = {
  title: string,
  pageDescription: string,
}

let contentEn = {
  title: `Media Archive`,
  pageDescription: `This is where you can find archived videos, slides from talks, and other media produced by people in the OCaml Community.`,
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A25378`
    playgroundLink=`/play/resources/mediaarchive`
  />
  <div className="max-w-3xl mx-auto">
    <TitleHeading title=content.title pageDescription=content.pageDescription />
    <MediaSection
      content={
        MediaSection.title: `Videos`,
        image: `https://images.unsplash.com/photo-1485846234645-a62644f84728?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1640&q=80`,
      }
    />
    <MediaSection
      content={
        MediaSection.title: `Talks and Slides`,
        image: `https://images.unsplash.com/photo-1560523160-754a9e25c68f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1320&q=80`,
      }
    />
    <MediaSection
      content={
        MediaSection.title: `Papers and Interviews`,
        image: `https://www.cst.cam.ac.uk/sites/www.cst.cam.ac.uk/files/view_from_nw.jpg`,
      }
    />
  </div>
</>

let default = make
