type navContent = {
  industry: NavEntry.t,
  resources: NavEntry.t,
  community: NavEntry.t
}

let navContentEn = {
  industry: {label: `Industry`, url: `/play/industry`},
  resources: {label: `Resources`, url: `/play/resources`},
  community: {label: `Community`, url: `/play/community`}
}

let headerContentEn: HeaderNavigation.content = {
  industry: navContentEn.industry,
  resources: navContentEn.resources,
  community: navContentEn.community,
  search: `Search`,
  openMenu: `Open menu`
}

let footerContentEn: Footer.content = {
    footer: `Footer`,
    ocamlSummary: `Innovation. Community. Security.`,
    industry: navContentEn.industry,
    industrySections: {
      whatIsOcaml: {label: `What is OCaml`, url: `/play/industry/description`},
      industrialUsers: {label: `Industrial Users`, url: `/play/industry/users`},
      successStories: {label: `Success Stories`, url: `/play/industry/success`}
    },
    resources: navContentEn.resources,
    resourcesSections: {
      releases: {label: `Releases`, url: `/play/resource/releases`},
      applications: {label: `Applications`, url: `/play/resource/applications`},
      language: {label: `Language`, url: `/play/resource/language`},
      archive: {label: `Archive`, url: `/play/resource/archive`}
    },
    community: navContentEn.community,
    communitySections: {
      opportunities: {label: `Opportunities`, url: `/play/community/opportunities`},
      news: {label: `News`, url: `/play/community/news`},
      aroundTheWeb: {label: `Around the Web`, url: `/play/community/aroundweb`}
    },
    legal: `Legal`,
    legalSections: {
      privacy: {label: `Privacy`, url: `/play/privacypolicy`},
      terms: {label: `Terms`, url: `/play/terms`},
      claims: {label: `Claims`, url: `/play/legal`},
      cookies: {label: `Cookies`, url: `/play/cookiepolicy`}
    }
}

@react.component
let make = (~children /*, ~editpath */ ) =>
  <div className="bg-white"> { /* TODO: change element to body, move to document.res */  React.null }
    <div className="relative shadow">
      <HeaderNavigation content=headerContentEn />
    </div>
    <main className="relative bg-graylight">
      children
    </main>
    <div className="relative">
      <Footer content=footerContentEn />
    </div>
  </div>
