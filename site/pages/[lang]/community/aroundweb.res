open! Import

module T = {
  module LatestNews = {
    // TODO: finish out extracting strings into content
    type t = {news: array<Ood.News.t>}

    @react.component
    let make = (~content) =>
      <SectionContainer.LargeCentered paddingY="py-16">
        <h2
          className="mb-8 text-3xl text-center tracking-tight font-extrabold text-gray-900 sm:text-4xl">
          {React.string(`What's the Latest?`)}
        </h2>
        <MediaObject
          imageHeight="h-28 sm:h-64"
          imageWidth="w-28 sm:w-64"
          isRounded=true
          image="typewriter.jpeg"
          imageSide=#Left>
          <div className="bg-white border border-gray-300 overflow-hidden rounded-md mb-2">
            <ul className="divide-y divide-gray-300">
              {
                let toItem = (n: Ood.News.t) => {
                  StackedList.BasicWithIcon.Item.link: n.url,
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
              {React.string(`Go to the news archive >`)}
            </a>
          </p>
        </MediaObject>
      </SectionContainer.LargeCentered>
  }

  module Events = {
    type t = {
      title: string,
      description: string,
      callToAction: string,
      latestEvents: array<Ood.Event.t>,
    }

    @react.component
    let make = (~content, ~lang) => {
      let right =
        <div className="flex h-full pb-8 sm:pb-0 items-center justify-center">
          <div>
            {content.latestEvents
            |> Array.mapi((idx, event: Ood.Event.t) =>
              <div key={event.title}>
                <div className="relative pb-3">
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
                      <div>
                        <p className="text-sm text-gray-500"> {React.string(event.title)} </p>
                      </div>
                      <div className="text-right text-sm whitespace-nowrap text-gray-500">
                        <time dateTime={event.date}>
                          {React.string(event.date |> Js.Date.fromString |> Js.Date.toDateString)}
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
      let left =
        <div className="flex h-full flex-col items-center justify-center">
          <div className="py-8 sm:pl-12">
            <CallToAction.Embedded
              t={
                CallToAction.title: content.title,
                body: content.description,
                buttonLink: #Route(#CommunityEvents, lang),
                buttonText: content.callToAction,
              }
            />
          </div>
        </div>
      <SplitCard.LargeCentered left right />
    }
  }

  module Space = {
    type t = {
      logoSrc: string,
      name: string,
      url: string,
    }
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
    blogEntries: (BlogCard.Entry.t, BlogCard.Entry.t, BlogCard.Entry.t),
    blogArchiveText: string,
    spacesSectionHeader: string,
    spaces: array<Space.t>,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: lang}) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1040%3A104`
      playgroundLink=`/play/community/aroundweb`
    />
    <Page.Basic
      title=content.title pageDescription=content.pageDescription addContainer=#NoContainer>
      <div className="mb-16">
        <CallToAction.General
          t={
            CallToAction.title: content.engageHeader,
            body: content.engageBody,
            buttonLink: #External("https://discuss.ocaml.org"),
            buttonText: content.engageButtonText,
          }
          colorStyle=#BackgroundFilled
        />
      </div>
      <LatestNews content=content.latestNewsContent />
      <Events content=content.events lang />
      <BlogCard
        header=content.blogSectionHeader
        description=content.blogSectionDescription
        blog=content.blog
        archiveText=content.blogArchiveText>
        {content.blogEntries}
      </BlogCard>
      <SectionContainer.LargeCentered paddingY="pb-14">
        <CardGrid
          cardData=content.spaces
          renderCard={(idx, s) =>
            <div key={string_of_int(idx)}>
              <ShortWideCard name=s.name logoSrc=s.logoSrc url=s.url />
            </div>}
          title=content.spacesSectionHeader
        />
      </SectionContainer.LargeCentered>
    </Page.Basic>
  </>

  let spaces = [
    {
      Space.name: "Github.com",
      logoSrc: "/static/github.png",
      url: "https://github.com/ocaml/ocaml",
    },
    {
      name: "Discord.com",
      logoSrc: "/static/discord.png",
      url: "https://discord.gg/cCYQbqN",
    },
    {
      name: "Reddit.com",
      logoSrc: "/static/reddit.png",
      url: "https://www.reddit.com/r/ocaml",
    },
    {
      name: "Caml-list",
      logoSrc: "/static/camllist.png",
      url: "https://sympa.inria.fr/sympa/arc/caml-list",
    },
    {
      name: "Twitter.com",
      logoSrc: "/static/twitter.png",
      url: "https://twitter.com/search?q=%23ocaml",
    },
    {
      name: "OCaml IRC Chat",
      logoSrc: "/static/irc.png",
      url: "irc://irc.libera.chat/#ocaml",
    },
  ]

  let contentEn = {
    let news = Belt.List.toArray(Ood.News.all)->Belt.Array.keepWithIndex((_, i) => i <= 3)

    let events = Belt.List.toArray(Ood.Event.all)

    {
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
      blogEntries: (
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
      ),
      blogArchiveText: `Go to the blog archive`,
      spacesSectionHeader: `Looking for More? Try these spaces:`,
      spaces: spaces,
    }
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
