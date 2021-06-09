type location = { lat : float; long : float }

type course = {
  name : string;
  accronym : string option;
  online_resource : string option;
}

type t = {
  name : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  course : course list;
  location : location option;
}
