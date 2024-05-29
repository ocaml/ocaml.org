---
title: 'wxOCaml, camlidl and Class Modules  '
description: "Last week, I was bored doing some paperwork, so I decided to hack a
  little to relieve my mind... Looking for a GUI Framework for OCaml Beginners Some
  time ago, at OCamlPro, we had discussed the fact that OCaml was lacking more GUI
  frameworks. Lablgtk is powerful, but I don\u2019t like it (and I expect ..."
url: https://ocamlpro.com/blog/2013_04_02_wxocaml_camlidl_and_class_modules
date: 2013-04-02T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Last week, I was bored doing some paperwork, so I decided to hack a little to relieve my mind...</p>
<h2>Looking for a GUI Framework for OCaml Beginners</h2>
<p>Some time ago, at OCamlPro, we had discussed the fact that OCaml was lacking more GUI frameworks. Lablgtk is powerful, but I don&rsquo;t like it (and I expect that some other people in the OCaml community share my opinion) for several reasons:</p>
<ul>
<li>LablGTK makes an extensive use of objects, labels and polymorphic variants. Although using these advanced features of OCaml can help expert OCaml developers, it makes LablGTK hard to use for beginners&hellip; and a good reason to have better GUIs is actually to attract beginners!
</li>
<li>GTK does not look native under Windows and Mac OS X, giving an outdated feeling about interfaces written with it.
</li>
</ul>
<p>Now, the question was, which GUI framework to support for OCaml ? A long time ago, I had heard that <a href="http://www.wxwidgets.org/">wxWidgets</a> (formerly wxWindows) had contributed to the popularity of Python at some point, and I remembered that there was a binding called <a href="http://plus.kaist.ac.kr/~shoh/ocaml/wxcaml/doc/">wxCaml</a> that had been started by SooHyoung Oh a few years ago. I had managed to compile it a two years ago, but not to make the examples work, so I decided it was worth another try.</p>
<h2>From wxEiffel to wxCaml, through wxHaskell</h2>
<p>wxCaml is based on <a href="http://www.haskell.org/haskellwiki/WxHaskell">wxHaskell</a>, itself based on <a href="http://elj.sourceforge.net/projects/gui/ewxw/">wxEiffel</a>, a binding for wxWidgets done for the Eiffel programming language. Since wxWidgets is written in C++, and most high-level programming languages only support bindings to C functions, the wxEiffel developers wrote a first binding from C++ to C, called the <a href="https://github.com/OCamlPro/wxOCaml/tree/master/elj">ELJ library</a>: for each class wxCLASS of wxWidgets, and for each method Method of that class, they wrote a function wxCLASS_Method, that takes the object as first argument, the other arguments of the method, and then call the method on the first argument, with the other arguments. For example, the code for the <a href="https://github.com/OCamlPro/wxOCaml/blob/master/elj/eljwindow.cpp">wxWindow</a> looks a lot like that:</p>
<pre><code class="language-cpp">EWXWEXPORT(bool,wxWindow_Close)(wxWindow* self,bool _force)
{
    return self-&gt;Close(_force);
}
</code></pre>
<p>From what I understood, they stopped maintaining this library, so the wxHaskell developers took the code and maintained it for wxHaskell. In wxHaskell, a few include files describe all these C functions. Then, they use a program &lsquo;wxc&rsquo; that generates Haskell stubs for all these functions, in a class hierarchy.</p>
<p>In the first version of wxCaml, <a href="http://forge.ocamlcore.org/projects/camlidl/">camlidl</a> was used to generate OCaml stubs from these header files. The header files had to be modified a little, for two reasons:</p>
<ul>
<li>They are actually not correct: some parts of these header files have not been updated to match the evolution of wxWidgets API. Some of the classes for which they describe stubs does not exist anymore. The tool used by wxHaskell filters out these classes, because their names are hardcoded in its code, but camlidl cannot.
</li>
<li>camlidl needs to know more information than just what is written in C header files. It needs some attributes on types and arguments, like the fact that a char pointer is actually a string, or that a pointer argument to a function is used to return a value. See <a href="https://github.com/OCamlPro/wxOCaml/blob/master/idl/wxc_types.idl">wxc_types.idl</a> for macros to automate parts of this step.
</li>
<li>camlidl was not used a lot, and not maintained for a long time, so there are some bugs in it. For example, the names of the arguments given in IDL header files can conflict with variables generated in C by camlidl (such as &ldquo;_res&rdquo;) or with types of the caml C API (such as &ldquo;value&rdquo;).
</li>
</ul>
<p>Since the version of wxCaml I downloaded used outdated versions of wxWidgets (wxWindows 2.4.2 when current version is wxWidgets 2.9) and wxHaskell (0.7 when current version is 0.11), I decided to upgrade wxCaml to the current versions. I copied the ELJ library and the header files from the GitHub repository of wxHaskell. Unfortunately, the corresponding wxWidgets version is 2.9.4, which is not yet officially distributed by mainstream Linux distributions, so I had to compile it also.</p>
<p>After the painful work of fixing the new header files for camlidl, I was able to run a few examples of wxCaml. But I was not completely satisfied with it:</p>
<ul>
<li>To translate the relation of inheritance between classes for camlidl, wxCaml makes them equivalent, so that the child can be used where the ancestor can be used. Unfortunately, it means also that the ancestor can be used wherever the child would, and since most classes are descendant of wxObject, they can all be used in place of each other in the OCaml code !
</li>
<li>A typed version of the interface had been started, but it was already making heavy use of objects, which I had decided to ban from the new version, as other advanced features of OCaml.
</li>
</ul>
<h2>wxCamlidl, modifying camlidl for wxOCaml</h2>
<p>So, I decided to write a new typed interface, where each class would be translated into an abstract type, a module containing its methods as functions, and a few cast functions, from children to ancestors.</p>
<p>I wrote just what was needed to make two simple examples work (<a href="https://github.com/OCamlPro/wxOCaml/blob/master/examples/hello_world/hello.ml">hello_world</a> and <a href="https://github.com/OCamlPro/wxOCaml/blob/master/examples/two_panels/two_panels.ml">two_panels</a>, from wxWidgets tutorials), I was happy with the result:</p>
<p><a href="https://github.com/OCamlPro/wxOCaml/blob/master/examples/hello_world/hello.ml"><img src="http://ocamlpro.com//files/wxOCaml-screenshot-hello.png" alt="wxOCaml-screenshot-hello.png"/></a></p>
<p><a href="https://github.com/OCamlPro/wxOCaml/blob/master/examples/two_panels/two_panels.ml"><img src="http://ocamlpro.com//files/wxOCaml-screenshot-panels.png" alt="wxOCaml-screenshot-panels.png"/></a></p>
<p>But writting by hand the complete interface for all classes and methods would not be possible, so I decided it was time to write a tool for that task.</p>
<p>My first attempt at automating the generation of the typed interface failed because the basic tool I wrote didn&rsquo;t have enough information to correctly do the task: sometimes, methods would be inherited by a class from an ancestor, without noticing that the descendant had its own implementation of the method. Moreover, I didn&rsquo;t like the fact that camlidl would write all the stubs into a single file, and my tool into another file, making any small wxOCaml application links itself with these two huge modules and the complete ELJ library, even if it would use only a few of its classes.</p>
<p>As a consequence, I decided that the best spot to generate a modular and typed interface would be camlidl itself. I got a copy of its sources, and created a <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxCamlidl/wxmore.ml">new module in it</a>, using the symbolic IDL representation to generate the typed version, instead of the untyped version. The module would compute the hierarchy of classes, to be able to propagate statically methods from ancestors to children, and to generate cast functions from children to ancestors.</p>
<p>A first generated module, called <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxClasses.mli">WxClasses</a> defines all the wxWidgets classes as abstract types:</p>
<pre><code class="language-ocaml">type eLJDragDataObject  
and eLJMessageParameters  
&hellip;  
and wxDocument  
and wxFrameLayout  
and wxMenu  
and wxMenuBar  
and wxProcess  
and &hellip;  
</code></pre>
<p>Types started by &ldquo;eLJ&hellip;&rdquo; are classes defined in the ELJ library for wxWidgets classes where methods have to be defined to override basic behaviors.</p>
<h2>Classes as modules</h2>
<p>For each wxWidget class, a specific module is created with:</p>
<ul>
<li>the constructor function, usually called &ldquo;wxnew&rdquo;
</li>
<li>the methods of the class, and the methods of the ancestors
</li>
<li>the cast functions to ancestors
</li>
</ul>
<p>For example, for the <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxFrame.ml">WxFrame</a> module, the tool generates <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxFrame.mli">this signature</a>:</p>
<pre><code class="language-ocaml">open WxClasses

external wxnew : (* constructor *)  
wxWindow -&gt; int -&gt; wxString -&gt; int -&gt; int -&gt; int -&gt; int -&gt; int  
-&gt; wxFrame  
= &ldquo;camlidl_wxc_idl_wxFrame_Create_bytecode&rdquo;  
&hellip; (* direct methods *)  
external setToolBar : wxFrame -&gt; wxToolBar -&gt; unit  
= &ldquo;camlidl_wxc_idl_wxFrame_SetToolBar&rdquo;  
&hellip; (* inherited methods *)  
external setToolTip : wxFrame -&gt; wxString -&gt; unit  
= &ldquo;camlidl_wxc_idl_wxWindow_SetToolTip&rdquo;  
&hellip;  
(* string wrappers *)  
val wxnew : wxWindow -&gt; int -&gt; string -&gt; int -&gt; int -&gt; int -&gt; int -&gt; int -&gt; wxFr  
ame  
val setToolTip : wxFrame -&gt; string -&gt; unit  
&hellip;  
val ptrNULL : wxFrame (* a NULL pointer *)  
&hellip;  
external wxWindow : wxFrame -&gt; wxWindow = &ldquo;%identity&rdquo; (* cast function *)  
&hellip;  
</code></pre>
<p>In this example, we can see that:</p>
<ul>
<li>WxFrame first defines the constructor for wxFrame objects. The constructor is later refined, because the stub makes use of wxString arguments, for which the tool creates a wrapper to use OCaml strings instead (using WxString.createUTF8 before the stub and WxString.delete after the stub).
</li>
<li>Stubs are then created for direct methods, i.e. functions corresponding to new methods of the class wxFrame. String wrappers are also produced if necessary.
</li>
<li>Stubs are also created for inherited methods. Here, &ldquo;setToolTip&rdquo; is a method of the class wxWindow (thus, its stub name wxWindow_SetToolTip). Normally, this function is in the WxWindow module, and takes a wxWindow as first argument. But to avoid the need for a cast from wxFrame to wxWindow to use it, we define it again here, allowing a wxFrame directly as first argument.
</li>
<li>The module also defines a ptrNULL value that can be used wherever a NULL pointer is expected instead of an object of the class.
</li>
<li>Finally, functions like &ldquo;wxWindow&rdquo; are cast functions from children to ancestor, allowing to use a value of type wxFrame wherever a value of type wxWindow is expected.
</li>
</ul>
<p>All functions that could not be put in such files are gathered in a module <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxMisc.mli">WxMisc</a>. Finally, the tool also generates a module <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxWidgets.mli">WxWidgets</a> containing a copy of all constructors with simpler names:</p>
<pre><code class="language-ocaml">&hellip;  
val wxFrame : wxWindow -&gt; int -&gt; string -&gt; int -&gt; int -&gt; int -&gt; int -&gt; int -&gt; wxFrame  
val wxFontMapper : unit -&gt; wxFontMapper  
&hellip;  
</code></pre>
<p>and functions to ignore the results of functions:</p>
<pre><code class="language-ocaml">&hellip;  
external ignore_wxFontMapper : wxFontMapper -&gt; unit = &ldquo;%ignore&rdquo;  
external ignore_wxFrame : wxFrame -&gt; unit = &ldquo;%ignore&rdquo;  
&hellip;  
</code></pre>
<p>We expect wxOCaml applications to just start with &ldquo;open WxWidgets&rdquo; to get access to these constructors, to use functions prefixed by the class module names, and to use constants from the <a href="https://github.com/OCamlPro/wxOCaml/blob/master/wxWidgets/wxdefs.ml">Wxdefs module</a>.</p>
<p>Here is how the minimal application looks like:</p>
<pre><code class="language-ocaml">open WxWidgets  
let _ =  
let onInit event =  
let frame_id = wxID () in  
let quit_id = wxID() in  
let about_id = wxID() in

(* Create toplevel frame *)  
let frame = wxFrame WxWindow.ptrNULL frame_id &ldquo;Hello World&rdquo;  
50 50 450 350 Wxdefs.wxDEFAULT_FRAME_STYLE in  
WxFrame.setStatusText frame &ldquo;Welcome to wxWidgets!&rdquo; 0;

(* Create a menu *)  
let menuFile = wxMenu &ldquo;&rdquo; 0 in  
WxMenu.append menuFile about_id &ldquo;About&rdquo; &ldquo;About the application&rdquo; false;  
WxMenu.appendSeparator menuFile;  
WxMenu.append menuFile quit_id &ldquo;Exit&rdquo; &ldquo;Exit from the application&rdquo; false;

(* Add the menu to the frame menubar *)  
let menuBar = wxMenuBar 0 in  
ignore_int (WxMenuBar.append menuBar menuFile &ldquo;&amp;File&rdquo;);  
WxFrame.setMenuBar frame menuBar;  
ignore_wxStatusBar (WxFrame.createStatusBar frame 1 0);

(* Handler for QUIT menu *)  
WxFrame.connect frame quit_id Wxdefs.wxEVT_COMMAND_MENU_SELECTED  
(fun _ -&gt; exit 0);

(* Handler for ABOUT menu *)  
WxFrame.connect frame about_id Wxdefs.wxEVT_COMMAND_MENU_SELECTED  
(fun _ -&gt;  
ignore_int (  
WxMisc.wxcMessageBox &ldquo;wxWidgets Hello World example.&rdquo;  
&ldquo;About Hello World&rdquo;  
(Wxdefs.wxOK lor Wxdefs.wxICON_INFORMATION)  
(WxFrame.wxWindow frame)  
Wxdefs.wxDefaultCoord  
Wxdefs.wxDefaultCoord  
)  
);

(* Display the frame *)  
ignore_bool ( WxFrame.show frame );  
ELJApp.setTopWindow (WxFrame.wxWindow frame)  
in  
WxMain.main onInit (* Main WxWidget loop starting the app *)  
</code></pre>
<h2>Testers welcome</h2>
<p>The current code can be downloaded from our <a href="http://github.com/OCamlPro/wxOCaml">repository on GitHub</a>. It should work with wxWidgets 2.9.4, and the latest version of ocp-build (1.99-beta5).</p>
<p>Of course, as I never wrote an application with wxWidgets before, I could only write a few examples, so I would really appreciate any feedback given by beta testers, especially as there might be errors in the translation to IDL, that make important functions impossible to use, that I cannot detect by myself.</p>
<p>I am also particularly interested by feedback on the use of modules for classes, to see if the corresponding style is usable. Our current feeling is that it is more verbose than a purely object-oriented style, but it is simpler for beginners, and improves the readability of code.</p>
<p>Finally, it was a short two-day hack, so it is far from finished. Especially, after hacking wxCamlidl, and looking at the code of the ELJ library, I had the feeling that we could go directly from the C++ header files, or something equivalent, to produce not only the OCaml stubs and the typed interface, but also the C++ to C bindings, and get rid completely of the ELJ library.</p>

