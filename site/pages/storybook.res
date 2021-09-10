// NOTE: This is a temporary page to display and test components until
//  we adopt StoryBook or a similar technology.

let defaultDoc = "This is the default (and only) way to use this element."

module Item = {
  @react.component
  let make = (~name: string, ~docs: string, ~children: array<(string, React.element)>) => {
    let docsElement = React.string(docs)

    let rec colors = list{#red, #blue, #green, #yellow, ...colors}
    let children = colors->Belt.List.zip(children->Belt.List.fromArray)->Belt.List.toArray
    let colorClass = x =>
      switch x {
      | #red => "bg-red-100"
      | #blue => "bg-blue-100"
      | #green => "bg-green-100"
      | #yellow => "bg-yellow-100"
      }
    <div
      className="bg-white mb-8 p-12 shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <h2 className="font-black text-4xl"> {React.string(`<${name} />`)} </h2>
      <div className="mb-4 mt-8"> {docsElement} </div>
      {React.array(
        children->Belt.Array.map(((color, (doc, child))) => {
          <div
            className={`shadow overflow-hidden border-b border-gray-200 sm:rounded-lg ${colorClass(
                color,
              )} p-8 mb-8`}>
            <div className="mb-2"> {React.string(doc)} </div> <hr /> {child}
          </div>
        }),
      )}
    </div>
  }
}

module Category = {
  @react.component
  let make = (~name, ~children) => {
    <SectionContainer.FullyResponsiveCentered>
      <Card title=name kind={#Transparent}> {children} </Card> <hr />
    </SectionContainer.FullyResponsiveCentered>
  }
}

module Categories = {
  module BasicComponents = {
    @react.component
    let make = () =>
      <Category name="Basic Components">
        <Item
          name="StoryCard.CornerTitleLogo"
          docs="A Corner Title Logo has a title on a corner, a logo on the opposite corner, as well as a child element which contains the body of the component.">
          {[
            (
              "This is the default look of this component. It has an opaque background.",
              <StoryCard.CornerTitleLogo
                title="Mirage OS"
                graphicUrl="/static/ocaml-logo.jpeg"
                body="  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, quis mollis eros augue vel est. Pellentesque id turpis sit amet magna elementum ultricies a id mauris. Nulla ut faucibus dui. Curabitur sit amet consequat nulla."
              />,
            ),
            (
              "This component has colored=false, and bordered=false.",
              <StoryCard.CornerTitleLogo
                title="2012-2016"
                graphicUrl="/static/rackspacelogo.jpeg"
                body="Rackspace is a hosting provider that Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, etcetera."
                colored=false
                bordered=false
              />,
            ),
            (
              "This component has colored=false, and bordered=true.",
              <StoryCard.CornerTitleLogo
                title="2012-2016"
                graphicUrl="/static/rackspacelogo.jpeg"
                body="Rackspace is a hosting provider that Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, etcetera."
                colored=false
                bordered=true
              />,
            ),
            (
              "This component has colored=true, and bordered=false.",
              <StoryCard.CornerTitleLogo
                title="2012-2016"
                graphicUrl="/static/rackspacelogo.jpeg"
                body="Rackspace is a hosting provider that Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, etcetera."
                colored=true
                bordered=false
              />,
            ),
            (
              "This component has colored=true, and bordered=true.",
              <StoryCard.CornerTitleLogo
                title="2012-2016"
                graphicUrl="/static/rackspacelogo.jpeg"
                body="Rackspace is a hosting provider that Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, etcetera."
                colored=true
                bordered=true
              />,
            ),
          ]}
        </Item>
        <Item
          name="StoryCard.CornerLogoCenterTitle"
          docs="This component has a logo on the corner, and a title in the center. The body of the component is passed in as a child.">
          {[
            (
              defaultDoc,
              <StoryCard.CornerLogoCenterTitle
                title="Software Engineer at Tarides"
                graphicUrl="/static/trd.png"
                body="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque placerat arcu, non tempor nisi ultrices at. Aenean facilisis eleifend velit quis consequat. Sed turpis elit, ultrices et tincidunt nec, gravida et massa. Maecenas hendrerit, ante et imperdiet semper, lorem purus condimentum neque, quis mollis eros augue vel est. Pellentesque id turpis sit amet magna elementum ultricies a id mauris. Nulla ut faucibus dui. Curabitur sit amet consequat nulla."
                buttonText="Learn More"
              />,
            ),
          ]}
        </Item>
        <Item
          name="ShortWideCard"
          docs="A short wide card has a logo, a title, and a URL arranged in a horizontal layout. The entire component can be clicked, and the user will be directed to the URL.">
          {[
            (
              defaultDoc,
              {
                let name = "Github.com"
                let logoSrc = "/static/github.png"
                let url = "https://github.com/ocaml/ocaml"
                <ShortWideCard name url logoSrc />
              },
            ),
          ]}
        </Item>
        <Item
          name="CallToAction.Embedded"
          docs="Contains a title, body, and a link.  This variation can be easily embedded within other components, as it has very minimal styling.">
          {[
            (
              defaultDoc,
              {
                let t = {
                  CallToAction.title: "Title",
                  body: "Body",
                  buttonLink: #External("example.com"),
                  buttonText: "Go to example.com",
                }
                <CallToAction.Embedded t />
              },
            ),
          ]}
        </Item>
        <Item name="CallToAction.Simple" docs="Contains a label and a url.">
          {[
            (
              defaultDoc,
              {
                let t = {
                  CallToAction.Simple.label: "Label",
                  url: "example.com",
                }
                <CallToAction.Simple t />
              },
            ),
          ]}
        </Item>
        <Item
          name="StackedList.BasicWithIcon"
          docs="Arranges items into a vertical list.  Each item is very similar to a Short Wide card, and contains a value, an icon, and a link which can be clicked.">
          {[
            (
              defaultDoc,
              {
                let items = [
                  {
                    StackedList.BasicWithIcon.Item.link: "example.com",
                    title: "Title1",
                  },
                  {
                    link: "example.com",
                    title: "Title2",
                  },
                ]
                let rowPrefixIcon = StackedList.BasicWithIcon.RowPrefixIcon.PaperScroll
                <StackedList.BasicWithIcon items rowPrefixIcon />
              },
            ),
          ]}
        </Item>
        <Item
          name="StackedList.BasicWithAuxiliaryAttribute"
          docs="A list component where each field can also contain an auxiliary attribute which can be used to provide things such as extra information, hints, or instructions.">
          {[
            (
              defaultDoc,
              {
                let items = [
                  {
                    StackedList.BasicWithAuxiliaryAttribute.Item.link: "example.com",
                    title: "Title1",
                    auxiliaryAttribute: "AuxiliaryAttribute1",
                  },
                  {
                    link: "example.com",
                    title: "Title2",
                    auxiliaryAttribute: "AuxiliaryAttribute2",
                  },
                ]
                <StackedList.BasicWithAuxiliaryAttribute items />
              },
            ),
          ]}
        </Item>
      </Category>
  }

