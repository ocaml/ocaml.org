// NOTE: This is a temporary page to display and test components until
//  we adopt StoryBook or a similar technology.

@react.component
let make = () => <>
  <div className="bg-green-100 py-4">
    <SectionContainer.VerySmallCentered>
      <StoryCard.CornerTitleLogo
        title="Mirage OS"
        graphicUrl="/static/ocaml-logo.jpeg"
        body="  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, quis mollis eros augue vel est. Pellentesque id turpis sit amet magna elementum ultricies a id mauris. Nulla ut faucibus dui. Curabitur sit amet consequat nulla."
      />
    </SectionContainer.VerySmallCentered>
  </div>
  <div className="bg-white py-4">
    <SectionContainer.SmallCentered>
      <StoryCard.CornerTitleLogo
        title="2012-2016"
        graphicUrl="/static/rackspacelogo.jpeg"
        body="Rackspace is a hosting provider that Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, etcetera."
        colored=true
        bordered=false
      />
    </SectionContainer.SmallCentered>
  </div>
  <div className="bg-green-100 py-4">
    <SectionContainer.SmallCentered>
      <StoryCard.CornerLogoCenterTitle
        title="Software Engineer at Tarides"
        graphicUrl="/static/trd.png"
        body="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, quis mollis eros augue vel est. Pellentesque id turpis sit amet magna elementum ultricies a id mauris. Nulla ut faucibus dui. Curabitur sit amet consequat nulla."
        buttonText="Learn More"
      />
    </SectionContainer.SmallCentered>
  </div>
  {
    let testCompaniesOptional =
      Belt.Array.range(1, 6)
      ->Belt.Array.map(i => {
        LogoCloud.CompanyOptionalLogo.logoSrc: if i == 2 {
          None
        } else {
          Some("/static/oclabs.png")
        },
        name: "OCaml Labs",
        website: "https://ocamllabs.io",
      })
      ->LogoCloud.LogoWithText
    let testCompanies =
      Belt.Array.range(1, 6)
      ->Belt.Array.map(_ => {
        LogoCloud.Company.logoSrc: "/static/oclabs.png",
        name: "OCaml Labs",
        website: "https://ocamllabs.io",
      })
      ->LogoCloud.LogoOnly

    <>
      <div className="bg-green-100 py-4"> <LogoCloud companies=testCompanies /> </div>
      <div className="bg-green-100 py-4"> <LogoCloud companies=testCompaniesOptional /> </div>
    </>
  }
  {
    let imageSrc = "/static/oc-sq.jpeg"
    let header = "A Header"
    let body = "Some body text here that should be in latin. Some more body text here and here. Text text text text text text text text text text text text text."
    let buttonLinks = {
      Hero.primaryButton: {
        label: "Main Action",
        url: "/en",
      },
      secondaryButton: {
        label: "Other Action",
        url: "/en",
      },
    }
    <>
      <hr className="bg-green-100 h-4" />
      <Hero imageSrc header body buttonLinks />
      <hr className="bg-green-100 h-4" />
      <hr className="bg-green-100 h-4" />
      <Hero imageSrc header body buttonLinks imageOnRight=false />
      <hr className="bg-green-100 h-4" />
    </>
  }
</>

let default = make
