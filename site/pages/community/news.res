let s = React.string

module NewsCategory = {
  type t = {
    header: string,
    seeAllNewsInCategory: string,
    stories: array<HighlightsInQuadrants.Story.t>,
  }

  let toHighlightsCategory = (category, seeAllLink, icon) => {
    HighlightsInQuadrants.Category.header: {
      HighlightsInQuadrants.CategoryHeader.title: category.header,
      icon: icon,
    },
    seeAllInCategory: {
      label: category.seeAllNewsInCategory,
      link: seeAllLink,
    },
    stories: category.stories,
  }
}

module CategorizedNews = {
  type t = {
    otherNewsStories: string,
    communityCategory: NewsCategory.t,
    releasesCategory: NewsCategory.t,
    industryCategory: NewsCategory.t,
    eventsCategory: NewsCategory.t,
    goToNewsArchive: string,
  }

  let toHighlightsInQuadrantsContent = t => {
    HighlightsInQuadrants.title: t.otherNewsStories,
    topLeftCategory: NewsCategory.toHighlightsCategory(
      t.communityCategory,
      InternalUrls.communityNewsarchive, // TODO: should we use a query parameter for the category?
      HighlightsInQuadrants.CategoryHeaderIcon.Meet,
    ),
    topRightCategory: NewsCategory.toHighlightsCategory(
      t.releasesCategory,
      InternalUrls.communityNewsarchive,
      HighlightsInQuadrants.CategoryHeaderIcon.Package,
    ),
    bottomLeftCategory: NewsCategory.toHighlightsCategory(
      t.industryCategory,
      InternalUrls.communityNewsarchive,
      HighlightsInQuadrants.CategoryHeaderIcon.Profit,
    ),
    bottomRightCategory: NewsCategory.toHighlightsCategory(
      t.eventsCategory,
      InternalUrls.communityNewsarchive,
      HighlightsInQuadrants.CategoryHeaderIcon.Calendar,
    ),
    goToArchive: {
      label: t.goToNewsArchive,
      link: InternalUrls.communityNewsarchive,
    },
  }
}

module WeeklyNews = {
  type t = {
    ocamlWeeklyNews: string,
    overview: string,
  }

  @react.component
  let make = (~content, ~marginBottom=?) =>
    <SectionContainer.MediumCentered ?marginBottom>
      <div className="lg:grid lg:grid-cols-2 items-center">
        <div className="lg:order-2">
          <h2 className="text-orangedark text-2xl font-bold text-center lg:text-4xl mb-9">
            {s(content.ocamlWeeklyNews)}
          </h2>
          <p className="text-center">
            {s(content.overview ++ ` `)}
            // TODO: visual indicator for link opening new tab
            <a
              className="text-orangedark underline"
              href="http://alan.petitepomme.net/cwn/"
              target="_blank">
              {s(`alan.petitepomme.net`)}
            </a>
          </p>
        </div>
        <div className="lg:order-1">
          // TODO: research and select react-calendar
          <div className="">
            <div className="text-orangedark font-bold text-3xl text-center mb-4">
              {/*
              <svg
                className="h-4 inline mr-2"
                viewBox="0 0 20 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M19.5607 17.5607C18.9749 18.1464 18.0251 18.1464 17.4393 17.5607L9.93934 10.0607C9.35355 9.47487 9.35356 8.52513 9.93934 7.93934L17.4393 0.439341C18.0251 -0.146446 18.9749 -0.146446 19.5607 0.439341C20.1465 1.02513 20.1465 1.97488 19.5607 2.56066L13.1213 9L19.5607 15.4393C20.1465 16.0251 20.1465 16.9749 19.5607 17.5607ZM10.5607 17.5607C9.97487 18.1464 9.02513 18.1464 8.43934 17.5607L0.93934 10.0607C0.353553 9.47487 0.353553 8.52512 0.939341 7.93934L8.43934 0.43934C9.02513 -0.146447 9.97488 -0.146447 10.5607 0.439341C11.1464 1.02513 11.1464 1.97487 10.5607 2.56066L4.12132 9L10.5607 15.4393C11.1464 16.0251 11.1464 16.9749 10.5607 17.5607Z"
                  fill="#ED7109"
                />
              </svg>
 */
              s(`2021`)}
              /*
              <svg
                className="h-4 inline ml-2"
                viewBox="0 0 20 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M0.439337 0.439341C1.02512 -0.146446 1.97487 -0.146446 2.56066 0.439341L10.0607 7.93934C10.6464 8.52513 10.6464 9.47487 10.0607 10.0607L2.56066 17.5607C1.97487 18.1464 1.02512 18.1464 0.439337 17.5607C-0.14645 16.9749 -0.14645 16.0251 0.439337 15.4393L6.87868 9L0.439337 2.56066C-0.14645 1.97487 -0.14645 1.02513 0.439337 0.439341ZM9.43934 0.439341C10.0251 -0.146446 10.9749 -0.146444 11.5607 0.439341L19.0607 7.93934C19.6464 8.52513 19.6464 9.47488 19.0607 10.0607L11.5607 17.5607C10.9749 18.1464 10.0251 18.1464 9.43934 17.5607C8.85355 16.9749 8.85355 16.0251 9.43934 15.4393L15.8787 9L9.43934 2.56066C8.85355 1.97487 8.85355 1.02513 9.43934 0.439341Z"
                  fill="#ED7109"
                />
              </svg>
 */
            </div>
            <div className="mx-auto bg-white shadow-sm text-2xl w-80 py-5">
              <div className="font-bold text-orangedark text-center mb-4"> {s(`February`)} </div>
              <div className="grid grid-cols-7 gap-3 px-6 justify-items-center">
                <div> {s(`1`)} </div>
                <div> {s(`2`)} </div>
                <div> {s(`3`)} </div>
                <div> {s(`4`)} </div>
                <div> {s(`5`)} </div>
                <div> {s(`6`)} </div>
                <div> {s(`7`)} </div>
                <div> {s(`8`)} </div>
                <div> {s(`9`)} </div>
                <div> {s(`10`)} </div>
                <div> {s(`11`)} </div>
                <div> {s(`12`)} </div>
                <div> {s(`13`)} </div>
                <div> {s(`14`)} </div>
                <div> {s(`15`)} </div>
                <div> {s(`16`)} </div>
                <div> {s(`17`)} </div>
                <div> {s(`18`)} </div>
                <div> {s(`19`)} </div>
                <div> {s(`20`)} </div>
                <div> {s(`21`)} </div>
                <div> {s(`22`)} </div>
                <div> {s(`23`)} </div>
                <div> {s(`24`)} </div>
                <div> {s(`25`)} </div>
                <div> {s(`26`)} </div>
                <div> {s(`27`)} </div>
                <div> {s(`28`)} </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </SectionContainer.MediumCentered>
}

