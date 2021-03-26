let s = React.string

type t = {
  title: string,
  pageDescription: string,
  beginning: string,
  beginningIntroduction: string,
  growing: string,
  growingIntroduction: string,
  expanding: string,
  expandingIntroduction: string,
  diversifying: string,
  diversifyingIntroduction: string,
  researching: string,
  researchingIntroduction: string,
}

let contentEn = {
  title: `Language`,
  pageDescription: `This is the home of learning and tutorials. Whether you're a beginner, a teacher, or a seasoned researcher, this is where you can find the resources you need to accomplish your goals in OCaml.`,
  beginning: `Beginning`,
  beginningIntroduction: `Are you a beginner? Or just someone who wants to brush up on the fundamentals? In either case, the OFronds tutorial system has you covered!`,
  growing: `Growing`,
  growingIntroduction: `Familiar with the basics and looking to get a more robust understanding of OCaml? Or just curious? Check out the books available on OCaml:`,
  expanding: `Expanding`,
  expandingIntroduction: `Have a strong foundation in OCaml? Time to get involved! Prepare by getting familiar with the OCaml Manual:`,
  diversifying: `Diversifying`,
  diversifyingIntroduction: `Now that you're familiar with the building blocks of OCaml, you may want to diversify your portfolio and have a look at the many applications that operate using OCaml.`,
  researching: `Researching`,
  researchingIntroduction: `Aspiring towards greater understanding of the language? Want to push the limits and discover brand new things? Check out papers written by leading OCaml researchers:`,
}

module UserLevelIntroduction = {
  @react.component
  let make = (~userLevel, ~introduction, ~margins) =>
    <div className={"flex mx-auto max-w-4xl items-center space-x-20 " ++ margins}>
      <div className="text-5xl font-bold text-orangedark flex-shrink-0">
        {s(userLevel ++ ` -`)}
      </div>
      <div className="font-bold text-xl"> {s(introduction)} </div>
    </div>
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
  <UserLevelIntroduction
    userLevel=content.beginning introduction=content.beginningIntroduction margins=`mb-20`
  />
  <UserLevelIntroduction
    userLevel=content.growing introduction=content.growingIntroduction margins=`mb-20`
  />
  <UserLevelIntroduction
    userLevel=content.expanding introduction=content.expandingIntroduction margins=`mb-20`
  />
  <UserLevelIntroduction
    userLevel=content.diversifying introduction=content.diversifyingIntroduction margins=`mb-20`
  />
  <UserLevelIntroduction
    userLevel=content.researching introduction=content.researchingIntroduction margins=`mb-20`
  />
</>

let default = make
