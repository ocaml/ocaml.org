---
title: When iOS Simulator Apps Go AWOL
description:
url: http://psellos.com/2012/11/2012.11.iossim-apps-awol.html
date: 2012-11-15T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">November 15, 2012</div>

<p>I&rsquo;ve just finished work on version 2.0 of <code>runsim</code>, a small shell script
that installs and runs apps in the iOS Simulator.  For this version I
added the ability to start apps in the simulator automatically from the
command line. I also separated out the different functions, so you can
install, uninstall, list, and run apps as separate operations.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ios/iossim-command-line.html"><img src="http://psellos.com/images/psi-p2.png" alt="Psi example app in iOS Simulator"/></a>
</div>

<p>You can read the full details on <a href="http://psellos.com/ios/iossim-command-line.html">Run iOS Simulator from the Command
Line</a>.</p>

<p>You can also download <code>runsim</code> from the following link:</p>

<ul class="rightoffloat">
<li><a href="http://psellos.com/pub/ocamlxsim/runsim">runsim &mdash; run app in iOS Simulator from command line</a></li>
</ul>

<p>Before using it, however, I suggest you read the full description linked
above. There are some complexities in using the automatic start-up
facility that you want to understand beforehand.</p>

<p>The new automatic start-up uses <code>instruments</code>, the command-line version
of the Xcode Instruments tool. While getting it working I had one
persistent problem: Instruments kept reporting that the monitored app
had gone AWOL.  For the benefit of other folks working from the command
line, I&rsquo;ll show how to elicit this legendary error and what I did to
correct it.</p>

<p>To keep the example simple, I&rsquo;ll use <code>Psi</code>, an iOS app I wrote to be be
as small as possible and to require no supporting files.  (Get the
source from <a href="http://psellos.com/2012/05/2012.05.tiny-ios-app.html">Tiny iOS App in One Source File</a>.)</p>

<p>Every app in the Apple universe has an <code>Info.plist</code> file that describes
its basic attributes. The core of the AWOL app problem is that Xcode has
begun to add internal attributes to this file behind the scenes. You can
see why Apple would do things this way, but it makes it a little more
difficult for &ldquo;enthusiasts&rdquo; to do new things with the tools.</p>

<p>Here is an <code>Info.plist</code> file for <code>Psi</code> as it is presented to users of
Xcode:</p>

<pre><code>&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;!DOCTYPE plist PUBLIC &quot;-//Apple//DTD PLIST 1.0//EN&quot; &quot;http://www.apple.com/DTDs/PropertyList-1.0.dtd&quot;&gt;
&lt;plist version=&quot;1.0&quot;&gt;
&lt;dict&gt;
        &lt;key&gt;CFBundleDevelopmentRegion&lt;/key&gt;
        &lt;string&gt;English&lt;/string&gt;
        &lt;key&gt;CFBundleDisplayName&lt;/key&gt;
        &lt;string&gt;Psi&lt;/string&gt;
        &lt;key&gt;CFBundleExecutable&lt;/key&gt;
        &lt;string&gt;Psi&lt;/string&gt;
        &lt;key&gt;CFBundleIconFile&lt;/key&gt;
        &lt;string&gt;Icon.png&lt;/string&gt;
        &lt;key&gt;CFBundleIcons&lt;/key&gt;
        &lt;dict&gt;
                &lt;key&gt;CFBundlePrimaryIcon&lt;/key&gt;
                &lt;dict&gt;
                        &lt;key&gt;CFBundleIconFiles&lt;/key&gt;
                        &lt;array&gt;
                                &lt;string&gt;Icon.png&lt;/string&gt;
                        &lt;/array&gt;
                &lt;/dict&gt;
        &lt;/dict&gt;
        &lt;key&gt;CFBundleIdentifier&lt;/key&gt;
        &lt;string&gt;com.psellos.Psi&lt;/string&gt;
        &lt;key&gt;CFBundleInfoDictionaryVersion&lt;/key&gt;
        &lt;string&gt;6.0&lt;/string&gt;
        &lt;key&gt;CFBundleName&lt;/key&gt;
        &lt;string&gt;Psi&lt;/string&gt;
        &lt;key&gt;CFBundlePackageType&lt;/key&gt;
        &lt;string&gt;APPL&lt;/string&gt;
        &lt;key&gt;CFBundleSignature&lt;/key&gt;
        &lt;string&gt;????&lt;/string&gt;
        &lt;key&gt;CFBundleShortVersionString&lt;/key&gt;
        &lt;string&gt;1.0&lt;/string&gt;
        &lt;key&gt;CFBundleVersion&lt;/key&gt;
        &lt;string&gt;1.0.1&lt;/string&gt;
        &lt;key&gt;UIStatusBarStyle&lt;/key&gt;
        &lt;string&gt;UIStatusBarStyleBlackOpaque&lt;/string&gt;
        &lt;key&gt;LSRequiresIPhoneOS&lt;/key&gt;
        &lt;true/&gt;
&lt;/dict&gt;
&lt;/plist&gt;</code></pre>

<p>If you try to start up <code>Psi</code> with this exact <code>Info.plist</code>, however,
<code>instruments</code> reports that the app has gone AWOL:</p>

<blockquote>
  <p><strong><code>$&nbsp;PSID=&quot;$HOME/Library/Application&nbsp;Support/iPhone&nbsp;Simulator/6.0/Applications/72002825-3566-4EF2-B87B-872836AD29C6/Psi.app&quot;</code></strong> <br/>
  <strong><code>$&nbsp;TRC=/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate</code></strong> <br/>
  <strong><code>$ instruments instruments -t &quot;$TRC&quot; &quot;$PSID&quot;</code></strong> <br/>
  <code>2012-11-15 12:32:51.586 instruments[56628:1207] Automation Instrument ran into an exception while trying to run the script.  UIATargetHasGoneAWOLException</code> <br/>
  <code>2012-11-15 20:32:51 +0000 Fail: An error occurred while trying to run the script.</code>  </p>
</blockquote>

<p>If you let Xcode install the app, it modifies <code>Info.plist</code> internally to
include the following extra attributes:</p>

<pre><code>        &lt;key&gt;CFBundleSupportedPlatforms&lt;/key&gt;
        &lt;array&gt;
                &lt;string&gt;iPhoneSimulator&lt;/string&gt;
        &lt;/array&gt;
        &lt;key&gt;DTPlatformName&lt;/key&gt;
        &lt;string&gt;iphonesimulator&lt;/string&gt;
        &lt;key&gt;DTSDKName&lt;/key&gt;
        &lt;string&gt;iphonesimulator6.0&lt;/string&gt;
        &lt;key&gt;UIDeviceFamily&lt;/key&gt;
        &lt;array&gt;
                &lt;integer&gt;1&lt;/integer&gt;
        &lt;/array&gt;</code></pre>

<p>In essence, these are device attributes for the iOS Simulator&rsquo;s iPhone
simulation. If you add these attributes to the <code>Info.plist</code> file,
<code>instruments</code> runs as expected. It starts up the iPhone Simulator and
then starts up <code>Psi</code> in the simulator.</p>

<p>Inside <code>runsim</code> 2.0 there&rsquo;s a little Python script that adds these
attributes to an <code>Info.plist</code> file. If you&rsquo;re encountering the AWOL
problem, maybe this little script will help. (You can download <code>runsum</code>
from the link above.)</p>

<p>If you have any comments, corrections, or suggestions, leave them below
or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

