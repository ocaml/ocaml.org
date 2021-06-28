open! Import

let s = React.string

module T = {
  module UserLevelIntroduction = {
    type t = {
      level: string,
      introduction: string,
    }

    @react.component
    let make = (~content, ~marginBottom=?, ()) =>
      <SectionContainer.SmallCentered ?marginBottom otherLayout="flex items-center space-x-20">
        <div className="text-5xl font-bold text-orangedark flex-shrink-0">
          {s(content.level ++ ` -`)}
        </div>
        <div className="font-bold text-xl"> {s(content.introduction)} </div>
      </SectionContainer.SmallCentered>
  }

  module Books = {
    type t = {
      booksLabel: string,
      books: array<Ood.Book.t>,
    }

    @react.component
    let make = (~marginBottom=?, ~content) =>
      // TODO: define content type; extract content
      // TODO: use generic container
      <div
        className={"bg-white overflow-hidden shadow rounded-lg mx-10 mx-auto max-w-5xl " ++
        Tailwind.MarginBottomByBreakpoint.toClassNamesOrEmpty(marginBottom)}>
        <div className="px-4 py-5 sm:px-6 sm:py-9">
          <h2 className="text-center text-orangedark text-7xl font-bold mb-8 uppercase">
            {s(content.booksLabel)}
          </h2>
          <div className="grid grid-cols-5 items-center mb-8 px-6">
            // TODO: define state to track location within books list, activate navigation
            <div className="flex justify-center">
              // TODO: make navigation arrows accesssible
              <svg
                className="h-24 center"
                viewBox="0 0 90 159"
                fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M2.84806 86.0991L72.1515 155.595C76.1863 159.39 82.3571 159.39 86.1546 155.595C89.952 151.8 89.952 145.396 86.1546 141.601L23.734 79.2206L86.1546 16.8403C89.952 12.8081 89.952 6.64125 86.1546 2.84625C82.3571 -0.94875 76.1863 -0.94875 72.1515 2.84625L2.84806 72.105C-0.949387 76.1372 -0.949387 82.3041 2.84806 86.0991Z"
                  fill="#ED7109"
                />
              </svg>
            </div>
            {content.books
            |> Js.Array.mapi((book: Ood.Book.t, idx) => {
              let cover = Belt.Option.getWithDefault(book.cover, "")

              <div className="flex justify-center" key={Js.Int.toString(idx)}>
                <img className="h-36 w-28" src={cover} alt={book.title} />
                {book.links
                |> List.mapi((_idx, link: Ood.Book.link) =>
                  // TODO: visual indicator that link opens new tab
                  <a href=link.uri target="_blank"> <span> {s(link.description)} </span> </a>
                )
                |> Array.of_list
                |> React.array}
              </div>
            })
            |> React.array}
            <div className="flex justify-center">
              <svg
                className="h-24"
                viewBox="0 0 90 159"
                fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M86.1546 72.3423L16.8512 2.84625C12.8164 -0.948746 6.64553 -0.948746 2.84809 2.84625C-0.949362 6.64127 -0.949362 13.0453 2.84809 16.8403L65.2686 79.2207L2.84809 141.601C-0.949362 145.633 -0.949362 151.8 2.84809 155.595C6.64553 159.39 12.8164 159.39 16.8512 155.595L86.1546 86.3363C89.952 82.3041 89.952 76.1373 86.1546 72.3423Z"
                  fill="#ED7109"
                />
              </svg>
            </div>
          </div>
        </div>
      </div>
  }

  module Manual = {
    @react.component
    let make = (~marginBottom=?) =>
      // TODO: define content type; factor out content
      <SectionContainer.MediumCentered ?marginBottom paddingY="pt-8 pb-14" filled=true>
        <h2 className="text-center text-white text-7xl font-bold mb-8">
          {s(`The OCaml Manual`)}
        </h2>
        <div className="mx-24 grid grid-cols-3 px-28 mx-auto max-w-4xl">
          <div className="border-r-4 border-b-4">
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/manual/index.html#sec6">
                  {s(`Introduction Tutorials`)}
                </a>
              </p>
            </div>
          </div>
          <div className="border-r-4 border-b-4">
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/manual/stdlib.html"> {s(`StdLib`)} </a>
              </p>
            </div>
          </div>
          <div className="border-b-4">
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/api/index.html"> {s(`API Docs`)} </a>
              </p>
            </div>
          </div>
          <div className="border-r-4">
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/manual/index.html#sec72"> {s(`Lang`)} </a>
              </p>
            </div>
          </div>
          <div className="border-r-4">
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/manual/extn.html#sec238"> {s(`Ext`)} </a>
              </p>
            </div>
          </div>
          <div>
            <div
              className="h-24 flex items-center justify-center px-4 font-bold bg-white mx-8 my-3 rounded">
              <p className="text-center">
                <a href="https://ocaml.org/manual"> {s(`Something Else`)} </a>
              </p>
            </div>
          </div>
        </div>
      </SectionContainer.MediumCentered>
  }

  module Applications = {
    @react.component
    let make = (~marginBottom=?) =>
      <SectionContainer.VerySmallCentered ?marginBottom>
        <h2 className="text-center text-orangedark text-7xl font-bold mb-8">
          {s(`Applications`)}
        </h2>
        <div className="sm:flex items-center space-x-32 mb-20">
          <div className="mb-4 sm:mb-0 sm:mr-4">
            <p className="mt-1 mb-4 text-lg">
              {s(`Looking to learn more about the ways in which OCaml is used in real-world applications? Visit our Applications page to find out about different ways of using OCaml.`)}
            </p>
            <p className="text-right">
              <a href=InternalUrls.resourcesApplications className="text-orangedark underline">
                {s(`Go to Applications >`)}
              </a>
            </p>
          </div>
          <div className="flex-shrink-0">
            <img className="h-48" src="/static/app-image2.png" />
          </div>
        </div>
      </SectionContainer.VerySmallCentered>
  }

