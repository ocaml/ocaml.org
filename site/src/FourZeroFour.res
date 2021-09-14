open! Import

@react.component
let make = () => {
  let fallbackLang = #en
  let router = Next.Router.useRouter()
  let (currentLang, state) = {
    let sep = "/"
    let splitPath = Js.String.split(sep, router.asPath)
    let lang = splitPath->Belt.Array.get(1)->Belt.Option.flatMap(Lang.ofString)
    let state = switch splitPath->Belt.Array.get(0) {
    | None => #Redirect(lang => sep ++ Lang.toString(lang))
    | Some(root) =>
      switch splitPath->Belt.Array.get(1) {
      | None => #Redirect(lang => Js.Array.joinWith(sep, [root, Lang.toString(lang)]))
      | Some(langStr) =>
        let rest = Js.Array.sliceFrom(2, splitPath)
        switch Lang.ofString(langStr) {
        | None =>
          #Redirect(
            lang => Js.Array.joinWith(sep, [root, Lang.toString(lang)]->Js.Array.concat(rest)),
          )
        | Some(lang) =>
          switch lang == fallbackLang {
          | true => #NotFound
          | false =>
            #Redirect(
              lang => Js.Array.joinWith(sep, [root, Lang.toString(lang)]->Js.Array.concat(rest)),
            )
          }
        }
      }
    }
    (lang, state)
  }
  let redirectContent = {
    currentLang
    ->Belt.Option.getWithDefault(fallbackLang)
    ->Redirect.content
    ->Belt.Option.getWithDefault(Redirect.contentEn)
  }
  switch state {
  | #NotFound => <Next.Error statusCode=404 />
  | #Redirect(path) =>
    <Page.MainContainer.Centered>
      <p className="py-4">
        <SectionContainer.VerySmallCentered>
          <Redirect path={path(fallbackLang)} content={redirectContent} />
        </SectionContainer.VerySmallCentered>
      </p>
    </Page.MainContainer.Centered>
  }
}
