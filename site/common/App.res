// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably
// will never need this
// See https://nextjs.org/docs/advanced-features/custom-app
type pageProps = {.};

module PageComponent = {
  type t = React.component<pageProps>;
};

type props = {
  "Component": PageComponent.t,
  "pageProps": pageProps
};

// We are not using `[@react.component]` since we will never
// use <App/> within our Reason code. It's only used within `pages/_app.js`
let make = (props: props): React.element => {

  let component = props["Component"];
  let pageProps = props["pageProps"];

  let router = Next.Router.useRouter();

  let content = React.createElement(component, pageProps);
  Js.log(router.route)
  switch (router.route) {
  | "/releases" =>
    <MainLayout editpath="site/index.md">
      <h1 className="font-bold"> {React.string("Releases Section")} </h1>
      <div> content </div>
    </MainLayout>
  | _ => <MainLayout editpath="site/index.md"> content </MainLayout>
  };
};