  module PageTitles = {
    @react.component
    let make = () =>
      <Category name="Page Titles">
        <Item name="TitleHeading.Large" docs="An example TitleHeading.Large">
          {[
            (
              "This is the default look of this component.",
              {
                <TitleHeading.Large title="Title" />
              },
            ),
            (
              "TitleHeading.Large with a call to action.",
              {
                <TitleHeading.Large
                  title="Title"
                  callToAction={
                    CallToAction.Simple.label: "callToAction Label",
                    url: "",
                  }
                />
              },
            ),
            (
              "TitleHeading.Large with a call to action and bottom bar.",
              {
                <TitleHeading.Large
                  title="Title"
                  callToAction={
                    CallToAction.Simple.label: "callToAction Label",
                    url: "",
                  }
                  addBottomBar=true
                />
              },
            ),
          ]}
        </Item>
        <Item
          name="TitleHeading.OverBackgroundImage"
          docs="An example TitleHeading.OverBackgroundImage">
          {[
            (
              "This is the default look of this component.",
              {
                <TitleHeading.OverBackgroundImage
                  title="Title"
                  backgroundImage={
                    TitleHeading.OverBackgroundImage.BackgroundImage.tailwindImageName: "bg-user-bg",
                    height: Tall,
                  }
                  pageDescription="pageDescription"
                />
              },
            ),
          ]}
        </Item>
        <Item name="TitleHeading.MarkdownMedium" docs="An example TitleHeading.MarkdownMedium">
          {[
            (
              "This is the default look of this component.",
              {
                <TitleHeading.MarkdownMedium
                  title="Title" pageDescription={Some("Page Description")}
                />
              },
            ),
          ]}
        </Item>
      </Category>
  }

  module Sections = {
    module MediaObject = {
      module Small = {
        @react.component
        let make = () => {
          <Item name="MediaObject.Small" docs="Same as a MediaObject, but smaller.">
            {[
              (
                defaultDoc,
                <MediaObject.Small
                  header={"Header"}
                  body={"Body"}
                  link="example.org"
                  linkText={"Example" ++ ` >`}
                  image="/static/opam.png"
                />,
              ),
            ]}
          </Item>
        }
      }

