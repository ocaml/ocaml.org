---
title: What do you mean ExceptT doesn't Compose?
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/what_do_you_mean.html
date: 2017-04-30T02:22:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Disclaimer: I work at Ambiata (our
	<a href="https://github.com/ambiata/">Github</a>
presence) probably the biggest Haskell shop in the southern hemisphere.
Although I mention some of Ambiata's coding practices, in this blog post I am
speaking for myself and not for Ambiata.
However, the way I'm using <b><tt>ExceptT</tt></b> and handling exceptions in
this post is something I learned from my colleagues at Ambiata.
</p>

<p>
At work, I've been spending some time tracking down exceptions in some of our
Haskell code that have been bubbling up to the top level an killing a complex
multi-threaded program.
On Friday I posted a somewhat flippant comment to
	<a href="https://plus.google.com/+ErikdeCastroLopo/posts/TbRiXuNucED">Google Plus</a>:
</p>

<blockquote>
Using exceptions for control flow is the root of many evils in software.&iuml;&raquo;&iquest;
</blockquote>

<p>
Lennart Kolmodin who I remember from my very earliest days of using Haskell in
2008 and who I met for the first time at ICFP in Copenhagen in 2011 responded:
</p>

<blockquote>
Yet what to do if you want composable code? Currently I have<br/>
type Rpc a = ExceptT RpcError IO a<br/>
which is terrible
</blockquote>

<p>
But what do we mean by &quot;composable&quot;?
I like the
	<a href="https://en.wikipedia.org/wiki/Composability">wikipedia</a>
definition:
</p>

<blockquote>
&iuml;&raquo;&iquest;Composability is a system design principle that deals with the inter-relationships
of components. A highly composable system provides recombinant components that
can be selected and assembled in various combinations to satisfy specific user
requirements.
</blockquote>

<p>
The ensuing discussion, which also included Sean Leather, suggested that these
two experienced Haskellers were not aware that with the help of some combinator
functions, <b><tt>ExceptT</tt></b> composes very nicely and results in more
readable and more reliable code.
</p>

<p>
At Ambiata, our coding guidelines strongly discourage the use of partial
functions.
Since the type signature of a function doesn't include information about the
exceptions it might throw, the use of exceptions is strongly discouraged.
When using library functions that may throw exceptions, we try to catch those
exceptions as close as possible to their source and turn them into
errors that are explicit in the type signatures of the code we write.
Finally, we avoid using <b><tt>String</tt></b> to hold errors.
Instead we construct data types to carry error messages and render functions
to convert them to <b><tt>Text</tt></b>.
</p>

<p>
In order to properly demonstrate the ideas, I've written some demo code and
made it available in
	<a href="https://github.com/erikd/exceptT-demo">this GitHub repo</a>.
It compiles and even runs (providing you give it the required number of command
line arguments) and hopefully does a good job demonstrating how the bits fit
together.
</p>

<p>
So lets look at the naive version of a program that doesn't do any exception
handling at all.
</p>

<pre class="code">

  import Data.ByteString.Char8 (readFile, writeFile)

  import Naive.Cat (Cat, parseCat)
  import Naive.Db (Result, processWithDb, renderResult, withDatabaseConnection)
  import Naive.Dog (Dog, parseDog)

  import Prelude hiding (readFile, writeFile)

  import System.Environment (getArgs)
  import System.Exit (exitFailure)

  main :: IO ()
  main = do
    args &lt;- getArgs
    case args of
      [inFile1, infile2, outFile] -&gt; processFiles inFile1 infile2 outFile
      _ -&gt; putStrLn &quot;Expected three file names.&quot; &gt;&gt; exitFailure

  readCatFile :: FilePath -&gt; IO Cat
  readCatFile fpath = do
    putStrLn &quot;Reading Cat file.&quot;
    parseCat &lt;$&gt; readFile fpath

  readDogFile :: FilePath -&gt; IO Dog
  readDogFile fpath = do
    putStrLn &quot;Reading Dog file.&quot;
    parseDog &lt;$&gt; readFile fpath

  writeResultFile :: FilePath -&gt; Result -&gt; IO ()
  writeResultFile fpath result = do
    putStrLn &quot;Writing Result file.&quot;
    writeFile fpath $ renderResult result

  processFiles :: FilePath -&gt; FilePath -&gt; FilePath -&gt; IO ()
  processFiles infile1 infile2 outfile = do
    cat &lt;- readCatFile infile1
    dog &lt;- readDogFile infile2
    result &lt;- withDatabaseConnection $ \ db -&gt;
                 processWithDb db cat dog
    writeResultFile outfile result

