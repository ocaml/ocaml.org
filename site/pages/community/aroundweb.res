let s = React.string

module LatestNews = {
  // TODO: finish out extracting strings into content
  type t = {news: array<NewsItem.t>}

  @react.component
  let make = (~content) =>
    <SectionContainer.LargeCentered paddingY="py-16">
      <h2
        className="mb-8 text-3xl text-center tracking-tight font-extrabold text-gray-900 sm:text-4xl">
        {s(`What's the Latest?`)}
      </h2>
      <MediaObject
        imageHeight="h-28 sm:h-64"
        imageWidth="w-28 sm:w-64"
        isRounded=true
        image="typewriter.jpeg"
        imageSide=MediaObject.Left>
        <div className="bg-white border border-gray-300 overflow-hidden rounded-md mb-2">
          <ul className="divide-y divide-gray-300">
            {
              let toItem = (n: NewsItem.t) => {
                StackedList.BasicWithIcon.Item.link: n.link,
                title: n.title,
              }
              <StackedList.BasicWithIcon
                items={content.news |> Array.map(toItem)}
                rowPrefixIcon=StackedList.BasicWithIcon.RowPrefixIcon.PaperScroll
              />
            }
          </ul>
        </div>
        <p className="text-xs text-right">
          <a className="text-orangedark hover:text-orangedark" href="/community/newsarchive">
            {s(`Go to the news archive >`)}
          </a>
        </p>
      </MediaObject>
    </SectionContainer.LargeCentered>
}

type blogEntry = {
  title: string,
  excerpt: string,
  author: string,
  dateValue: string,
  date: string,
  readingTime: string,
}

module Events = {
  type t = {
    title: string,
    description: string,
    callToAction: string,
    latestEvents: array<Event.t>,
  }

  @react.component
  let make = (~content) =>
    <SectionContainer.LargeCentered>
      <div className="relative bg-white">
        <div className="pt-12 h-56 sm:h-72 md:absolute md:left-0 md:h-full md:w-1/2">
          <div className="mx-auto px-4 py-4 sm:px-6 lg:px-8 lg:py-16 h-full">
            // TODO: Implement the calendar approach
            <div className="flex flex-col justify-center h-full">
              {content.latestEvents
              |> Array.mapi((idx, event: Event.t) =>
                <div key={event.title}>
                  <div className="relative pb-8">
                    {idx !== Array.length(content.latestEvents) - 1
                      ? <span
                          className="absolute top-3 left-3 -ml-px h-full w-0.5 bg-gray-200"
                          ariaHidden=true
                        />
                      : <> </>}
                    <div className="relative flex space-x-3">
                      <div>
                        <span
                          className="h-6 w-6 rounded-full flex items-center justify-center bg-orangedark"
                        />
                      </div>
                      <div className="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                        <div> <p className="text-sm text-gray-500"> {s(event.title)} </p> </div>
                        <div className="text-right text-sm whitespace-nowrap text-gray-500">
                          <time dateTime={event.date}>
                            {s(event.date |> Js.Date.fromString |> Js.Date.toDateString)}
                          </time>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )
              |> React.array}
            </div>
          </div>
        </div>
        <div className="relative max-w-7xl mx-auto px-4 py-12 sm:px-6 lg:px-8 lg:py-16">
          <div className="md:ml-auto md:w-1/2 md:pl-10">
            <p
              className="mt-2 text-orangedark text-center text-3xl font-extrabold tracking-tight sm:text-4xl">
              {s(content.title)}
            </p>
            <p className="mt-3 text-center text-lg text-gray-900"> {s(content.description)} </p>
            <div className="mt-8 text-center">
              <div className="inline-flex rounded-md shadow">
                <Next.Link href=InternalUrls.communityEvents>
                  <a
                    className="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-orangedark">
                    {s(content.callToAction)}
                  </a>
                </Next.Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SectionContainer.LargeCentered>
}

type t = {
  title: string,
  pageDescription: string,
  engageHeader: string,
  engageBody: string,
  engageButtonText: string,
  latestNewsContent: LatestNews.t,
  events: Events.t,
  blogSectionHeader: string,
  blogSectionDescription: string,
  blog: string,
  blogEntries: array<blogEntry>,
  blogArchiveText: string,
  spacesSectionHeader: string,
  spaces: array<string>,
}

type props = {content: t}

