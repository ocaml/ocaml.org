open! Import

module BasicWithIcon = {
  // generalize this type to: { link: string, attributes: 'a } and move it to top level module
  module Item = {
    type t = {
      link: string,
      title: string,
    }
  }

  module RowPrefixIcon = {
    type t = PaperScroll

    let paperScrollIcon = (~display, ~marginRight) =>
      <svg
        className={`${display} ${marginRight}`}
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
  }

  let rightArrow =
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

  let itemRow = (item: Item.t, itemIcon) =>
    // TODO: accessible link; indicate that link opens new tab
    <li className="px-6 py-4" key=item.title>
      <a href=item.link target="_blank">
        <div className="flex justify-between items-center space-x-6">
          <div> itemIcon {React.string(item.title)} </div> rightArrow
        </div>
      </a>
    </li>

  @react.component
  let make = (~items, ~rowPrefixIcon) => {
    let rowPrefixIcon = switch rowPrefixIcon {
    | RowPrefixIcon.PaperScroll => RowPrefixIcon.paperScrollIcon
    }
    <ul className="divide-y divide-gray-300">
      {items
      |> Array.map((item: Item.t) => {
        itemRow(item, rowPrefixIcon(~display="hidden lg:inline-block", ~marginRight="mr-3"))
      })
      |> React.array}
    </ul>
  }
}

module BasicWithAuxiliaryAttribute = {
  module Item = {
    type t = {
      link: string,
      title: string, // TODO: better name than title
      auxiliaryAttribute: string,
    }
  }

  let rightArrow = {React.string(` -> `)}

  let itemRow = (item: Item.t) =>
    // TODO: ensure link is accessible; indicator that link opens tab
    <li className="p-6 cursor-pointer hover:bg-gray-200" key=item.title>
      // TODO: should w-full be passed a parameter?
      // TODO: is it okay to make an "a" tag into a grid??
      // TODO: these items should vertically align to the center of the row
      // TODO: change from grid to flexbox
      <a className="grid grid-cols-9 w-full " href=item.link target="_blank" key=item.title>
        <div className="text-yellow-600 col-span-6 sm:col-span-5 font-semibold">
          {React.string(item.title)}
        </div>
        <div className="text-gray-400 text-sm col-span-2 sm:col-span-3 ml-4">
          {React.string(item.auxiliaryAttribute)}
        </div>
        <div className="text-right"> rightArrow </div>
      </a>
    </li>

  @react.component
  let make = (~items) =>
    // TODO: remove relative?
    // TODO: why aren't these attributes directly on the "ul" below?
    // TODO: why is overflow-y-auto used?
    <div className="rounded-lg shadow overflow-y-auto relative">
      <ul> {items |> Array.map((item: Item.t) => {itemRow(item)}) |> React.array} </ul>
    </div>
}
