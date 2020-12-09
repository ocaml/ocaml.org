module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>;
};

let default = () =>
  <div>
    <h1 className="text-3xl font-semibold">
      {React.string("What is this about?")}
    </h1>
    <P>
      {React.string(
         "This is a simple template for a Next
      project using ReScript & TailwindCSS.",
       )}
    </P>
    <h2 className="text-2xl font-semibold mt-5">
      {React.string("Quick Start")}
    </h2>
    <P>
        {React.string(
           "git clone https://github.com/ryyppy/nextjs-default.git my-project
cd my-project
rm -rf .git"
         )}
    </P>
  </div>;