@react.component
let make = (~content) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1040%3A104`
    playgroundLink=`/play/community/aroundweb`
  />
  <Page.Basic
    title=content.title pageDescription=content.pageDescription addContainer=Page.Basic.NoContainer>
    <SectionContainer.NoneFilled marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())}>
      <div className="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
        <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
          <span className="block"> {s(content.engageHeader)} </span>
        </h2>
        <p className="mt-4 text-lg leading-6 text-white"> {s(content.engageBody)} </p>
        <a
          className="mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md bg-white hover:bg-orangelight sm:w-auto"
          href="https://discuss.ocaml.org"
          target="_blank">
          {s(content.engageButtonText)}
        </a>
      </div>
    </SectionContainer.NoneFilled>
    <LatestNews content=content.latestNewsContent />
    <Events content=content.events />
    <SectionContainer.LargeCentered
      paddingY="pt-16 pb-3 lg:pt-24 lg:pb-8" paddingX="px-4 sm:px-6 lg:px-8">
      <div className="text-center">
        <h2 className="text-3xl tracking-tight font-extrabold text-gray-900 sm:text-4xl">
          {s(content.blogSectionHeader)}
        </h2>
        <p className="mt-3 max-w-2xl mx-auto text-xl text-gray-500 sm:mt-4">
          {s(content.blogSectionDescription)}
        </p>
      </div>
      <div className="mt-12 max-w-lg mx-auto grid gap-5 lg:grid-cols-3 lg:max-w-none">
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1496128858413-b36217c2ce36?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[0].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[0].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[0].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[0].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[0].dateValue>
                    {s(content.blogEntries[0].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[0].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1547586696-ea22b4d4235d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[1].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[1].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[1].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[1].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[1].dateValue>
                    {s(content.blogEntries[1].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[1].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1492724441997-5dc865305da7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[2].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[2].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[2].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[2].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[2].date>
                    {s(content.blogEntries[2].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[2].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <p className="mt-5 text-right">
        <a className="font-semibold text-orangedark" href="#">
          {s(content.blogArchiveText ++ ` >`)}
        </a>
      </p>
    </SectionContainer.LargeCentered>
    <SectionContainer.LargeCentered paddingY="pb-14">
      <h2
        className="text-center text-3xl tracking-tight font-extrabold text-gray-900 sm:text-4xl py-6 px-4 sm:py-12 sm:px-6 lg:px-8">
        {s(content.spacesSectionHeader)}
      </h2>
      <div className="mx-auto max-w-4xl px-12">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[0])}
          </a>
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[1])}
          </a>
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[2])}
          </a>
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[3])}
          </a>
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[4])}
          </a>
          <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
            {s(content.spaces[5])}
          </a>
        </div>
      </div>
    </SectionContainer.LargeCentered>
  </Page.Basic>
</>

type pageContent = {spaces: array<string>}

let decode = json => {
  open Json.Decode
  {
    spaces: json |> field("spaces", array(string)),
  }
}

let getStaticProps = _ctx => {
  let news = NewsItem.readAll()

  let pageContent = "pages/community/aroundweb.yaml"->Fs.readFileSync->JsYaml.load()->decode

  let events = EventsData.readAll().events->Array.of_list
  let _ = Array.sort((a, b) => Event.compare_by_date(b, a), events)
  let events = Belt.Array.sliceToEnd(events, -3)
  let events = Array.map(event => Event.toJson(event)->Next.stripUndefined->Event.fromJson, events)

  let contentEn = {
    title: `OCaml Around the Web`,
    pageDescription: `Looking to interact with people who are also interested in OCaml? Find out about upcoming events, read up on blogs from the community, sign up for OCaml mailing lists, and discover even more places to engage with people from the community!`,
    engageHeader: `Want to engage with the OCaml Community?`,
    engageBody: `Participate in discussions on everything OCaml over at discuss.ocaml.org, where members of the community post`,
    engageButtonText: `Take me to Discuss`,
    latestNewsContent: {
      news: news,
    },
    events: {
      Events.title: "Events",
      description: "Several events take place in the OCaml community over the course of each year, in countries all over the world. This calendar will help you stay up to date on what is coming up in the OCaml sphere. ",
      callToAction: "Show me Events",
      latestEvents: events,
    },
    blogSectionHeader: `Recent Blog Posts`,
    blogSectionDescription: `Be inspired by the work of OCaml programmers all over the world and stay up-to-date on the latest developments.`,
    blog: `Blog`,
    blogEntries: [
      {
        title: `What I learned Coding from Home`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Roel Aufderehar`,
        dateValue: `2020-03-16`,
        date: `Mar 16, 2020`,
        readingTime: `6`,
      },
      {
        title: `Programming for a Better World`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Roel Aufderehar`,
        dateValue: `2020-03-16`,
        date: `Mar 16, 2020`,
        readingTime: `6`,
      },
      {
        title: `Methods for Irmin V2`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Daniela Metz`,
        dateValue: `2020-02-12`,
        date: `Feb 12, 2020`,
        readingTime: `11`,
      },
    ],
    blogArchiveText: `Go to the blog archive`,
    spacesSectionHeader: `Looking for More? Try these spaces:`,
    spaces: pageContent.spaces,
  }

  Js.Promise.resolve({
    "props": {content: contentEn},
  })
}

let default = make
