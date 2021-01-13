let s = React.string

let default = () =>
  <>
  <h1>{s(`Caml Light - FAQ`)}</h1>
    <h2>{s(`Is it possible to get error message in my own language?`)}</h2>
      <p>
        {s(`You can choose the language that Caml Light uses to write its messages. For this:`)}
        <ul>
          <li>
            {s(`under Unix: define the `)}
            <code>{s(`LANG`)}</code>
            {s(` environment variable, or call the Caml Light system with option `)}
            <code>{s(`-lang`)}</code>
            {s(`.`)}
          </li>
          <li>
            {s(`under Windows use the `)}
            <code>{s(`-lang`)}</code>
            {s(` option on the command line, or in the `)}
            <code>{s(`CAMLWIN.INI`)}</code>
            {s(` file.`)}
          </li>
          <li>
            {s(`with a Macintosh, edit the resource of the Caml application.`)}
          </li>
        </ul>
        {s(`Language currently available are:`)}
        <ul>
          <li>
            <code>{s(`fr`)}</code>{s(`: french.`)}
            <code>{s(`es`)}</code>{s(`: spanish.`)}
            <code>{s(`de`)}</code>{s(`: german.`)}
            <code>{s(`it`)}</code>{s(`: italian.`)}
            <code>{s(`src`)}</code>{s(`: english.`)}
          </li>
        </ul>
        {s(`English is the default language for messages that cannot be translated. If your language 
        is not yet available, and if you want to translate Caml Light messages (about 50 messages), 
        you're welcome to contact the Caml team (mail to caml-light@inria.fr).`)}
      </p>
  </>
