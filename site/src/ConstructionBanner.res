open! Import

@react.component
let make = (~figmaLink=?, ~playgroundLink=?) =>
  <div className="relative bg-indigo-600">
    <div className="max-w-7xl mx-auto py-3 px-3 sm:px-6 lg:px-8">
      <div className="pr-16 sm:text-center sm:px-16">
        <p className="font-medium text-white">
          {switch (figmaLink, playgroundLink) {
          | (None, None) => <span className=""> {React.string(`Future page`)} </span>
          | _ => <>
              <span className=""> {React.string(`Under construction`)} </span>
              <span className="block sm:ml-2 sm:inline-block">
                {/* Delete this soon, hiding for now
                {switch playgroundLink {
                | Some(playgroundLink) =>
                  <a href=playgroundLink className="text-white font-bold underline">
                    {React.string(`View Playground >>`)}
                  </a>
                | _ => React.null
                }}
                {React.string(` `)}
 */
                switch figmaLink {
                | Some(figmaLink) =>
                  <a href=figmaLink className="text-white font-bold underline">
                    {React.string(`View in Figma >>`)}
                  </a>
                | _ => React.null
                }}
              </span>
            </>
          }}
        </p>
      </div>
    </div>
  </div>