      @react.component
      let make = () => {
        let inner = {
          <>
            <div className="bg-white border border-gray-300 overflow-hidden rounded-md mb-2">
              <ul className="divide-y divide-gray-300">
                {<StackedList.BasicWithIcon
                  items={[{link: "example.com", title: "Example"}]}
                  rowPrefixIcon=StackedList.BasicWithIcon.RowPrefixIcon.PaperScroll
                />}
              </ul>
            </div>
            <p className="text-xs text-right">
              <a className="text-orangedark hover:text-orangedark" href="/community/newsarchive">
                {React.string(`Go to the example link >`)}
              </a>
            </p>
          </>
        }

        <Item
          name="MediaObject"
          docs="A MediaObject has an image as its centerpiece. In addition, it accepts a child element which will be rendered alongside the image. Some image attributes can be modified, such as whether it is rounded, or whether it should be rendered on the left or the right.">
          {[
            (
              "A media object with non-rounded image.",
              <MediaObject
                imageHeight="h-28 sm:h-64"
                imageWidth="w-28 sm:w-64"
                isRounded=false
                image="typewriter.jpeg"
                imageSide=#Left>
                {inner}
              </MediaObject>,
            ),
            (
              "A media object with a rounded image.",
              <MediaObject
                imageHeight="h-28 sm:h-64"
                imageWidth="w-28 sm:w-64"
                isRounded=true
                image="typewriter.jpeg"
                imageSide=#Left>
                {inner}
              </MediaObject>,
            ),
            (
              "A media object with an image on the right.",
              <MediaObject
                imageHeight="h-28 sm:h-64"
                imageWidth="w-28 sm:w-64"
                isRounded=true
                image="typewriter.jpeg"
                imageSide=#Right>
                {inner}
              </MediaObject>,
            ),
            (
              "A media object without a specific height.",
              <MediaObject
                imageHeight="h-28 sm:h-64" isRounded=true image="typewriter.jpeg" imageSide=#Right>
                {inner}
              </MediaObject>,
            ),
            (
              "A media object without a child element.",
              <MediaObject
                imageHeight="h-28 sm:h-64" isRounded=false image="typewriter.jpeg" imageSide=#Right>
                {React.null}
              </MediaObject>,
            ),
          ]}
        </Item>
      }
    }

    module LogoCloud = {
      @react.component
      let make = () => {
        <Item
          name="LogoCloud"
          docs="A simple way of displaying images in a grid layout with and without text labels.">
          {[
            (
              "A logo cloud with only icons.",
              {
                let testCompanies =
                  Belt.Array.range(1, 6)
                  ->Belt.Array.map(_ => {
                    LogoCloud.Company.logoSrc: "/static/oclabs.png",
                    name: "OCaml Labs",
                    website: "https://ocamllabs.io",
                  })
                  ->#LogoOnly
                <LogoCloud companies=testCompanies />
              },
            ),
            (
              "A logo cloud with icons and an optional title.",
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
                  ->#LogoWithText
                <LogoCloud companies=testCompaniesOptional />
              },
            ),
          ]}
        </Item>
      }
    }

