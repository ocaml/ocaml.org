open! Import

type t = {
  companies: LogoCloud.t,
  title: string,
  pageDescription: string,
  backgroundImage: TitleHeading.OverBackgroundImage.BackgroundImage.t,
}

include Pages.S with type t := t
