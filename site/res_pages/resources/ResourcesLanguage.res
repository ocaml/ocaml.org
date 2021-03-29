let s = React.string

module UserLevelIntroduction = {
  type t = {
    level: string,
    introduction: string,
  }

  @react.component
  let make = (~content, ~margins) =>
    <div className={"flex mx-auto max-w-4xl items-center space-x-20 " ++ margins}>
      <div className="text-5xl font-bold text-orangedark flex-shrink-0">
        {s(content.level ++ ` -`)}
      </div>
      <div className="font-bold text-xl"> {s(content.introduction)} </div>
    </div>
}

type t = {
  title: string,
  pageDescription: string,
  beginning: UserLevelIntroduction.t,
  growing: UserLevelIntroduction.t,
  expanding: UserLevelIntroduction.t,
  diversifying: UserLevelIntroduction.t,
  researching: UserLevelIntroduction.t,
}

let contentEn = {
  title: `Language`,
  pageDescription: `This is the home of learning and tutorials. Whether you're a beginner, a teacher, or a seasoned researcher, this is where you can find the resources you need to accomplish your goals in OCaml.`,
  beginning: {
    level: `Beginning`,
    introduction: `Are you a beginner? Or just someone who wants to brush up on the fundamentals? In either case, the OFronds tutorial system has you covered!`,
  },
  growing: {
    level: `Growing`,
    introduction: `Familiar with the basics and looking to get a more robust understanding of OCaml? Or just curious? Check out the books available on OCaml:`,
  },
  expanding: {
    level: `Expanding`,
    introduction: `Have a strong foundation in OCaml? Time to get involved! Prepare by getting familiar with the OCaml Manual:`,
  },
  diversifying: {
    level: `Diversifying`,
    introduction: `Now that you're familiar with the building blocks of OCaml, you may want to diversify your portfolio and have a look at the many applications that operate using OCaml.`,
  },
  researching: {
    level: `Researching`,
    introduction: `Aspiring towards greater understanding of the language? Want to push the limits and discover brand new things? Check out papers written by leading OCaml researchers:`,
  },
}

@react.component
let make = (~content=contentEn) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1085%3A121`
    playgroundLink=`/play/resources/language`
  />
  <TitleHeading.LandingTitleHeading
    title=content.title
    pageDescription=content.pageDescription
    marginTop=`mt-1`
    marginBottom=`mb-24`
  />
  <UserLevelIntroduction content=content.beginning margins=`mb-20` />
  <UserLevelIntroduction content=content.growing margins=`mb-20` />
  <UserLevelIntroduction content=content.expanding margins=`mb-20` />
  <UserLevelIntroduction content=content.diversifying margins=`mb-20` />
  <UserLevelIntroduction content=content.researching margins=`mb-20` />
</>

let default = make
