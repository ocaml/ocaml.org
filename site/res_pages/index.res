module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>;
};

let default = () =>
  <div>
    <h1 className="text-3xl font-semibold">
      {React.string("OCaml is an industrial-strength programming language 
      supporting functional, imperative and object-oriented styles")}
    </h1>
    <P>{React.string("Install OCaml")}</P>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Learn")}
    </h2>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Documentation")}
    </h2>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Packages")}
    </h2>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Community")}
    </h2>
  </div>;
