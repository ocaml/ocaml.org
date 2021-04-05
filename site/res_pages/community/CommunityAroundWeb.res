let s = React.string

module LatestNews = {
  @react.component
  let make = () => // TODO: define content type, extract content
  <>
    <h2
      className="mb-8 text-3xl text-center tracking-tight font-extrabold text-gray-900 sm:text-4xl">
      {s(`What's the Latest?`)}
    </h2>
    <div className="bg-graylight flex flex-col items-center lg:flex-row lg:justify-evenly">
      <img
        className="inline-block h-28 w-28 lg:h-64 lg:w-64 rounded-full mb-8 lg:mb-0"
        src="/static/typewriter.jpeg"
        alt=""
      />
      <div>
        <div className="bg-white border border-gray-300 overflow-hidden rounded-md mb-2">
          <ul className="divide-y divide-gray-300">
            <li className="px-6 py-4">
              <div className="flex justify-between items-center space-x-6">
                <div>
                  <svg
                    className="hidden lg:inline-block mr-3"
                    width="52"
                    height="52"
                    viewBox="0 0 52 52"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M33.7784 19.9879C33.7784 20.2997 33.6557 20.5988 33.4373 20.8193C33.2188 21.0398 32.9226 21.1636 32.6137 21.1636H25.625C25.3161 21.1636 25.0198 21.0398 24.8014 20.8193C24.583 20.5988 24.4602 20.2997 24.4602 19.9879C24.4602 19.676 24.583 19.377 24.8014 19.1565C25.0198 18.936 25.3161 18.8121 25.625 18.8121H32.6137C32.9226 18.8121 33.2188 18.936 33.4373 19.1565C33.6557 19.377 33.7784 19.676 33.7784 19.9879ZM31.4489 23.5151H25.625C25.3161 23.5151 25.0198 23.639 24.8014 23.8595C24.583 24.08 24.4602 24.3791 24.4602 24.6909C24.4602 25.0027 24.583 25.3018 24.8014 25.5223C25.0198 25.7428 25.3161 25.8667 25.625 25.8667H31.4489C31.7578 25.8667 32.0541 25.7428 32.2725 25.5223C32.4909 25.3018 32.6137 25.0027 32.6137 24.6909C32.6137 24.3791 32.4909 24.08 32.2725 23.8595C32.0541 23.639 31.7578 23.5151 31.4489 23.5151ZM12.8125 23.5151V36.4485C12.8125 37.384 13.1807 38.2811 13.836 38.9426C14.4913 39.6041 15.3801 39.9758 16.3068 39.9758C17.2336 39.9758 18.1224 39.6041 18.7777 38.9426C19.433 38.2811 19.8012 37.384 19.8012 36.4485V31.7454H16.3068C15.9979 31.7454 15.7017 31.6216 15.4832 31.4011C15.2648 31.1806 15.1421 30.8815 15.1421 30.5697C15.1421 30.2579 15.2648 29.9588 15.4832 29.7383C15.7017 29.5178 15.9979 29.3939 16.3068 29.3939H19.8012V27.0424H16.3068C15.9979 27.0424 15.7017 26.9185 15.4832 26.698C15.2648 26.4776 15.1421 26.1785 15.1421 25.8667C15.1421 25.5548 15.2648 25.2558 15.4832 25.0353C15.7017 24.8148 15.9979 24.6909 16.3068 24.6909H19.8012V22.3394H13.9773C13.6684 22.3394 13.3721 22.4633 13.1537 22.6838C12.9352 22.9043 12.8125 23.2033 12.8125 23.5151ZM34.9432 14.1091H25.625C25.3161 14.1091 25.0198 14.233 24.8014 14.4535C24.583 14.674 24.4602 14.973 24.4602 15.2848C24.4602 15.5967 24.583 15.8957 24.8014 16.1162C25.0198 16.3367 25.3161 16.4606 25.625 16.4606H34.9432C35.2521 16.4606 35.5484 16.3367 35.7668 16.1162C35.9853 15.8957 36.108 15.5967 36.108 15.2848C36.108 14.973 35.9853 14.674 35.7668 14.4535C35.5484 14.233 35.2521 14.1091 34.9432 14.1091ZM51.25 25.8667C51.25 30.9826 49.7472 35.9837 46.9314 40.2374C44.1157 44.4912 40.1136 47.8066 35.4313 49.7643C30.7489 51.7221 25.5966 52.2344 20.6258 51.2363C15.6551 50.2382 11.0891 47.7747 7.5054 44.1572C3.92168 40.5396 1.48114 35.9306 0.492389 30.913C-0.496358 25.8954 0.011103 20.6944 1.9506 15.9679C3.8901 11.2414 7.17452 7.20158 11.3885 4.35932C15.6025 1.51705 20.5569 0 25.625 0C32.4212 0 38.939 2.72523 43.7446 7.57617C48.5503 12.4271 51.25 19.0064 51.25 25.8667ZM40.7671 12.9333C40.7671 11.9978 40.3989 11.1007 39.7436 10.4392C39.0883 9.77768 38.1995 9.40606 37.2728 9.40606H23.2955C22.3687 9.40606 21.4799 9.77768 20.8246 10.4392C20.1693 11.1007 19.8012 11.9978 19.8012 12.9333V19.9879H13.9773C13.0505 19.9879 12.1617 20.3595 11.5064 21.021C10.8511 21.6825 10.483 22.5797 10.483 23.5151V36.4485C10.483 38.0076 11.0966 39.5029 12.1887 40.6054C13.2809 41.7079 14.7622 42.3273 16.3068 42.3273H34.9432C36.4878 42.3273 37.9691 41.7079 39.0613 40.6054C40.1535 39.5029 40.7671 38.0076 40.7671 36.4485V12.9333Z"
                      fill="#ED7109"
                    />
                  </svg>
                  {s(`OCaml Weekly News`)}
                </div>
                <svg
                  className="w-4"
                  width="21"
                  height="24"
                  viewBox="0 0 21 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M20.5607 13.0607C21.1464 12.4749 21.1464 11.5251 20.5607 10.9393L11.0147 1.3934C10.4289 0.807611 9.47919 0.807611 8.8934 1.3934C8.30761 1.97919 8.30761 2.92893 8.8934 3.51472L17.3787 12L8.8934 20.4853C8.30761 21.0711 8.30761 22.0208 8.8934 22.6066C9.47919 23.1924 10.4289 23.1924 11.0147 22.6066L20.5607 13.0607ZM0 13.5L19.5 13.5V10.5L0 10.5L0 13.5Z"
                    fill="#ED7109"
                  />
                </svg>
              </div>
            </li>
            <li className="px-6 py-4">
              <div className="flex justify-between items-center space-x-6">
                <div>
                  <svg
                    className="hidden lg:inline-block mr-3"
                    width="52"
                    height="52"
                    viewBox="0 0 52 52"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M33.7784 19.9879C33.7784 20.2997 33.6557 20.5988 33.4373 20.8193C33.2188 21.0398 32.9226 21.1636 32.6137 21.1636H25.625C25.3161 21.1636 25.0198 21.0398 24.8014 20.8193C24.583 20.5988 24.4602 20.2997 24.4602 19.9879C24.4602 19.676 24.583 19.377 24.8014 19.1565C25.0198 18.936 25.3161 18.8121 25.625 18.8121H32.6137C32.9226 18.8121 33.2188 18.936 33.4373 19.1565C33.6557 19.377 33.7784 19.676 33.7784 19.9879ZM31.4489 23.5151H25.625C25.3161 23.5151 25.0198 23.639 24.8014 23.8595C24.583 24.08 24.4602 24.3791 24.4602 24.6909C24.4602 25.0027 24.583 25.3018 24.8014 25.5223C25.0198 25.7428 25.3161 25.8667 25.625 25.8667H31.4489C31.7578 25.8667 32.0541 25.7428 32.2725 25.5223C32.4909 25.3018 32.6137 25.0027 32.6137 24.6909C32.6137 24.3791 32.4909 24.08 32.2725 23.8595C32.0541 23.639 31.7578 23.5151 31.4489 23.5151ZM12.8125 23.5151V36.4485C12.8125 37.384 13.1807 38.2811 13.836 38.9426C14.4913 39.6041 15.3801 39.9758 16.3068 39.9758C17.2336 39.9758 18.1224 39.6041 18.7777 38.9426C19.433 38.2811 19.8012 37.384 19.8012 36.4485V31.7454H16.3068C15.9979 31.7454 15.7017 31.6216 15.4832 31.4011C15.2648 31.1806 15.1421 30.8815 15.1421 30.5697C15.1421 30.2579 15.2648 29.9588 15.4832 29.7383C15.7017 29.5178 15.9979 29.3939 16.3068 29.3939H19.8012V27.0424H16.3068C15.9979 27.0424 15.7017 26.9185 15.4832 26.698C15.2648 26.4776 15.1421 26.1785 15.1421 25.8667C15.1421 25.5548 15.2648 25.2558 15.4832 25.0353C15.7017 24.8148 15.9979 24.6909 16.3068 24.6909H19.8012V22.3394H13.9773C13.6684 22.3394 13.3721 22.4633 13.1537 22.6838C12.9352 22.9043 12.8125 23.2033 12.8125 23.5151ZM34.9432 14.1091H25.625C25.3161 14.1091 25.0198 14.233 24.8014 14.4535C24.583 14.674 24.4602 14.973 24.4602 15.2848C24.4602 15.5967 24.583 15.8957 24.8014 16.1162C25.0198 16.3367 25.3161 16.4606 25.625 16.4606H34.9432C35.2521 16.4606 35.5484 16.3367 35.7668 16.1162C35.9853 15.8957 36.108 15.5967 36.108 15.2848C36.108 14.973 35.9853 14.674 35.7668 14.4535C35.5484 14.233 35.2521 14.1091 34.9432 14.1091ZM51.25 25.8667C51.25 30.9826 49.7472 35.9837 46.9314 40.2374C44.1157 44.4912 40.1136 47.8066 35.4313 49.7643C30.7489 51.7221 25.5966 52.2344 20.6258 51.2363C15.6551 50.2382 11.0891 47.7747 7.5054 44.1572C3.92168 40.5396 1.48114 35.9306 0.492389 30.913C-0.496358 25.8954 0.011103 20.6944 1.9506 15.9679C3.8901 11.2414 7.17452 7.20158 11.3885 4.35932C15.6025 1.51705 20.5569 0 25.625 0C32.4212 0 38.939 2.72523 43.7446 7.57617C48.5503 12.4271 51.25 19.0064 51.25 25.8667ZM40.7671 12.9333C40.7671 11.9978 40.3989 11.1007 39.7436 10.4392C39.0883 9.77768 38.1995 9.40606 37.2728 9.40606H23.2955C22.3687 9.40606 21.4799 9.77768 20.8246 10.4392C20.1693 11.1007 19.8012 11.9978 19.8012 12.9333V19.9879H13.9773C13.0505 19.9879 12.1617 20.3595 11.5064 21.021C10.8511 21.6825 10.483 22.5797 10.483 23.5151V36.4485C10.483 38.0076 11.0966 39.5029 12.1887 40.6054C13.2809 41.7079 14.7622 42.3273 16.3068 42.3273H34.9432C36.4878 42.3273 37.9691 41.7079 39.0613 40.6054C40.1535 39.5029 40.7671 38.0076 40.7671 36.4485V12.9333Z"
                      fill="#ED7109"
                    />
                  </svg>
                  {s(`How We Lost at The Delphi Oracle Challenge`)}
                </div>
                <svg
                  className="w-4"
                  width="21"
                  height="24"
                  viewBox="0 0 21 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M20.5607 13.0607C21.1464 12.4749 21.1464 11.5251 20.5607 10.9393L11.0147 1.3934C10.4289 0.807611 9.47919 0.807611 8.8934 1.3934C8.30761 1.97919 8.30761 2.92893 8.8934 3.51472L17.3787 12L8.8934 20.4853C8.30761 21.0711 8.30761 22.0208 8.8934 22.6066C9.47919 23.1924 10.4289 23.1924 11.0147 22.6066L20.5607 13.0607ZM0 13.5L19.5 13.5V10.5L0 10.5L0 13.5Z"
                    fill="#ED7109"
                  />
                </svg>
              </div>
            </li>
            <li className="px-6 py-4">
              <div className="flex justify-between items-center space-x-6">
                <div>
                  <svg
                    className="hidden lg:inline-block mr-3"
                    width="52"
                    height="52"
                    viewBox="0 0 52 52"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path
                      d="M33.7784 19.9879C33.7784 20.2997 33.6557 20.5988 33.4373 20.8193C33.2188 21.0398 32.9226 21.1636 32.6137 21.1636H25.625C25.3161 21.1636 25.0198 21.0398 24.8014 20.8193C24.583 20.5988 24.4602 20.2997 24.4602 19.9879C24.4602 19.676 24.583 19.377 24.8014 19.1565C25.0198 18.936 25.3161 18.8121 25.625 18.8121H32.6137C32.9226 18.8121 33.2188 18.936 33.4373 19.1565C33.6557 19.377 33.7784 19.676 33.7784 19.9879ZM31.4489 23.5151H25.625C25.3161 23.5151 25.0198 23.639 24.8014 23.8595C24.583 24.08 24.4602 24.3791 24.4602 24.6909C24.4602 25.0027 24.583 25.3018 24.8014 25.5223C25.0198 25.7428 25.3161 25.8667 25.625 25.8667H31.4489C31.7578 25.8667 32.0541 25.7428 32.2725 25.5223C32.4909 25.3018 32.6137 25.0027 32.6137 24.6909C32.6137 24.3791 32.4909 24.08 32.2725 23.8595C32.0541 23.639 31.7578 23.5151 31.4489 23.5151ZM12.8125 23.5151V36.4485C12.8125 37.384 13.1807 38.2811 13.836 38.9426C14.4913 39.6041 15.3801 39.9758 16.3068 39.9758C17.2336 39.9758 18.1224 39.6041 18.7777 38.9426C19.433 38.2811 19.8012 37.384 19.8012 36.4485V31.7454H16.3068C15.9979 31.7454 15.7017 31.6216 15.4832 31.4011C15.2648 31.1806 15.1421 30.8815 15.1421 30.5697C15.1421 30.2579 15.2648 29.9588 15.4832 29.7383C15.7017 29.5178 15.9979 29.3939 16.3068 29.3939H19.8012V27.0424H16.3068C15.9979 27.0424 15.7017 26.9185 15.4832 26.698C15.2648 26.4776 15.1421 26.1785 15.1421 25.8667C15.1421 25.5548 15.2648 25.2558 15.4832 25.0353C15.7017 24.8148 15.9979 24.6909 16.3068 24.6909H19.8012V22.3394H13.9773C13.6684 22.3394 13.3721 22.4633 13.1537 22.6838C12.9352 22.9043 12.8125 23.2033 12.8125 23.5151ZM34.9432 14.1091H25.625C25.3161 14.1091 25.0198 14.233 24.8014 14.4535C24.583 14.674 24.4602 14.973 24.4602 15.2848C24.4602 15.5967 24.583 15.8957 24.8014 16.1162C25.0198 16.3367 25.3161 16.4606 25.625 16.4606H34.9432C35.2521 16.4606 35.5484 16.3367 35.7668 16.1162C35.9853 15.8957 36.108 15.5967 36.108 15.2848C36.108 14.973 35.9853 14.674 35.7668 14.4535C35.5484 14.233 35.2521 14.1091 34.9432 14.1091ZM51.25 25.8667C51.25 30.9826 49.7472 35.9837 46.9314 40.2374C44.1157 44.4912 40.1136 47.8066 35.4313 49.7643C30.7489 51.7221 25.5966 52.2344 20.6258 51.2363C15.6551 50.2382 11.0891 47.7747 7.5054 44.1572C3.92168 40.5396 1.48114 35.9306 0.492389 30.913C-0.496358 25.8954 0.011103 20.6944 1.9506 15.9679C3.8901 11.2414 7.17452 7.20158 11.3885 4.35932C15.6025 1.51705 20.5569 0 25.625 0C32.4212 0 38.939 2.72523 43.7446 7.57617C48.5503 12.4271 51.25 19.0064 51.25 25.8667ZM40.7671 12.9333C40.7671 11.9978 40.3989 11.1007 39.7436 10.4392C39.0883 9.77768 38.1995 9.40606 37.2728 9.40606H23.2955C22.3687 9.40606 21.4799 9.77768 20.8246 10.4392C20.1693 11.1007 19.8012 11.9978 19.8012 12.9333V19.9879H13.9773C13.0505 19.9879 12.1617 20.3595 11.5064 21.021C10.8511 21.6825 10.483 22.5797 10.483 23.5151V36.4485C10.483 38.0076 11.0966 39.5029 12.1887 40.6054C13.2809 41.7079 14.7622 42.3273 16.3068 42.3273H34.9432C36.4878 42.3273 37.9691 41.7079 39.0613 40.6054C40.1535 39.5029 40.7671 38.0076 40.7671 36.4485V12.9333Z"
                      fill="#ED7109"
                    />
                  </svg>
                  {s(`Coq 8.12.2 is out`)}
                </div>
                <svg
                  className="w-4"
                  width="21"
                  height="24"
                  viewBox="0 0 21 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M20.5607 13.0607C21.1464 12.4749 21.1464 11.5251 20.5607 10.9393L11.0147 1.3934C10.4289 0.807611 9.47919 0.807611 8.8934 1.3934C8.30761 1.97919 8.30761 2.92893 8.8934 3.51472L17.3787 12L8.8934 20.4853C8.30761 21.0711 8.30761 22.0208 8.8934 22.6066C9.47919 23.1924 10.4289 23.1924 11.0147 22.6066L20.5607 13.0607ZM0 13.5L19.5 13.5V10.5L0 10.5L0 13.5Z"
                    fill="#ED7109"
                  />
                </svg>
              </div>
            </li>
          </ul>
        </div>
        <p className="text-xs text-right">
          <a className="text-orangedark hover:text-orangedark" href="/community/newsarchive">
            {s(`Go to the news archive >`)}
          </a>
        </p>
      </div>
    </div>
  </>
}

