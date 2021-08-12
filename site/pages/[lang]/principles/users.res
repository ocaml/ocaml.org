open! Import

module T = {
  type t = {
    companies: LogoCloud.t,
    title: string,
    pageDescription: string,
    backgroundImage: TitleHeading.OverBackgroundImage.BackgroundImage.t,
  }
  include Jsonable.Unsafe
  module CallToAction = {
    @react.component
    let make = (~lang) => <>
      <div className="text-center">
        <Next.Link href={#PrinciplesSuccesses->Route.toString(lang)}>
          <a
            className="justify-center inline-flex items-center px-4 py-2 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-orangedark hover:bg-orangedarker focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orangedarker">
            {React.string("Success Stories")}
          </a>
        </Next.Link>
      </div>
    </>
  }

  module Params = Pages.Params.Lang

  @react.component
  let make = (~content, ~params as {Params.lang: lang}) => <>
    <ConstructionBanner
      figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=430%3A36400`
      playgroundLink=`/play/industry/users`
    />
    <Page.TitleOverBackgroundImage
      title=content.title
      backgroundImage=content.backgroundImage
      pageDescription=content.pageDescription>
      <CallToAction lang /> <LogoCloud companies=content.companies />
    </Page.TitleOverBackgroundImage>
  </>

  let contentEn = {
    let companyArray = Ood.Industrial_user.all->Belt.List.toArray

    let companies = companyArray->Belt.Array.map((c: Ood.Industrial_user.t) => {
      LogoCloud.CompanyOptionalLogo.logoSrc: c.Ood.Industrial_user.image,
      name: c.name,
      website: c.site,
    })

    {
      companies: #LogoWithText(companies),
      title: `Industrial Users of OCaml`,
      pageDescription: `With its strong security features and high performance, several companies rely on OCaml to keep their data operating both safely and efficiently. On this page, you can get an overview of the companies in the community and learn more about how they use OCaml.`,
      backgroundImage: {
        height: Tall,
        tailwindImageName: `bg-user-bg`,
      },
    }
  }

  let content = [({Params.lang: #en}, contentEn)]
}

include T
include Pages.MakeSimple(T)