type t = {
  title: string,
  pageDescription: string,
  highlightContent: Page.highlightContent,
  categorizedNews: CategorizedNews.t,
  weeklyNews: WeeklyNews.t,
}

let contentEn = {
  title: `OCaml News`,
  pageDescription: `This is where you'll find the latest stories from the OCaml Community! Periodically, we will also highlight individual stories that `,
  highlightContent: {
    highlightItem: `Highlighted Story`,
    clickToRead: `Click to Read`,
    highlightItemSummary: {
      preview: `Isabella Leandersson interviewed speakers at the 2020 OCaml workshop at ICFP. Click through to read about what they had to say.`,
      url: `/community/isabelle-leandersson-interviewed-speakers`,
    },
    bgImageClass: `bg-news-bg`,
  },
  categorizedNews: {
    otherNewsStories: `Other News Stories`,
    communityCategory: {
      header: `Community`,
      seeAllNewsInCategory: `See all News in Community`,
      stories: [
        {
          title: `The road ahead for Mirage OS in 2021`,
          link: `https://hannes.robur.coop/Posts/NGI`,
        },
        {
          title: `How we lost at the Delphi Oracle Challenge`,
          link: `https://seb.mondet.org/b/0010-delphi-challenge-post-vivum.html`,
        },
        {
          title: `"Universal" Dune Tip: Rebuild Stuff, Sometimes`,
          link: `https://seb.mondet.org/b/0009-dune-universe-hack.html`,
        },
      ],
    },
    releasesCategory: {
      header: `Releases`,
      seeAllNewsInCategory: `See all News in Releases`,
      stories: [
        {
          title: `Release of Alt-Ergo 2.4.0`,
          link: `https://www.ocamlpro.com/2021/01/22/release-of-alt-ergo-2-4-0/`,
        },
        {
          title: `Coq 8.13.0 is out`,
          link: `https://coq.inria.fr/news/coq-8-13-0-is-out.html`,
        },
        {
          title: `Coq 8.12.2 is out`,
          link: `https://coq.inria.fr/news/coq-8-12-2-is-out.html`,
        },
      ],
    },
    industryCategory: {
      header: `Industry`,
      seeAllNewsInCategory: `See all News in Industry`,
      stories: [
        {
          title: `Recent and Upcoming Changes to Merlin`,
          link: `https://tarides.com/blog/2021-01-26-recent-and-upcoming-changes-to-merlin`,
        },
        {
          title: `Memthol: Exploring Program Profiling`,
          link: `https://www.ocamlpro.com/2020/12/01/memthol-exploring-program-profiling/`,
        },
        {
          title: `Growing the Hardcaml Toolset`,
          link: `https://blog.janestreet.com/growing-the-hardcaml-toolset-index/`,
        },
      ],
    },
    eventsCategory: {
      header: `Events`,
      seeAllNewsInCategory: `See all News in Events`,
      stories: [
        {
          title: `Tarides Sponsors the Oxbridge Women in ...`,
          link: `https://tarides.com/blog/2020-12-14-tarides-sponsors-the-oxbridge-women-in-computer-science-conference-2020/`,
        },
        {
          title: `Every Proof Assistant: Introducing homotypy.io`,
          link: `http://math.andrej.com/2020/11/24/homotopy-io/`,
        },
        {
          title: `Every Proof Assistant: Introducing homotopy.io`,
          link: `http://math.andrej.com/2020/11/24/homotopy-io/`,
        },
      ],
    },
    goToNewsArchive: `Go to News Archive`,
  },
  weeklyNews: {
    ocamlWeeklyNews: `OCaml Weekly News`,
    overview: `For 20 years, Alan Schmitt has been collating messages sent to the OCaml Mailing List and summarising them into OCaml Weekly News. You can browse the archives of his work here and at `,
  },
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=952%3A422`
    playgroundLink=`/play/community/news`
  />
  <Page.HighlightItem
    title=content.title
    pageDescription=content.pageDescription
    highlightContent=content.highlightContent>
    <HighlightsInQuadrants
      t={CategorizedNews.toHighlightsInQuadrantsContent(content.categorizedNews)}
      marginBottom={Tailwind.ByBreakpoint.make(#mb10, ~lg=#mb32, ())}
    />
    <WeeklyNews marginBottom={Tailwind.ByBreakpoint.make(#mb4, ())} content=content.weeklyNews />
  </Page.HighlightItem>
</>

let default = make