    module Hero = {
      @react.component
      let make = () => {
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
        <Item
          name="Hero"
          docs="A large component that can be used an the main introductory element of a page. It contains an image, a title, some text, and some buttons.">
          {[
            ("imagePos=#Right", <Hero imageSrc imagePos={#Right} header body buttonLinks />),
            ("imagePos=#Left", <Hero imageSrc imagePos={#Left} header body buttonLinks />),
          ]}
        </Item>
      }
    }

    module HighlightsInQuadrants = {
      @react.component
      let make = () => {
        let category = icon => {
          HighlightsInQuadrants.Category.header: {
            HighlightsInQuadrants.CategoryHeader.title: "CategoryHeader",
            icon: icon,
          },
          stories: [
            {HighlightsInQuadrants.Story.title: "Story1", link: "link"},
            {HighlightsInQuadrants.Story.title: "Story2", link: "link"},
          ],
          seeAllInCategory: {
            HighlightsInQuadrants.LabelledLink.label: "seeAllInCategory",
            link: "seeAllInCategory",
          },
        }

        let t = {
          HighlightsInQuadrants.title: "Example",
          topLeftCategory: category(#Profit),
          topRightCategory: category(#Calendar),
          bottomLeftCategory: category(#Meet),
          bottomRightCategory: category(#Package),
          goToArchive: {
            HighlightsInQuadrants.LabelledLink.label: "Example Link",
            link: "link",
          },
        }

        <Item name="HighlightsInQuadrants" docs="A component which a">
          {[("Default", <HighlightsInQuadrants t />)]}
        </Item>
      }
    }

    module CallToAction = {
      module General = {
        @react.component
        let make = () => {
          <Item
            name="CallToAction.General"
            docs="Same as CallToAction.Embedded.  This variation allows you to set a colorStyle.">
            {
              let t = {
                CallToAction.title: "Title",
                body: "Body",
                buttonLink: #External("example.com"),
                buttonText: "Go to example.com",
              }
              [
                (
                  "Transparent color style.",
                  {
                    <CallToAction.General t colorStyle={#Transparent} />
                  },
                ),
                (
                  "BackgroundFilled color style.",
                  {
                    <CallToAction.General t colorStyle={#BackgroundFilled} />
                  },
                ),
                (
                  "BackgroundFilled color style.",
                  {
                    <CallToAction.General t colorStyle={#BackgroundFilled} />
                  },
                ),
              ]
            }
          </Item>
        }
      }

      module TransparentWide = {
        @react.component
        let make = () =>
          <Item
            name="CallToAction.TransparentWide"
            docs="Transparent wide version of a call to action.">
            {
              let t = {
                CallToAction.title: "Title",
                body: "Body",
                buttonLink: #External("example.com"),
                buttonText: "Go to example.com",
              }
              [
                (
                  defaultDoc,
                  {
                    <CallToAction.TransparentWide t />
                  },
                ),
              ]
            }
          </Item>
      }
    }

    module Table = {
      module Simple = {
        @react.component
        let make = () => {
          <Item
            name="Table.Simple"
            docs="A component for rendering tabular data with optional headers.">
            {[
              (
                "Table.Simple with no data at all.",
                {
                  <Table.Simple
                    content={{
                      headers: [],
                      data: [],
                    }}
                  />
                },
              ),
              (
                "Table.Simple with no headers.",
                {
                  <Table.Simple
                    content={{
                      headers: [],
                      data: [["a", "b", "c"]->Belt.Array.map(React.string)],
                    }}
                  />
                },
              ),
              (
                "Table.Simple with only headers.",
                {
                  <Table.Simple
                    content={{
                      headers: ["a", "b", "c"],
                      data: [],
                    }}
                  />
                },
              ),
              (
                "Table.Simple with empty rows.",
                {
                  <Table.Simple
                    content={{
                      headers: ["a", "b", "c"],
                      data: [[], [], []],
                    }}
                  />
                },
              ),
              (
                "Table.Simple with uneven data.",
                {
                  <Table.Simple
                    content={{
                      headers: ["a", "b", "c"],
                      data: [
                        ["a0", "b0", "c0"],
                        ["a1"],
                        ["a2", "b2", "c2", "d2"],
                      ]->Belt.Array.map(arr => arr->Belt.Array.map(React.string)),
                    }}
                  />
                },
              ),
              (
                "Table.Simple with correctly formatted data.",
                {
                  <Table.Simple
                    content={{
                      headers: ["a", "b", "c"],
                      data: [
                        ["a0", "b0", "c0"],
                        ["a1", "b1", "c1"],
                        ["a2", "b2", "c2"],
                      ]->Belt.Array.map(arr => arr->Belt.Array.map(React.string)),
                    }}
                  />
                },
              ),
              (
                "Table.Simple with nested tables.",
                {
                  let cell =
                    <Table.Simple
                      content={{
                        headers: ["a", "b", "c"],
                        data: [
                          ["a0", "b0", "c0"],
                          ["a1", "b1", "c1"],
                          ["a2", "b2", "c2"],
                        ]->Belt.Array.map(arr => arr->Belt.Array.map(React.string)),
                      }}
                    />
                  <Table.Simple
                    content={{
                      headers: ["a", "b", "c"],
                      data: [[cell, cell, cell], [cell, cell, cell], [cell, cell, cell]],
                    }}
                  />
                },
              ),
            ]}
          </Item>
        }
      }

      module Regular = {
        type exampleMap = {
          foo: int,
          bar: string,
        }

        let rows = [{foo: 42, bar: "hello"}, {foo: 1337, bar: "world"}]

        @react.component
        let make = () => {
          <Item name="Table.Regular" docs="A component for rendering generic data in as a table.">
            {[
              (
                "Table.Regular with no data at all.",
                {
                  <Table.Regular rows=[]> [] </Table.Regular>
                },
              ),
              (
                "Table.Regular with rows, but no columns specs.",
                {
                  <Table.Regular rows> [] </Table.Regular>
                },
              ),
              (
                "Table.Regular with rows, with one column spec.",
                {
                  <Table.Regular rows>
                    [
                      {
                        Table.Regular.title: "foo",
                        component: (map: exampleMap) => {
                          React.string(string_of_int(map.foo))
                        },
                        className: "p-3",
                      },
                    ]
                  </Table.Regular>
                },
              ),
              (
                "Table.Regular with rows, with two column specs.",
                {
                  <Table.Regular rows>
                    [
                      {
                        Table.Regular.title: "foo",
                        component: (map: exampleMap) => {
                          React.string(string_of_int(map.foo))
                        },
                        className: "p-3",
                      },
                      {
                        Table.Regular.title: "bar",
                        component: (map: exampleMap) => {
                          React.string(map.bar)
                        },
                        className: "text-ocamlorange font-black",
                      },
                    ]
                  </Table.Regular>
                },
              ),
            ]}
          </Item>
        }
      }
    }

    module Stats = {
      @react.component
      let make = () => {
        <Item name="Stats" docs="<TODO>">
          {[
            (
              "Stats with no data at all.",
              {
                <Stats title="No Data"> [] </Stats>
              },
            ),
            (
              "Stats with 1 entry.",
              {
                <Stats title="Foobar">
                  [
                    {
                      Stats.Item.value: "42",
                      label: "foo",
                    },
                  ]
                </Stats>
              },
            ),
            (
              "Stats with 2 entries.",
              {
                <Stats title="Foobar">
                  [
                    {
                      Stats.Item.value: "42",
                      label: "foo",
                    },
                    {
                      Stats.Item.value: "1337",
                      label: "bar",
                    },
                  ]
                </Stats>
              },
            ),
            (
              "Stats with 3 entries.",
              {
                <Stats title="Foobar">
                  [
                    {
                      Stats.Item.value: "42",
                      label: "foo",
                    },
                    {
                      Stats.Item.value: "1337",
                      label: "bar",
                    },
                    {
                      Stats.Item.value: "3.14",
                      label: "baz",
                    },
                  ]
                </Stats>
              },
            ),
            (
              "Stats with 4 entries.",
              {
                <Stats title="Foobar">
                  [
                    {
                      Stats.Item.value: "42",
                      label: "foo",
                    },
                    {
                      Stats.Item.value: "1337",
                      label: "bar",
                    },
                    {
                      Stats.Item.value: "3.14",
                      label: "baz",
                    },
                    {
                      Stats.Item.value: "11",
                      label: "quux",
                    },
                  ]
                </Stats>
              },
            ),
          ]}
        </Item>
      }
    }

    module MarkdownPage = {
      module Body = {
        @react.component
        let make = () => {
          <Item name="MarkdownPage.Body" docs="This element renders HTML.">
            {[
              (
                "A string with HTML and Markdown, to see which gets rendered.",
                {
                  let source = `
                  <p> <b> HTML </b> </p>

                  *Markdown*`
                  <div className=`mt-6`> <MarkdownPage.Body renderedMarkdown=source /> </div>
                },
              ),
            ]}
          </Item>
        }
      }
    }

    module Testimonials = {
      @react.component
      let make = () => {
        <Item name="Testimonials" docs="This is a testimonials element.">
          {[
            (
              "A typewriter telling us OCaml is cool.",
              {
                <Testimonials
                  content={
                    Testimonials.quote: "OCaml is pretty cool.",
                    organizationName: "Acme Inc.",
                    speaker: "A Typewriter",
                    organizationLogo: "/static/typewriter.jpeg",
                  }
                />
              },
            ),
            (
              "Opam agreeing that OCaml is cool.",
              {
                <Testimonials
                  content={
                    Testimonials.quote: "The typewriter above me is telling the truth.",
                    organizationName: "Foobar Inc.",
                    speaker: "Opam",
                    organizationLogo: "/static/opam.png",
                  }
                />
              },
            ),
          ]}
        </Item>
      }
    }

    module Timeline = {
      @react.component
      let make = () => {
        let data = n => {
          let rec data = list{{Timeline.Item.date: "Date", description: "Description"}, ...data}
          data->Belt.List.take(n)->Belt.Option.getExn->Belt.List.toArray
        }
        <Item name="Timeline" docs="This is a timeline element.">
          {[
            (
              "A timeline with no data.",
              {
                <Timeline content={data(0)} />
              },
            ),
            (
              "A timeline with 1 entry.",
              {
                <Timeline content={data(1)} />
              },
            ),
            (
              "A timeline with 5 entries.",
              {
                <Timeline content={data(5)} />
              },
            ),
          ]}
        </Item>
      }
    }

    module UserLevelIntroduction = {
      @react.component
      let make = () => {
        <Item name="UserLevelIntroduction" docs="UserLevelIntroduction element.">
          {[
            (
              "Example 1",
              {
                <UserLevelIntroduction
                  content={
                    UserLevelIntroduction.level: "Level 1",
                    introduction: "Introduction",
                  }
                />
              },
            ),
            (
              "Example 2",
              {
                <UserLevelIntroduction
                  content={
                    UserLevelIntroduction.level: "Level 2",
                    introduction: "Introduction",
                  }
                />
              },
            ),
          ]}
        </Item>
      }
    }

    module MediaCarousel = {
      @react.component
      let make = () => {
        let iconComponent = (n, m, a: {"item": [#Foo | #Bar]}) => {
          switch a["item"] {
          | #Foo =>
            <div className="text-ocamlorange font-black">
              {React.string(Printf.sprintf("Foo-%d-%d", n, m))}
            </div>
          | #Bar =>
            Js.log(a)
            React.string(Printf.sprintf("Bar-%d-%d", n, m))
          }
        }
        let detailsComponent = foobar => {
          React.string(
            switch foobar["item"] {
            | #Foo => "This is a #foo."
            | #Bar => "This is a #bar."
            },
          )
        }
        <Item name="MediaCarousel" docs="MediaCarousel  element.">
          {[
            (
              "Media Carousel with no items.",
              <MediaCarousel label="Label" items=[] iconComponent detailsComponent />,
            ),
            (
              "Media Carousel with one item.",
              <MediaCarousel label="Label" items=[#Foo] iconComponent detailsComponent />,
            ),
            (
              "Media Carousel with items=[#Foo, #Bar, #Foo, #Bar, #Bar]",
              <MediaCarousel
                label="Label" items=[#Foo, #Bar, #Foo, #Bar, #Bar] iconComponent detailsComponent
              />,
            ),
          ]}
        </Item>
      }
    }

    module BlogCard = {
      @react.component
      let make = () => {
        let entry = n => {
          BlogCard.Entry.title: "Title" ++ n,
          excerpt: "Excerpt" ++ n,
          author: "Author" ++ n,
          dateValue: "DateValue" ++ n,
          date: "Date" ++ n,
          readingTime: "ReadingTime" ++ n,
        }
        let entries = n => Belt.Array.makeBy(n, i => entry(string_of_int(i)))
        <Item
          name="BlogCard"
          docs="BlogCard element. NOTE: BlogCard must have 3 elements. Any more will be ignored, any less will result in an exception.">
          {[
            // (
            //   "BlogCard with no entries.",
            //   <BlogCard
            //     header="Header"
            //     description="Description"
            //     blog="Blog"
            //     archiveText="ArchiveText"
            //     entries={entries(0)}
            //   />,
            // ),
            // (
            //   "BlogCard with 1 entry.",
            //   <BlogCard
            //     header="Header"
            //     description="Description"
            //     blog="Blog"
            //     archiveText="ArchiveText"
            //     entries={entries(1)}
            //   />,
            // ),
            // (
            //   "BlogCard with 2 entries.",
            //   <BlogCard
            //     header="Header"
            //     description="Description"
            //     blog="Blog"
            //     archiveText="ArchiveText"
            //     entries={entries(2)}
            //   />,
            // ),
            (
              "BlogCard with 3 entries.",
              <BlogCard
                header="Header"
                description="Description"
                blog="Blog"
                archiveText="ArchiveText"
                entries={entries(3)}
              />,
            ),
            (
              "BlogCard with 10 entries.",
              <BlogCard
                header="Header"
                description="Description"
                blog="Blog"
                archiveText="ArchiveText"
                entries={entries(10)}
              />,
            ),
          ]}
        </Item>
      }
    }

    module ContentGrid = {
      @react.component
      let make = () => {
        let renderChild = x => <div className="font-black text-2xl"> {React.string(x)} </div>
        <Item name="ContentGrid" docs="ContentGrid element.">
          {[
            (
              "ContentGrid with no items.",
              <ContentGrid title="ContentGrid" renderChild cols=#_2> [] </ContentGrid>,
            ),
            (
              "ContentGrid with 2 cols and 1 item.",
              <ContentGrid title="ContentGrid" renderChild cols=#_2> ["foo"] </ContentGrid>,
            ),
            (
              "ContentGrid with 2 cols and 2 items.",
              <ContentGrid title="ContentGrid" renderChild cols=#_2> ["foo", "bar"] </ContentGrid>,
            ),
            (
              "ContentGrid with 2 cols and 3 items.",
              <ContentGrid title="ContentGrid" renderChild cols=#_2>
                ["foo", "bar", "baz"]
              </ContentGrid>,
            ),
            (
              "ContentGrid with 3 cols and 3 items.",
              <ContentGrid title="ContentGrid" renderChild cols=#_3>
                ["foo", "bar", "baz"]
              </ContentGrid>,
            ),
            (
              "ContentGrid with 3 cols and 4 items.",
              <ContentGrid title="ContentGrid" renderChild cols=#_3>
                ["foo", "bar", "baz", "quux"]
              </ContentGrid>,
            ),
            (
              "ContentGrid with 2 cols and 4 items wrapped in a SectionContainer.",
              <SectionContainer.MediumCentered paddingY="pt-8 pb-14" filled=true>
                <ContentGrid title="ContentGrid" renderChild cols=#_2>
                  ["foo", "bar", "baz", "quux"]
                </ContentGrid>
              </SectionContainer.MediumCentered>,
            ),
          ]}
        </Item>
      }
    }

    module VerticalHighlightCard = {
      @react.component
      let make = () => {
        <Item name="VerticalHighlightCard" docs="VerticalHighlightCard element.">
          {[
            (
              defaultDoc,
              <VerticalHighlightCard
                title="Title" buttonText="ButtonText" buttonRoute=#Index lang=#en>
                {(
                  {
                    VerticalHighlightCard.title: "item1Title",
                    description: "item1Description",
                    url: "item1Url",
                  },
                  {
                    VerticalHighlightCard.title: "item2Title",
                    description: "item2Description",
                    url: "item2Url",
                  },
                  {
                    VerticalHighlightCard.title: "item3Title",
                    description: "item3Description",
                    url: "item3Url",
                  },
                )}
              </VerticalHighlightCard>,
            ),
          ]}
        </Item>
      }
    }

    @react.component
    let make = () =>
      <Category name="Sections">
        <LogoCloud />
        <Hero />
        <HighlightsInQuadrants />
        <MediaCarousel />
        <BlogCard />
        <Stats />
        <Testimonials />
        <Timeline />
        <UserLevelIntroduction />
        <MediaObject />
        <MediaObject.Small />
        <CallToAction.General />
        <CallToAction.TransparentWide />
        <Table.Simple />
        <Table.Regular />
        <MarkdownPage.Body />
        <ContentGrid />
        <VerticalHighlightCard />
      </Category>
  }

  module SectionContainer = {
    let child =
      <Table.Simple
        content={{
          headers: ["a", "b", "c"],
          data: [["a0", "b0", "c0"], ["a1", "b1", "c1"], ["a2", "b2", "c2"]]->Belt.Array.map(arr =>
            arr->Belt.Array.map(React.string)
          ),
        }}
      />

    module VerySmallCentered = {
      @react.component
      let make = () =>
        <Item
          name="SectionContainer.VerySmallCentered"
          docs="A very small and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.VerySmallCentered> {child} </SectionContainer.VerySmallCentered>,
            ),
          ]}
        </Item>
    }

    module SmallCentered = {
      @react.component
      let make = () =>
        <Item name="SectionContainer.SmallCentered" docs="A small and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.SmallCentered> {child} </SectionContainer.SmallCentered>,
            ),
          ]}
        </Item>
    }

    module MediumCentered = {
      @react.component
      let make = () =>
        <Item
          name="SectionContainer.MediumCentered" docs="A medium and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.MediumCentered> {child} </SectionContainer.MediumCentered>,
            ),
          ]}
        </Item>
    }

    module MediumCentered2 = {
      @react.component
      let make = () =>
        <Item
          name="SectionContainer.MediumCentered2" docs="A meduim and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.MediumCentered2> {child} </SectionContainer.MediumCentered2>,
            ),
          ]}
        </Item>
    }

    module LargeCentered = {
      @react.component
      let make = () =>
        <Item name="SectionContainer.LargeCentered" docs="A large and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.LargeCentered> {child} </SectionContainer.LargeCentered>,
            ),
          ]}
        </Item>
    }

