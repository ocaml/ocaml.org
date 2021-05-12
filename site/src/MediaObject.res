type imageSide = Left | Right

@react.component
let make = (
  ~marginBottom="",
  ~imageHeight,
  ~imageWidth="",
  ~isRounded=false,
  ~image,
  ~imageSide,
  ~children,
  (),
) => {
  <div className={`flex flex-col items-center sm:flex-row sm:justify-evenly ${marginBottom}`}>
    {
      let rounded = switch isRounded {
      | true => "rounded-full"
      | false => ""
      }
      let image =
        <img className={`${imageHeight} ${imageWidth} ${rounded}`} src={"/static/" ++ image} />
      switch imageSide {
      | Left => <>
          <div className="mb-10 sm:mb-0 mr-10 sm:flex-shrink-0"> image </div> <div> children </div>
        </>
      | Right => <>
          <div className="order-2 sm:order-1"> children </div>
          <div className="order-1 sm:order-2 mt-10 sm:mt-0 ml-10 sm:flex-shrink-0"> image </div>
        </>
      }
    }
  </div>
}
