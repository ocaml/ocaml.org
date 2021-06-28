open! Import

module Link = Next.Link

let s = React.string

module T = {
  module ApiDocumentation = {
    @react.component
    let make = (~marginBottom=?) =>
      // TODO: factor out and define content type
      <SectionContainer.MediumCentered ?marginBottom paddingX="px-4 sm:px-32">
        <MediaObject imageHeight="h-56" image="api-img.jpeg" imageSide=MediaObject.Right>
          <h4 className="text-4xl font-bold mb-8"> {s(`API Documentation`)} </h4>
          <p className="mt-1 mb-8">
            {s(`Visit our page for API Documentation in OCaml for a concise reference manual with all the information you need to work with the OCaml API.`)}
          </p>
          //TODO: add visual indicator that link is opening new tab
          <a
            href="https://docs.mirage.io/"
            target="_blank"
            className="inline-flex items-center px-14 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker">
            {s(`Visit Docs.ocaml.org`)}
          </a>
        </MediaObject>
      </SectionContainer.MediumCentered>
  }

  module DeveloperGuide = {
    type t = {
      name: string,
      description: string,
      link: string,
      image: string,
    }

    let all = [
      {
        link: "https=//docs.mirage.io/mirage/index.html",
        name: "Mirage OS",
        description: "Mirage OS Unikernels lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac malesuada. Proin in odio ultricies, faucibus ligula ut",
        image: "app-image.png",
      },
      {
        link: "https=//b0-system.github.io/odig/doc/js_of_ocaml/Js_of_ocaml/index.html",
        name: "JS_of_OCaml",
        description: "Browser programming dolor sit amet, consectetur adipiscing elit. Integer at tristique odio. Etiam sodales porta lectus ac maleuada. Proin in odio ultricies, faucibus ligula ut",
        image: "jvs.png",
      },
    ]
  }

  module OcamlPoweredSoftware = {
    type t = {
      name: string,
      link: string,
      image: string,
      description: string,
    }

    let all = [
      {
        name: "Unison",
        link: "https://github.com/bcpierce00/unison/wiki/Downloading-Unison",
        image: "unison2.png",
        description: "Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.",
      },
      {
        name: "Coq",
        link: "https://coq.inria.fr/download",
        image: "coq.png",
        description: "Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.",
      },
      {
        name: "Liquid Soap",
        link: "https://www.liquidsoap.info/doc-1.4.4/install.html",
        image: "liq.png",
        description: "Dolor sit amet, consectetur adipiscing elit. Integer at tristique odio.",
      },
    ]
  }

  module DeveloperGuides = {
    type t = {
      developerGuidesLabel: string,
      topDeveloperGuide: DeveloperGuide.t,
      bottomDeveloperGuide: DeveloperGuide.t,
    }