    module ResponsiveCentered = {
      @react.component
      let make = () =>
        <Item
          name="SectionContainer.ResponsiveCentered"
          docs="A responsive and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.ResponsiveCentered> {child} </SectionContainer.ResponsiveCentered>,
            ),
          ]}
        </Item>
    }

    module FullyResponsiveCentered = {
      @react.component
      let make = () =>
        <Item
          name="SectionContainer.FullyResponsiveCentered"
          docs="A fully responsive and centered section container.">
          {[
            (
              defaultDoc,
              <SectionContainer.FullyResponsiveCentered>
                {child}
              </SectionContainer.FullyResponsiveCentered>,
            ),
          ]}
        </Item>
    }

    module NoneFilled = {
      @react.component
      let make = () =>
        <Item name="SectionContainer.NoneFilled" docs="A none filled section container.">
          {[(defaultDoc, <SectionContainer.NoneFilled> {child} </SectionContainer.NoneFilled>)]}
        </Item>
    }

    @react.component
    let make = () =>
      <Category name="SectionsContainer">
        <VerySmallCentered />
        <SmallCentered />
        <MediumCentered />
        <MediumCentered2 />
        <LargeCentered />
        <ResponsiveCentered />
        <FullyResponsiveCentered />
        <NoneFilled />
      </Category>
  }

  module ComponentCollection = {
    @react.component
    let make = () =>
      <Category name="Component Collection">
        <Item
          name="CardGrid"
          docs="Lays out several elements in a grid layout. The rendering function for each element of the card can be passed in to change how it renders.">
          {
            let cardData = ["abc", "def", "ghi", "jkl"]
            [
              (
                "CardGrid rendered with strings for each element",
                {
                  let renderCard = React.string
                  let title = "Example"
                  <CardGrid cardData renderCard title />
                },
              ),
              (
                "CardGrid rendered with Cards for each element",
                {
                  let renderCard = s =>
                    <Card title="<Card>" kind={#Opaque}> {React.string(s)} </Card>
                  let title = "Example"
                  <CardGrid cardData renderCard title />
                },
              ),
            ]
          }
        </Item>
      </Category>
  }

  @react.component
  let make = () => <>
    <PageTitles /> <BasicComponents /> <ComponentCollection /> <Sections /> <SectionContainer />
  </>
}