  module Papers = {
    @react.component
    let make = (~marginBottom=?, ()) =>
      // TODO: define content type and factor out content
      // TODO: use generic container
      <div
        className={"bg-white overflow-hidden shadow rounded-lg py-3 mx-auto max-w-5xl " ++
        marginBottom->Tailwind.MarginBottomByBreakpoint.toClassNamesOrEmpty}>
        <div className="px-4 py-5 sm:p-6">
          <h2 className="text-center text-orangedark text-7xl font-bold mb-8"> {s(`PAPERS`)} </h2>
          <div className="grid grid-cols-3 mb-14 px-9 space-x-6 px-14">
            <div className="">
              <p className="text-orangedark text-7xl font-bold"> {s(`1.`)} </p>
              // TODO: visual indicator that link will open new tab
              <p className="font-bold">
                <a href="https://arxiv.org/abs/1905.06543" target="_blank">
                  {s(`Extending OCaml's Open`)}
                </a>
              </p>
              <p> {s(`by Runhang Li, Jeremey Yallop`)} </p>
            </div>
            <div className="">
              <p className="text-orangedark text-7xl font-bold"> {s(`2.`)} </p>
              <p className="font-bold">
                <a href="https://kcsrk.info/papers/memory_model_ocaml17.pdf" target="_blank">
                  {s(`A Memory Model for Multicore OCaml`)}
                </a>
              </p>
              <p> {s(`by Stephen Dolan, KC Sivaramakrishnan`)} </p>
            </div>
            <div className="">
              <p className="text-orangedark text-7xl font-bold"> {s(`3.`)} </p>
              <p className="font-bold">
                <a href="https://arxiv.org/abs/1812.11664" target="_blank">
                  {s(`Eff Directly in OCaml`)}
                </a>
              </p>
              <p> {s(`by Oleg Kiselyov, KC Sivaramakrishnan`)} </p>
            </div>
          </div>
          <div className="flex justify-center">
            <a
              href=InternalUrls.resourcesPapers
              className="font-bold inline-flex items-center px-10 py-3 border border-transparent text-base leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker">
              {s(`Go to Papers`)}
            </a>
          </div>
        </div>
      </div>
  }

  type t = {
    title: string,
    pageDescription: string,
    beginning: UserLevelIntroduction.t,
    growing: UserLevelIntroduction.t,
    booksContent: Books.t,
    expanding: UserLevelIntroduction.t,
    diversifying: UserLevelIntroduction.t,
    researching: UserLevelIntroduction.t,
  }
  include Jsonable.Unsafe

  @react.component
  let make = (~content) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1085%3A121`
      playgroundLink=`/play/resources/language`
    />
    // TODO: define a more narrow page type with preset params

    {
      let introMarginBottom = Tailwind.ByBreakpoint.make(#mb20, ())
      <Page.Basic
        marginTop=`mt-1`
        addBottomBar=true
        addContainer=Page.Basic.NoContainer
        title=content.title
        pageDescription=content.pageDescription>
        <UserLevelIntroduction content=content.beginning marginBottom=introMarginBottom />
        <UserLevelIntroduction content=content.growing marginBottom=introMarginBottom />
        <Books marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())} content=content.booksContent />
        <UserLevelIntroduction content=content.expanding marginBottom=introMarginBottom />
        <Manual marginBottom={Tailwind.ByBreakpoint.make(#mb20, ())} />
        <UserLevelIntroduction content=content.diversifying marginBottom=introMarginBottom />
        <Applications marginBottom={Tailwind.ByBreakpoint.make(#mb36, ())} />
        <UserLevelIntroduction content=content.researching marginBottom=introMarginBottom />
        <Papers marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())} />
      </Page.Basic>
    }
  </>

  module Params = Pages.Params.Lang

  let contentEn = {
    let books = Ood.Book.all->Belt.List.toArray
    // TODO: read book sorting and filtering information and adjust array
    {
      title: `Language`,
      pageDescription: `This is the home of learning and tutorials. Whether you're a beginner, a teacher, or a seasoned researcher, this is where you can find the resources you need to accomplish your goals in OCaml.`,
      beginning: {
        level: `Beginning`,
        introduction: `Are you a beginner? Or just someone who wants to brush up on the fundamentals? In either case, the OFronds tutorial system has you covered!`,
      },
      growing: {
        level: `Growing`,
        introduction: `Familiar with the basics and looking to get a more robust understanding of OCaml? Or just curious? Check out the books available on OCaml:`,
      },
      booksContent: {
        booksLabel: "Books",
        books: books,
      },
      expanding: {
        level: `Expanding`,
        introduction: `Have a strong foundation in OCaml? Time to get involved! Prepare by getting familiar with the OCaml Manual:`,
      },
      diversifying: {
        level: `Diversifying`,
        introduction: `Now that you're familiar with the building blocks of OCaml, you may want to diversify your portfolio and have a look at the many applications that operate using OCaml.`,
      },
      researching: {
        level: `Researching`,
        introduction: `Aspiring towards greater understanding of the language? Want to push the limits and discover brand new things? Check out papers written by leading OCaml researchers:`,
      },
    }
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