type blogEntry = {
  title: string,
  excerpt: string,
  author: string,
  dateValue: string,
  date: string,
  readingTime: string,
}

type t = {
  title: string,
  pageDescription: string,
  engageHeader: string,
  engageBody: string,
  engageButtonText: string,
  blogSectionHeader: string,
  blogSectionDescription: string,
  blog: string,
  blogEntries: array<blogEntry>,
  blogArchiveText: string,
  spacesSectionHeader: string,
  spaces: array<string>,
}

type props = {content: t}

@react.component
let make = (~content) => <>
  <ConstructionBanner
    figmaLink=`https://www.figma.com/file/36JnfpPe1Qoc8PaJq8mGMd/V1-Pages-Next-Step?node-id=1040%3A104`
    playgroundLink=`/play/community/aroundweb`
  />
  <TitleHeading.Large title=content.title pageDescription=content.pageDescription />
  <div className="bg-orangedark mb-16">
    <div className="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
      <h2 className="text-3xl font-extrabold text-white sm:text-4xl">
        <span className="block"> {s(content.engageHeader)} </span>
      </h2>
      <p className="mt-4 text-lg leading-6 text-white"> {s(content.engageBody)} </p>
      <a
        className="mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md bg-white hover:bg-orangelight sm:w-auto"
        href="https://discuss.ocaml.org"
        target="_blank">
        {s(content.engageButtonText)}
      </a>
    </div>
  </div>
  <LatestNews />
  <div className="pt-16 pb-3 px-4 sm:px-6 lg:pt-24 lg:pb-8 lg:px-8">
    <div className="max-w-7xl mx-auto">
      <div className="text-center">
        <h2 className="text-3xl tracking-tight font-extrabold text-gray-900 sm:text-4xl">
          {s(content.blogSectionHeader)}
        </h2>
        <p className="mt-3 max-w-2xl mx-auto text-xl text-gray-500 sm:mt-4">
          {s(content.blogSectionDescription)}
        </p>
      </div>
      <div className="mt-12 max-w-lg mx-auto grid gap-5 lg:grid-cols-3 lg:max-w-none">
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1496128858413-b36217c2ce36?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[0].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[0].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[0].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[0].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[0].dateValue>
                    {s(content.blogEntries[0].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[0].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1547586696-ea22b4d4235d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[1].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[1].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[1].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[1].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[1].dateValue>
                    {s(content.blogEntries[1].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[1].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="flex flex-col rounded-lg shadow-lg overflow-hidden">
          <div className="flex-shrink-0">
            <img
              className="h-48 w-full object-cover"
              src="https://images.unsplash.com/photo-1492724441997-5dc865305da7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1679&q=80"
              alt=""
            />
          </div>
          <div className="flex-1 bg-white p-6 flex flex-col justify-between">
            <div className="flex-1">
              <p className="text-sm font-medium text-orangedark">
                <a href="#" className="hover:underline"> {s(content.blog)} </a>
              </p>
              <a href="#" className="block mt-2">
                <h3 className="text-xl font-semibold text-gray-900">
                  {s(content.blogEntries[2].title)}
                </h3>
                <p className="mt-3 text-base text-gray-500">
                  {s(content.blogEntries[2].excerpt)}
                </p>
              </a>
            </div>
            <div className="mt-6 flex items-center">
              <div className="flex-shrink-0">
                <a href="#">
                  <span className="sr-only"> {s(content.blogEntries[2].author)} </span>
                  <img
                    className="h-10 w-10 rounded-full"
                    src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                    alt=""
                  />
                </a>
              </div>
              <div className="ml-3">
                <p className="text-sm font-medium text-gray-900">
                  <a href="#" className="hover:underline"> {s(content.blogEntries[2].author)} </a>
                </p>
                <div className="flex space-x-1 text-sm text-gray-500">
                  <time dateTime=content.blogEntries[2].date>
                    {s(content.blogEntries[2].date)}
                  </time>
                  <span ariaHidden=true> {s(`·`)} </span>
                  <span> {s(content.blogEntries[2].readingTime ++ ` min read`)} </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <p className="mt-5 text-right">
        <a className="font-semibold text-orangedark" href="#">
          {s(content.blogArchiveText ++ ` >`)}
        </a>
      </p>
    </div>
  </div>
  <div className="max-w-7xl mx-auto pb-14">
    <h2
      className="text-center text-3xl tracking-tight font-extrabold text-gray-900 sm:text-4xl py-6 px-4 sm:py-12 sm:px-6 lg:px-8">
      {s(content.spacesSectionHeader)}
    </h2>
    <div className="mx-auto max-w-4xl px-12">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[0])}
        </a>
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[1])}
        </a>
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[2])}
        </a>
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[3])}
        </a>
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[4])}
        </a>
        <a className="block text-center bg-white shadow overflow-hidden rounded-md px-36 py-4">
          {s(content.spaces[5])}
        </a>
      </div>
    </div>
  </div>
