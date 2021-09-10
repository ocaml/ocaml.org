open! Import

module Entry = {
  type t = {
    title: string,
    excerpt: string,
    author: string,
    dateValue: string,
    date: string,
    readingTime: string,
  }
}

@react.component
let make = (~header, ~description, ~blog, ~entries: array<Entry.t>, ~archiveText) =>
  <SectionContainer.LargeCentered
    paddingY="pt-16 pb-3 lg:pt-24 lg:pb-8" paddingX="px-4 sm:px-6 lg:px-8">
    <div className="text-center">
      <h2 className="text-3xl tracking-tight font-extrabold text-gray-900 sm:text-4xl">
        {React.string(header)}
      </h2>
      <p className="mt-3 max-w-2xl mx-auto text-xl text-gray-500 sm:mt-4">
        {React.string(description)}
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
              <a href="#" className="hover:underline"> {React.string(blog)} </a>
            </p>
            <a href="#" className="block mt-2">
              <h3 className="text-xl font-semibold text-gray-900">
                {React.string(entries[0].title)}
              </h3>
              <p className="mt-3 text-base text-gray-500"> {React.string(entries[0].excerpt)} </p>
            </a>
          </div>
          <div className="mt-6 flex items-center">
            <div className="flex-shrink-0">
              <a href="#">
                <span className="sr-only"> {React.string(entries[0].author)} </span>
                <img
                  className="h-10 w-10 rounded-full"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
              </a>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-900">
                <a href="#" className="hover:underline"> {React.string(entries[0].author)} </a>
              </p>
              <div className="flex space-x-1 text-sm text-gray-500">
                <time dateTime=entries[0].dateValue> {React.string(entries[0].date)} </time>
                <span ariaHidden=true> {React.string(`·`)} </span>
                <span> {React.string(entries[0].readingTime ++ ` min read`)} </span>
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
              <a href="#" className="hover:underline"> {React.string(blog)} </a>
            </p>
            <a href="#" className="block mt-2">
              <h3 className="text-xl font-semibold text-gray-900">
                {React.string(entries[1].title)}
              </h3>
              <p className="mt-3 text-base text-gray-500"> {React.string(entries[1].excerpt)} </p>
            </a>
          </div>
          <div className="mt-6 flex items-center">
            <div className="flex-shrink-0">
              <a href="#">
                <span className="sr-only"> {React.string(entries[1].author)} </span>
                <img
                  className="h-10 w-10 rounded-full"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
              </a>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-900">
                <a href="#" className="hover:underline"> {React.string(entries[1].author)} </a>
              </p>
              <div className="flex space-x-1 text-sm text-gray-500">
                <time dateTime=entries[1].dateValue> {React.string(entries[1].date)} </time>
                <span ariaHidden=true> {React.string(`·`)} </span>
                <span> {React.string(entries[1].readingTime ++ ` min read`)} </span>
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
              <a href="#" className="hover:underline"> {React.string(blog)} </a>
            </p>
            <a href="#" className="block mt-2">
              <h3 className="text-xl font-semibold text-gray-900">
                {React.string(entries[2].title)}
              </h3>
              <p className="mt-3 text-base text-gray-500"> {React.string(entries[2].excerpt)} </p>
            </a>
          </div>
          <div className="mt-6 flex items-center">
            <div className="flex-shrink-0">
              <a href="#">
                <span className="sr-only"> {React.string(entries[2].author)} </span>
                <img
                  className="h-10 w-10 rounded-full"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixqx=aimuGJ4P9C&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
              </a>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-900">
                <a href="#" className="hover:underline"> {React.string(entries[2].author)} </a>
              </p>
              <div className="flex space-x-1 text-sm text-gray-500">
                <time dateTime=entries[2].date> {React.string(entries[2].date)} </time>
                <span ariaHidden=true> {React.string(`·`)} </span>
                <span> {React.string(entries[2].readingTime ++ ` min read`)} </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <p className="mt-5 text-right">
      <a className="font-semibold text-orangedark" href="#">
        {React.string(archiveText ++ ` >`)}
      </a>
    </p>
  </SectionContainer.LargeCentered>