    @react.component
    let make = (~marginBottom=?, ~content) =>
      <div
        className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-3xl " ++
        marginBottom->Tailwind.MarginBottomByBreakpoint.toClassNamesOrEmpty}>
        <div className="px-4 py-5 sm:p-6">
          // TODO: factor out and define content type
          <h2 className="text-center text-orangedark text-4xl font-bold mb-8">
            {s(content.developerGuidesLabel)}
          </h2>
          <MediaObject
            marginBottom={Tailwind.ByBreakpoint.make(#mb11, ())}
            imageHeight="h-32"
            image=content.topDeveloperGuide.image
            imageSide=MediaObject.Right>
            // <div className="flex mb-11">
            <div>
              <h4 className="text-base font-bold mb-3">
                // TODO: visual indicator that link is opening new tab
                <a className="hover:underline" href=content.topDeveloperGuide.link target="_blank">
                  {s(content.topDeveloperGuide.name)}
                </a>
              </h4>
              <p className="mt-1"> {s(content.topDeveloperGuide.description)} </p>
            </div>
          </MediaObject>
          <MediaObject
            marginBottom={Tailwind.ByBreakpoint.make(#mb11, ())}
            imageHeight="h-32"
            image=content.bottomDeveloperGuide.image
            imageSide=MediaObject.Left>
            <div>
              <h4 className="text-base font-bold mb-3">
                // TODO: visual indicator that link is opening new tab
                <a
                  className="hover:underline"
                  href=content.bottomDeveloperGuide.link
                  target="_blank">
                  {s(content.bottomDeveloperGuide.name)}
                </a>
              </h4>
              <p className="mt-1"> {s(content.bottomDeveloperGuide.description)} </p>
            </div>
          </MediaObject>
        </div>
      </div>
  }

  module UsingOcaml = {
    type t = {
      usingOcamlLabel: string,
      introduction: string,
      seeMore: string,
      softwareLeft: OcamlPoweredSoftware.t,
      softwareMiddle: OcamlPoweredSoftware.t,
      softwareRight: OcamlPoweredSoftware.t,
    }

    @react.component
    let make = (~marginBottom=?, ~content) =>
      // TODO: factor out and define content type
      <div
        className={"bg-white overflow-hidden shadow rounded-lg mx-auto max-w-3xl " ++
        marginBottom->Tailwind.MarginBottomByBreakpoint.toClassNamesOrEmpty}>
        <div className="px-4 py-5 sm:py-8 sm:px-24">
          <h2 className="text-center text-orangedark text-4xl font-bold mb-8">
            {s(content.usingOcamlLabel)}
          </h2>
          <p className="text-center mb-6"> {s(content.introduction)} </p>
          <div className="grid grid-cols-3 gap-x-16 mb-6">
            <div className="flex justify-center items-center mb-6">
              // TODO: visual indicator that link opens new tab
              <a href=content.softwareLeft.link target="_blank">
                <img
                  className={"border-1 h-32"}
                  src={"/static/" ++ content.softwareLeft.image}
                  alt=content.softwareLeft.name
                />
              </a>
            </div>
            <div className="flex justify-center items-center mb-6">
              <a href=content.softwareMiddle.link target="_blank">
                <img
                  className={"border-1 h-32"}
                  src={"/static/" ++ content.softwareMiddle.image}
                  alt=content.softwareMiddle.name
                />
              </a>
            </div>
            <div className="flex justify-center items-center mb-6">
              <a href=content.softwareRight.link target="_blank">
                <img
                  className={"border-1 h-32"}
                  src={"/static/" ++ content.softwareRight.image}
                  alt=content.softwareRight.name
                />
              </a>
            </div>
            <div>
              <p className="font-bold text-center mb-2"> {s(content.softwareLeft.name)} </p>
              <p> {s(content.softwareLeft.description)} </p>
            </div>
            <div>
              <p className="font-bold text-center mb-2"> {s(content.softwareMiddle.name)} </p>
              <p> {s(content.softwareMiddle.description)} </p>
            </div>
            <div>
              <p className="font-bold text-center mb-2"> {s(content.softwareRight.name)} </p>
              <p> {s(content.softwareRight.description)} </p>
            </div>
          </div>
          <p className="text-right font-bold">
            <Link href=InternalUrls.resourcesUsingocaml>
              // TODO: descriptive link text
              <a className="text-orangedark underline"> {s(content.seeMore ++ ` >`)} </a>
            </Link>
          </p>
        </div>
      </div>
  }

  type t = {
    title: string,
    pageDescription: string,
    developerGuidesContent: DeveloperGuides.t,
    usingOcamlContent: UsingOcaml.t,
  }
  include Jsonable.Unsafe

  @react.component
  let make = (~content) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=745%3A1`
      playgroundLink=`/play/resources/applications`
    />
    <Page.Basic
      marginTop=`mt-1`
      addBottomBar=true
      addContainer=Page.Basic.NoContainer
      title=content.title
      pageDescription=content.pageDescription>
      <ApiDocumentation marginBottom={Tailwind.ByBreakpoint.make(#mb24, ())} />
      <DeveloperGuides
        marginBottom={Tailwind.ByBreakpoint.make(#mb2, ())} content=content.developerGuidesContent
      />
      // TODO: factor out and define content type
      <CallToAction.TransparentWide
        t={
          CallToAction.title: "Platform Tools",
          body: `The OCaml Platform is a collection of tools that allow programmers to be productive in the OCaml language. It has been an iterative process of refinement as new tools are added and older tools are updated. Different tools accomplish different workflows and are used at different points of a project's life.`,
          buttonLink: Route(InternalUrls.resourcesPlatform),
          buttonText: `Visit Platform Tools`,
        }
      />
      <UsingOcaml
        marginBottom={Tailwind.ByBreakpoint.make(#mb16, ())} content=content.usingOcamlContent
      />
    </Page.Basic>
  </>

  let contentEn = {
    let developerGuides = DeveloperGuide.all
    let ocamlPoweredSoftare = OcamlPoweredSoftware.all
    // TODO: store ids of highlighted developer guides explicitly
    let title = `Applications`
    let pageDescription = `This is where you can find resources for working with the language itself. Whether you're building applications or maintaining libraries, this page has useful information for you.`
    let developerGuidesContent = {
      DeveloperGuides.developerGuidesLabel: "Developer Guides",
      topDeveloperGuide: developerGuides[0],
      bottomDeveloperGuide: developerGuides[1],
    }
    {
      title: title,
      pageDescription: pageDescription,
      developerGuidesContent: developerGuidesContent,
      usingOcamlContent: {
        usingOcamlLabel: `Using OCaml`,
        introduction: `Besides developing in the language and making your own applications, there are many useful tools that already exist in OCaml for you to use.`,
        seeMore: `See more`,
        // TODO: store ids of highlighted ocaml powered software explicitly
        softwareLeft: ocamlPoweredSoftare[0],
        softwareMiddle: ocamlPoweredSoftare[1],
        softwareRight: ocamlPoweredSoftare[2],
      },
    }
  }

  module Params = Pages.Params.Lang

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
