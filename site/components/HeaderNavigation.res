module Link = Next.Link;

let s = React.string

type content = {
  industry: NavEntry.t,
  resources: NavEntry.t,
  community: NavEntry.t,
  search: string,
  openMenu: string,
}

@react.component
let make = (~content) =>
  <div className="max-w-7xl mx-auto px-4 sm:px-6">
    <div className="flex justify-between items-center md:justify-start py-6 md:space-x-10 ">
      <div className="flex justify-start  ">
        <a href="/" className="bg-blue-100">
          <img className="h-8 w-auto sm:h-10" src="/static/logo1.jpeg" alt="" />
        </a>
      </div>
      <nav className="hidden md:flex space-x-10 ">
        <span className="text-base font-medium text-gray-500">
          {s(content.industry.label)}
        </span>
        <span className="text-base font-medium text-gray-500">
          {s(content.resources.label)}
        </span>
        <span className="text-base font-medium text-gray-500">
          {s(content.community.label)}
        </span>
      </nav>
      <div className="flex-1 flex items-center justify-center px-2 md:justify-end ">
        <div className="max-w-lg w-full md:max-w-xs">
          <label htmlFor="search" className="sr-only">{s(content.search)}</label>
          <div className="relative">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg className="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" ariaHidden=true>
                <path fillRule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clipRule="evenodd" />
              </svg>
            </div>
            <input id="search" name="search" className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-orangedark focus:border-orangedarker sm:text-sm" placeholder=content.search type_="search" />
          </div>
        </div>
      </div> 
      <div className="-mr-2 -my-2 md:hidden ">
        <button type_="button" className="bg-white rounded-md p-2 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500">
          <span className="sr-only">{s(content.openMenu)}</span>
          <svg className="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" ariaHidden=true>
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>
    </div>
  </div>