</>

let getStaticProps = _ctx => {
  let contentPath = "res_pages/community/aroundweb.yaml"
  let fileContents = Fs.readFileSync(contentPath)
  let jsonRes = JsYaml.load(fileContents, ())
  let dict = Js.Option.getExn(Js.Json.decodeObject(jsonRes))
  let jsonArr = Js.Option.getExn(Js.Json.decodeArray(Js.Dict.unsafeGet(dict, "spaces")))
  let spaces = Js.Array.map(o => {
    Js.Option.getExn(Js.Json.decodeString(o))
  }, jsonArr)

  let contentEn = {
    title: `OCaml Around the Web`,
    pageDescription: `Looking to interact with people who are also interested in OCaml? Find out about upcoming events, read up on blogs from the community, sign up for OCaml mailing lists, and discover even more places to engage with people from the community!`,
    engageHeader: `Want to engage with the OCaml Community?`,
    engageBody: `Participate in discussions on everything OCaml over at discuss.ocaml.org, where members of the community post`,
    engageButtonText: `Take me to Discuss`,
    blogSectionHeader: `Recent Blog Posts`,
    blogSectionDescription: `Be inspired by the work of OCaml programmers all over the world and stay up-to-date on the latest developments.`,
    blog: `Blog`,
    blogEntries: [
      {
        title: `What I learned Coding from Home`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Roel Aufderehar`,
        dateValue: `2020-03-16`,
        date: `Mar 16, 2020`,
        readingTime: `6`,
      },
      {
        title: `Programming for a Better World`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Roel Aufderehar`,
        dateValue: `2020-03-16`,
        date: `Mar 16, 2020`,
        readingTime: `6`,
      },
      {
        title: `Methods for Irmin V2`,
        excerpt: `Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto accusantium praesentium eius, 
          ut atque fuga culpa, similique sequi cum eos quis dolorum.`,
        author: `Daniela Metz`,
        dateValue: `2020-02-12`,
        date: `Feb 12, 2020`,
        readingTime: `11`,
      },
    ],
    blogArchiveText: `Go to the blog archive`,
    spacesSectionHeader: `Looking for More? Try these spaces:`,
    spaces: spaces,
  }

  {
    "props": {content: contentEn},
  }
}

let default = make
