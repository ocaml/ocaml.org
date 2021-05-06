// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably
// will never need this
// See https://nextjs.org/docs/advanced-features/custom-app
type pageProps = {.}

// TODO: should pageProps be a variant that represents
//  all possible definitions of pageProps?
module PageComponent = {
  type t = React.component<pageProps>
}

type props = {"Component": PageComponent.t, "pageProps": pageProps}

// We are not using `[@react.component]` since we will never
// use <App/> within our Reason code. It's only used within `pages/_app.js`
let make = (props: props): React.element => {
  let component = props["Component"]
  let pageProps = props["pageProps"]

  let router = Next.Router.useRouter()

  let content = React.createElement(component, pageProps)
  // debug with: Js.log(router.route)
  switch router.route {
  | _ => <MainLayout> content </MainLayout>
  }
}
