type navContent = {
  industry: string,
  resources: string,
  community: string
}

let navContentEn = {
  industry: `Industry`,
  resources: `Resources`,
  community: `Community`
}

let headerContentEn: HeaderNavigation.content = {
  industry: navContentEn.industry,
  resources: navContentEn.resources,
  community: navContentEn.community,
  search: `Search`,
  openMenu: `Open menu`
}

let footerContentEn: Footer.t = {
    footer: `Footer`,
    logoContent: {
      ocamlSummary: `Innovation. Community. Security.`
    },
    mainLinksContent : {
      industrySection: {
        header: navContentEn.industry,
        whatIsOcaml: {label: `What is OCaml`, url: `/industry/whatisocaml`},
        industrialUsers: {label: `Industrial Users`, url: `/industry/users`},
        successStories: {label: `Success Stories`, url: `/industry/successstories`}
      },
      resourcesSection: {
        header: navContentEn.resources,
        releases: {label: `Releases`, url: `/resources/releases`},
        applications: {label: `Applications`, url: `/resources/applications`},
        language: {label: `Language`, url: `/resources/language`},
        archive: {label: `Archive`, url: `/resources/archive`}
      },
      communitySection: {
        header: navContentEn.community,
        opportunities: {label: `Opportunities`, url: `/community/opportunities`},
        news: {label: `News`, url: `/community/news`},
        aroundTheWeb: {label: `Around the Web`, url: `/community/aroundweb`}
      },
      legalSection: {
        header: `Legal`,
        privacy: {label: `Privacy`, url: `/legal/privacy`},
        terms: {label: `Terms`, url: `/legal/terms`},
        carbonFootprint: {label: `Carbon Footprint`, url: `/legal/carbonfootprint`},
      }
    },
    sponsorContent: {
      thankSponsorPrefix: `Thank you to our`,
      hostingProviders: {label: `Hosting Providers`, url: `/legal/carbonfootprint#hostingproviders`}
    }
}

@react.component
let make = (~children) =>
  <div className="bg-white"> // TODO: change element to body, move to document.res 
    <div className="relative shadow">
      <HeaderNavigation content=headerContentEn />
    </div>
    <main className="relative bg-graylight pb-1"> // pb-1 is used to prevent margin-bottom from collapsing on last child
      children
    </main>
    <div className="relative">
      <Footer content=footerContentEn />
    </div>
  </div>
