// TODO(tmattio): Remove fixtures with Ood content
module DeveloperGuide: {
  type t = {
    name: string,
    description: string,
    link: string,
    image: string,
  }
}

// TODO(tmattio): Remove fixtures with Ood content
module OcamlPoweredSoftware: {
  type t = {
    name: string,
    link: string,
    image: string,
    description: string,
  }
}

module DeveloperGuides: {
  type t = {
    developerGuidesLabel: string,
    topDeveloperGuide: DeveloperGuide.t,
    bottomDeveloperGuide: DeveloperGuide.t,
  }
}

module UsingOcaml: {
  type t = {
    usingOcamlLabel: string,
    introduction: string,
    seeMore: string,
    softwareLeft: OcamlPoweredSoftware.t,
    softwareMiddle: OcamlPoweredSoftware.t,
    softwareRight: OcamlPoweredSoftware.t,
  }
}

type prop = {
  title: string,
  pageDescription: string,
  developerGuidesContent: DeveloperGuides.t,
  usingOcamlContent: UsingOcaml.t,
}

@react.component
let make: (
  ~title: string,
  ~pageDescription: string,
  ~developerGuidesContent: DeveloperGuides.t,
  ~usingOcamlContent: UsingOcaml.t,
) => React.element

// TODO: is there a better approach then using "unit" below?
let getStaticProps: Next.GetStaticProps.t<prop, unit, unit>

let default: {
  "title": string,
  "pageDescription": string,
  "developerGuidesContent": DeveloperGuides.t,
  "usingOcamlContent": UsingOcaml.t,
} => React.element