</pre>

<p>
Once built as per the instructions in the repo, it can be run with:
</p>

<pre class="code">

  dist/build/improved/improved Naive/Cat.hs Naive/Dog.hs /dev/null
  Reading Cat file 'Naive/Cat.hs'
  Reading Dog file 'Naive/Dog.hs'.
  Writing Result file '/dev/null'.

</pre>


<p>
The above code is pretty naive and there is zero indication of what can and
cannot fail or how it can fail.
Here's a list of some of the obvious failures that may result in an exception
being thrown:
</p>

<ul>
<li>Either of the two <b><tt>readFile</tt></b> calls.</li>
<li>The <b><tt>writeFile</tt></b> call.</li>
<li>The parsing functions <b><tt>parseCat</tt></b> and
	<b><tt>parseDog</tt></b>.</li>
<li>Opening the database connection.</li>
<li>The database connection could terminate during the processing stage.</li>
</ul>

<p>
So lets see how the use of the standard <b><tt>Either</tt></b> type,
<b><tt>ExceptT</tt></b> from the <b><tt>transformers</tt></b> package and
combinators from Gabriel Gonzales' <b><tt>errors</tt></b> package can improve
things.
</p>

<p>
Firstly the types of <b><tt>parseCat</tt></b> and <b><tt>parseDog</tt></b> were
ridiculous.
Parsers can fail with parse errors, so these should both return an
<b><tt>Either</tt></b> type.
Just about everything else should be in the <b><tt>ExceptT e IO</tt></b>
monad.
Lets see what that looks like:
</p>

