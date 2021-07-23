open! Import

let s = React.string

module T = {
  module Tutorials = {
    type t = {
      title: string,
      description: string,
      tutorials: array<Ood.Tutorial.t>,
    }

    @react.component
    let make = (~content, ~lang) => {
      let left =
        <div className="flex h-full flex-col items-center justify-center">
          <div className="py-8 sm:pl-12">
            <CallToAction.Embedded
              t={
                CallToAction.title: content.title,
                body: content.description,
                buttonLink: Route(#resourcesTutorials, lang),
                buttonText: "See All Tutorials",
              }
            />
          </div>
        </div>

      let right =
        <div className="flex h-full items-center justify-center">
          <ul className="list-disc pb-8 sm:pb-0 leading-10">
            {Array.mapi(
              (i, t: Ood.Tutorial.t) =>
                <li key={string_of_int(i)}>
                  <Route _to={#resourcesTutorial(t.slug)} lang>
                    <a className="text-orangedark text-xl underline"> {s(t.title)} </a>
                  </Route>
                </li>,
              content.tutorials,
            ) |> React.array}
          </ul>
        </div>
      <SplitCard.MediumCentered left right />
    }
  }

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

  // TODO: Better bindings for this
  type options = {inline: string, behaviour: string, block: string}
  @send external scrollIntoView: (Dom.element, options) => unit = "scrollIntoView"

  module Books = {
    type t = {
      booksLabel: string,
      books: array<Ood.Book.t>,
    }

    type direction = Left | Right

    @react.component
    let make = (~marginBottom=?, ~content) => {
      let (idx, setIdx) = React.useState(() => 0)
      let booksRef = React.useRef(Array.init(Array.length(content.books), _ => Js.Nullable.null))
      let setBookRef = (idx, element) => {
        booksRef.current[idx] = element
      }

      let handle_book_change = index => {
        Js.Nullable.iter(booksRef.current[index], (. el) =>
          scrollIntoView(el, {inline: "center", behaviour: "smooth", block: "center"})
        )
      }

      let handle_click = (dir, current) => {
        let new_idx = switch dir {
        | Left => current - 1
        | Right => current + 1
        }

        let length = Array.length(content.books)
        let new_idx = if new_idx < 0 {
          length + new_idx
        } else if new_idx >= length {
          new_idx - length
        } else {
          new_idx
        }
        handle_book_change(new_idx)
        new_idx
      }

      // TODO: define content type; extract content
      // TODO: use generic container
      <SectionContainer.LargeCentered paddingY="pt-16 pb-3 lg:pt-24 lg:pb-8">
        <div
          className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-5xl " ++
          Tailwind.MarginBottomByBreakpoint.toClassNamesOrEmpty(marginBottom)}>
          <div className="px-4 py-5 sm:px-6 sm:py-9">
            <h2 className="text-center text-orangedark text-5xl font-bold mb-8">
              {s(content.booksLabel)}
            </h2>
            <div className="grid grid-cols-8 items-center mb-8 px-6">
              // TODO: define state to track location within books list, activate navigation
              <div
                tabIndex={0}
                className="flex justify-start cursor-pointer"
                // TODO: Improve the navigation using a keyboard
                onKeyDown={e => {
                  if ReactEvent.Keyboard.keyCode(e) === 13 {
                    setIdx(prev => handle_click(Left, prev))
                  }
                }}
                onClick={_ => setIdx(prev => handle_click(Left, prev))}>
                // TODO: make navigation arrows accesssible
                <svg
                  className="h-20"
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
              <div className="col-span-6 py-2 flex m-w-full overflow-x-hidden">
                {Array.mapi((id, book: Ood.Book.t) => {
                  // TODO: Better default image
                  let cover = Belt.Option.getWithDefault(book.cover, "/static/logo1.jpeg")
                  <div
                    className="px-4 flex items-center justify-center"
                    key={string_of_int(id)}
                    ref={ReactDOM.Ref.callbackDomRef(dom => setBookRef(id, dom))}>
                    <div className="w-40 aspect-w-3 aspect-h-2 sm:aspect-w-3 sm:aspect-h-4">
                      <img
                        src=cover
                        alt=book.title
                        className={"object-fit w-full shadow-lg rounded-lg " ++ if id == idx {
                          "ring-4 ring-orangedarker"
                        } else {
                          ""
                        }}
                      />
                    </div>
                  </div>
                }, content.books) |> React.array}
              </div>
              <div
                tabIndex={0}
                className="flex justify-end cursor-pointer"
                onKeyDown={e => {
                  if ReactEvent.Keyboard.keyCode(e) === 13 {
                    setIdx(prev => handle_click(Right, prev))
                  }
                }}
                onClick={_ => setIdx(prev => handle_click(Right, prev))}>
                <svg
                  className="h-20"
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
            <div className="w-full px-10">
              {switch Belt.Array.get(content.books, idx) {
              | Some(book) => <>
                  <p className="mt-2 text-lg font-medium text-gray-900"> {s(book.title)} </p>
                  <p className="mt-2 text-md text-gray-900"> {s(book.description)} </p>
                  <p className=" text-sm font-medium text-gray-500">
                    {book.links
                    |> List.mapi((
                      _idx,
                      link: Ood.Book.link,
                    ) => // TODO: visual indicator that link opens new tab
                    <>
                      <a href=link.uri className="text-orangedarker" target="_blank">
                        <span> {s(link.description)} </span>
                      </a>
                      <span className="inline-block px-2"> {s("|")} </span>
                    </>)
                    |> Array.of_list
                    |> React.array}
                  </p>
                </>
              | None => <p> {s("Somethings gone wrong")} </p>
              }}
            </div>
          </div>
        </div>
      </SectionContainer.LargeCentered>
    }
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
    let make = (~marginBottom=?, ~lang) =>
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
              <Route _to={#resourcesApplications} lang>
                <a className="text-orangedark underline"> {s(`Go to Applications >`)} </a>
              </Route>
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
    let make = (~marginBottom=?, ~lang, ()) =>
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
            <Route _to={#resourcesPapers} lang>
              <a
                className="font-bold inline-flex items-center px-10 py-3 border border-transparent text-base leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker">
                {s(`Go to Papers`)}
              </a>
            </Route>
          </div>
        </div>
      </div>
  }

  type t = {
    title: string,
    pageDescription: string,
    tutorials: Tutorials.t,
    beginning: UserLevelIntroduction.t,
    growing: UserLevelIntroduction.t,
    booksContent: Books.t,
    expanding: UserLevelIntroduction.t,
    diversifying: UserLevelIntroduction.t,
    researching: UserLevelIntroduction.t,
  }
  include Jsonable.Unsafe

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: lang}) => <>
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
        <Tutorials content=content.tutorials lang />
        <Books marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())} content=content.booksContent />
        <UserLevelIntroduction content=content.expanding marginBottom=introMarginBottom />
        <Manual marginBottom={Tailwind.ByBreakpoint.make(#mb20, ())} />
        <UserLevelIntroduction content=content.diversifying marginBottom=introMarginBottom />
        <Applications marginBottom={Tailwind.ByBreakpoint.make(#mb36, ())} lang />
        <UserLevelIntroduction content=content.researching marginBottom=introMarginBottom />
        <Papers marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())} lang />
      </Page.Basic>
    }
  </>

  let contentEn = {
    let books = Ood.Book.all->Belt.List.toArray
    let tutorials = Belt.List.keepWithIndex(Ood.Tutorial.all, (_, i) => i < 4)->Belt.List.toArray
    // TODO: read book sorting and filtering information and adjust array
    {
      title: `Language`,
      pageDescription: `This is the home of learning and tutorials. Whether you're a beginner, a teacher, or a seasoned researcher, this is where you can find the resources you need to accomplish your goals in OCaml.`,
      tutorials: {
        title: `OCaml Tutorials`,
        description: `There are plenty of tutorials available for you to get started with OCaml, written by dedicated members of the community. Take a look and see what you can discover.`,
        tutorials: tutorials,
      },
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
