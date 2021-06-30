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
</>

let default = make