<pre class="code">

  {-# LANGUAGE OverloadedStrings #-}
  import           Control.Exception (SomeException)
  import           Control.Monad.IO.Class (liftIO)
  import           Control.Error (ExceptT, fmapL, fmapLT, handleExceptT
                                 , hoistEither, runExceptT)

  import           Data.ByteString.Char8 (readFile, writeFile)
  import           Data.Monoid ((&lt;&gt;))
  import           Data.Text (Text)
  import qualified Data.Text as T
  import qualified Data.Text.IO as T

  import           Improved.Cat (Cat, CatParseError, parseCat, renderCatParseError)
  import           Improved.Db (DbError, Result, processWithDb, renderDbError
                               , renderResult, withDatabaseConnection)
  import           Improved.Dog (Dog, DogParseError, parseDog, renderDogParseError)

  import           Prelude hiding (readFile, writeFile)

  import           System.Environment (getArgs)
  import           System.Exit (exitFailure)

  data ProcessError
    = ECat CatParseError
    | EDog DogParseError
    | EReadFile FilePath Text
    | EWriteFile FilePath Text
    | EDb DbError

  main :: IO ()
  main = do
    args &lt;- getArgs
    case args of
      [inFile1, infile2, outFile] -&gt;
              report =&lt;&lt; runExceptT (processFiles inFile1 infile2 outFile)
      _ -&gt; do
          putStrLn &quot;Expected three file names, the first two are input, the last output.&quot;
          exitFailure

  report :: Either ProcessError () -&gt; IO ()
  report (Right _) = pure ()
  report (Left e) = T.putStrLn $ renderProcessError e


  renderProcessError :: ProcessError -&gt; Text
  renderProcessError pe =
    case pe of
      ECat ec -&gt; renderCatParseError ec
      EDog ed -&gt; renderDogParseError ed
      EReadFile fpath msg -&gt; &quot;Error reading '&quot; &lt;&gt; T.pack fpath &lt;&gt; &quot;' : &quot; &lt;&gt; msg
      EWriteFile fpath msg -&gt; &quot;Error writing '&quot; &lt;&gt; T.pack fpath &lt;&gt; &quot;' : &quot; &lt;&gt; msg
      EDb dbe -&gt; renderDbError dbe


  readCatFile :: FilePath -&gt; ExceptT ProcessError IO Cat
  readCatFile fpath = do
    liftIO $ putStrLn &quot;Reading Cat file.&quot;
    bs &lt;- handleExceptT handler $ readFile fpath
    hoistEither . fmapL ECat $ parseCat bs
    where
      handler :: SomeException -&gt; ProcessError
      handler e = EReadFile fpath (T.pack $ show e)

  readDogFile :: FilePath -&gt; ExceptT ProcessError IO Dog
  readDogFile fpath = do
    liftIO $ putStrLn &quot;Reading Dog file.&quot;
    bs &lt;- handleExceptT handler $ readFile fpath
    hoistEither . fmapL EDog $ parseDog bs
    where
      handler :: SomeException -&gt; ProcessError
      handler e = EReadFile fpath (T.pack $ show e)

  writeResultFile :: FilePath -&gt; Result -&gt; ExceptT ProcessError IO ()
  writeResultFile fpath result = do
    liftIO $ putStrLn &quot;Writing Result file.&quot;
    handleExceptT handler . writeFile fpath $ renderResult result
    where
      handler :: SomeException -&gt; ProcessError
      handler e = EWriteFile fpath (T.pack $ show e)

  processFiles :: FilePath -&gt; FilePath -&gt; FilePath -&gt; ExceptT ProcessError IO ()
  processFiles infile1 infile2 outfile = do
    cat &lt;- readCatFile infile1
    dog &lt;- readDogFile infile2
    result &lt;- fmapLT EDb . withDatabaseConnection $ \ db -&gt;
                 processWithDb db cat dog
    writeResultFile outfile result

</pre>

<p>
The first thing to notice is that changes to the structure of the main
processing function <b><tt>processFiles</tt></b> are minor but <i>all</i> errors
are now handled explicitly.
In addition, all possible exceptions are caught as close as possible to the
source and turned into errors that are explicit in the function return types.
Sceptical?
Try replacing one of the  <b><tt>readFile</tt></b> calls with an
<b><tt>error</tt></b> call or a <b><tt>throw</tt></b> and see it get caught
and turned into an error as specified by the type of the function.
</p>

<p>
We also see that despite having many different error types (which happens when
code is split up into many packages and modules), a constructor for an error
type higher in the stack can encapsulate error types lower in the stack.
For example, this value of type <b><tt>ProcessError</tt></b>:
</p>

<pre class="code">

  EDb (DbError3 ResultError1)

</pre>

<p>
contains a <b><tt>DbError</tt></b> which in turn contains a
<b><tt>ResultError</tt></b>.
Nesting error types like this aids composition, as does the separation of error
rendering (turning an error data type into text to be printed) from printing.
</p>

<p>
We also see that with the use of combinators like
	<a href="https://hackage.haskell.org/package/errors-2.2.0/docs/Data-EitherR.html#v:fmapLT"><b><tt>fmapLT</tt></b></a>,
and the nested error types of the previous paragraph, means that
<b><tt>ExceptT</tt></b> monad transformers do compose.
</p>

<p>
Using <b><tt>ExceptT</tt></b> with the combinators from the
<b><tt>errors</tt></b> package to catch exceptions as close as possible to their
source and converting them to errors has numerous benefits including:
</p>

<ul>
<li> Errors are explicit in the types of the functions, making the code easier
	to reason about.</li>
<li> Its easier to provide better error messages and more context than what
	is normally provided by the <b><tt>Show</tt></b> instance of most
	exceptions.</li>
<li> The programmer spends less time chasing the source of exceptions in large
	complex code bases.</li>
<li> More robust code, because the programmer is forced to think about and
	write code to handle errors instead of error handling being and optional
	afterthought.
	</li>
</ul>

<p>
Want to discuss this?
Try <a href="https://www.reddit.com/r/haskell/comments/68kyfx/what_do_you_mean_exceptt_doesnt_compose/">reddit</a>.
</p>