module PageItem = {
  @react.component
  let make = (~children, ~last=false) => <>
    <div className="mt-4 mb-4"> {children} </div> {last ? React.null : <hr />}
  </>
}

@react.component
let make = () => {
  let exampleContent =
    <Card title="Example Content" kind=#Opaque> {React.string("Hello World")} </Card>
  <>
    <PageItem>
      <Page.Basic
        title="Examples of Pages"
        pageDescription="The following section demonstrates the Page elements together with the same example content. Each page is separated by an <hr> element."
        addContainer=#NoContainer
        addBottomBar=true>
        {<> </>}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <Page.Basic
        title="Page.Basic"
        pageDescription="PAge description: Default Page.Basic"
        titleHeadingHeaderClassName="mt-24">
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <div className="mt-24">
        <Page.Basic title="pAge.Basic" pageDescription="Page description: Default Page.Basic">
          {exampleContent}
        </Page.Basic>
      </div>
    </PageItem>
    <PageItem>
      <Page.Basic title="Page.Basic" pageDescription="Page description: Default Page.Basic">
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <Page.Basic
        title="Page.Basic"
        pageDescription="Page description: Example Page.Basic with no container"
        addContainer=#NoContainer>
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <Page.Basic
        title="Page.Basic"
        pageDescription="Page description: Example Page.Basic with regular container"
        addContainer=#Regular>
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <Page.Basic
        title="Page.Basic"
        pageDescription="Page description: Example Page.Basic with narrow container"
        addContainer=#Narrow>
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      <Page.Basic
        title="Page.Basic"
        pageDescription="Page description: Example Page.Basic with default container and a callToAction."
        callToAction={
          CallToAction.Simple.label: "callToAction Label",
          url: "http://ocaml.org",
        }>
        {exampleContent}
      </Page.Basic>
    </PageItem>
    <PageItem>
      {
        let highlightContent = {
          Page.highlightItem: `Highlight Item`,
          clickToRead: `Click to Read`,
          highlightItemSummary: {
            preview: `Highlight summary preview`,
            url: `/storybook`,
          },
          bgImageClass: `bg-news-bg`,
        }
        <Page.HighlightItem
          title="Page.HighlightItem"
          pageDescription="Page description: Example Page.HighlightItem"
          highlightContent>
          {exampleContent}
        </Page.HighlightItem>
      }
    </PageItem>
    <PageItem>
      <Page.TitleOverBackgroundImage
        title="Page.TitleOverBackgroundImage"
        backgroundImage={
          TitleHeading.OverBackgroundImage.BackgroundImage.height: Tall,
          tailwindImageName: `bg-user-bg`,
        }
        pageDescription="Page description: Example Page.TitleOverBackgroundImage">
        {exampleContent}
      </Page.TitleOverBackgroundImage>
    </PageItem>
    <PageItem>
      <Page.TopImage
        title="Page.TopImage" pageDescription="Page description: Example Page.TopImage">
        {exampleContent}
      </Page.TopImage>
    </PageItem>
    <PageItem>
      <Page.Unstructured>
        <Card title="Example" kind=#Opaque>
          {React.string(
            "NOTE: This is an example of a Page.Unstructured. Since the <Page.Unstructured> element takes no arguments, this description is actually located inside a <Card> which is a child of the <Page.Unstructured> element.",
          )}
        </Card>
      </Page.Unstructured>
    </PageItem>
    <PageItem>
      <Page.Unstructured>
        <Card title="Page Sections" kind=#Transparent>
          {React.string(
            "The contents of this page demonstrate the use of the Page Section containers.",
          )}
        </Card>
        <Page.MainContainer.Centered>
          <div className="mb-8">
            <Card kind=#Opaque>
              {React.string("This <Card> is inside a <Page.MainContainer.Centered>")}
            </Card>
          </div>
        </Page.MainContainer.Centered>
        <Page.MainContainer.NarrowCentered>
          <div className="mb-8">
            <Card kind=#Opaque>
              {React.string("This <Card> is inside a <Page.MainContainer.NarrowCentered>")}
            </Card>
          </div>
        </Page.MainContainer.NarrowCentered>
        <Page.MainContainer.None>
          <div className="mb-8">
            <Card kind=#Opaque>
              {React.string("This <Card> is inside a <Page.MainContainer.None>")}
            </Card>
          </div>
        </Page.MainContainer.None>
      </Page.Unstructured>
    </PageItem>
    <PageItem last=true>
      <Page.Basic
        title="Main Storybook Content"
        pageDescription="The following section demonstrates the non-Page elements. Note: Individual examples of components are rendered using different background colors in order to distinguish them, and also to see how the element behaves with a given background color. For example, this may be useful if the element has a transparent background."
        addContainer=#NoContainer
        addBottomBar=true>
        <Categories />
      </Page.Basic>
    </PageItem>
  </>
}

let default = make
