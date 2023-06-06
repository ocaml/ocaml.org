---
title: The (Problems with the) RF64 File Specification.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/libsndfile/rf64_specs.html
date: 2010-10-07T10:36:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
One of the very common sound file formats that
	<a href="http://www.mega-nerd.com/libsndfile/">
	libsndfile</a>
reads and writes is the
	<a href="http://en.wikipedia.org/wiki/WAV">
	WAV</a>
format.
This format uses unsigned 32 bit integers internally to specify chunk lengths
which limits the total size of well formed file to be about 4 gigabytes in size.
On modern systems with high bit widths, multiple channels and high sample rates,
this 4Gig limit can be run into very easily.
For instance at a sample rate of 96kHz, with 24 bit samples, a 5.1 surround
sound recording will run into the 4Gig limit after about 41 minutes.
</p>

<p>
In order to overcome the limitations of WAV, the
	<a href="http://www.ebu.ch/">
	European Broadcasting Union</a>
decided in 2006 to start the specification of an extended WAV file format
capable of handling 64 bit file offsets.
The document that resulted from this specification process was first released in
2006 and the latest update was made in 2009 and is
	<a href="http://tech.ebu.ch/docs/tech/tech3306-2009.pdf">
	available here</a>.
I have a number of problems with this specification document.
</p>

<p>
First and foremost, in section 3.5, the document states:
</p>

<blockquote><i>
In spite of higher sampling frequencies and multi-channel audio, some production
audio files will inevitably be smaller than 4 Gbyte and they should therefore
stay in Broadcast Wave Format.
<br/><br/>
The problem arises that a recording application cannot know in advance whether
the recorded audio it is compiling will exceed 4 Gbyte or not at end of
recording (i.e. whether it needs to use RF64 or not).
<br/><br/>
The solution is to enable the recording application to switch from BWF to RF64
on the fly at the 4 Gbyte size-limit, while the recording is still going on.
<br/><br/>
This is achieved by reserving additional space in the BWF by inserting a 'JUNK'
chunk 3 that is of the same size as a 'ds64' chunk. This reserved space has no
meaning for Broadcast Wave, but will become the 'ds64' chunk, if a transition
to RF64 is necessary.
</i></blockquote>

<p>
In short, the suggestion above for writing a file boils down to:
</p>

<ol>
<li>Open the file and write a RIFF/WAV file header with a JUNK section big
	enough to allow the header to be replaced with an RF64 header if needed.
	</li>
<li>If the file ends up bigger than 4 gigabytes, go back and replace the
	existing header with an RF64 header.
	</li>
</ol>

<p>
There are two problems with this suggestion; it makes testing difficult and it
makes the software more complex which means its more likely to contain bugs.
The testing problem arises because testing that the RF64 header is written
correctly can only be done by writing a 4 gigabyte file.
Programmers can then either choose not to test this (which means the software is
is highly unlikely to work as specified) or test write a full 4 Gig file.
However, programmers also want their tests to run quickly (so that they can be
run often) and writing 4 gigabytes of data to disk is definitely not going to
be quick.
Of course, a smaller unit test might be able to bypass the requirement of
writing 4 gigabytes, but it would still be prudent to do a real test at the
WAV to RF64 switch over point.
The complexity problem is simply that writing a WAV file header first and then
overwriting it with an RF64 header later is far more complicated than just
writing an RF64 header to begin with.
Complexity breeds bugs.
</p>

<p>
The libsndfile project has had, from the very beginning, a pretty comprehensive
test suite and the running of that test suite takes about 30 seconds on current
hardware.
In order to comprehensively test the reading and writing of RF64 files,
libsndfile disregards the rather silly suggestion of the EBU to convert on the
fly between WAV and RF64 files.
If the software calling libsndfile specifies that an RF64 file be generated,
libsndfile will write an RF64 file, even if that file only contains 100 bytes.
</p>

<p>
A second problem with the RF64 specification is that the specification is
ambiguous in a very subtle way.
The problem is with how the binary chunks within the file are specified.
For WAV files, chunks are specified in
	<a href="http://www-mmsp.ece.mcgill.ca/documents/audioformats/wave/Docs/riffmci.pdf">
	this document</a>
as:
</p>

<pre class="code">

  typedef unsigned long DWORD ;
  typedef unsigned char BYTE ;

  typedef DWORD FOURCC ;            // Four-character code
  typedef FOURCC CKID ;             // Four-character-code chunk identifier
  typedef DWORD CKSIZE ;            // 32-bit unsigned size value

  typedef struct {                  // Chunk structure
      CKID        ckID ;                   // Chunk type identifier
      CKSIZE      ckSize ;                 // Chunk size field (size of ckData)
      BYTE        ckData [ckSize] ;        // Chunk data
  } CK;

</pre>

<p>
This specifies that a chunk has a 4 byte identifier, followed by a 4 byte chunk
size, followed by the chunk data.
The important thing to note here is that the chunk size does not include the
4 byte chunk identifier and the 4 byte chunk size field.
Inspecting real WAV files found in the wild will confirm that this is the case
for all common chunks found in WAV files.
</p>

<p>
Now contrast the above with how the chunks are specified in the EBU document.
Ror instance the <b><tt>'fmt '</tt></b> chunk (which is common to both WAV and
RF64) is specified as:
</p>

<pre class="code">

  struct FormatChunk5                // declare FormatChunk structure
  {
      char           chunkId[4];     // 'fmt '
      unsigned int32 chunkSize;      // 4 byte size of the 'fmt ' chunk
      unsigned int16 formatType;     // WAVE_FORMAT_PCM = 0x0001, etc.
      unsigned int16 channelCount;   // 1 = mono, 2 = stereo, etc.
      unsigned int32 sampleRate;     // 32000, 44100, 48000, etc.
      unsigned int32 bytesPerSecond; // only important for compressed formats
      unsigned int16 blockAlignment; // container size (in bytes) of one set of samples
      unsigned int16 bitsPerSample;  // valid bits per sample 16, 20 or 24
      unsigned int16 cbSize;         // extra information (after cbSize) to store
      char           extraData[22];  // extra data of WAVE_FORMAT_EXTENSIBLE when necessary
  };

</pre>

<p>
Here, the <b><tt>chunkSize</tt></b> field is simply the <i>&quot;size of the 'fmt '
chunk&quot;</i> and nowhere in the EBU document is it specified exactly how that
<b><tt>chunkSize</tt></b> field should be calculated.
However, if you give the EBU documentation to any experienced software engineer
with no previous knowledge of RIFF/WAV files, they would almost certainly assume
that the <b><tt>chunkSize</tt></b> field should be the size of the whole chunk,
including the <b><tt>chunkID</tt></b> and <b><tt>chunkSize</tt></b> fields.
However, someone who knows about RIFF/WAV files will be less likely to follow
that path.
</p>

<p>
This leaves the programmer implementing code to read and write this format with
a couple of possibilities:
</p>

<ul>
<li>Assume that the document is right and should be followed to the letter.
	</li>
<li>Assume the document is wrong and that the <b><tt>'fmt '</tt></b> chunk of
	an RF64 file should be identical to that of a WAV file.
	</li>
<li><s>Give up and go home.</s>
	</li>
</ul>

<p>
However, the last part of section 3.5 of the EBU/RF64 document describes how a
WAV file is to be upgraded to an RF64 file, and that description makes no
mention of the <b><tt>'fmt '</tt></b> chunk being modified during that upgrade.
One can only assume from this, that the <b><tt>'fmt '</tt></b> chunk in an RF64
file should be identical to that of a WAV file and that the EBU/RF64
specification is misleading.
</p>

<p>
For libsndfile, I have decided to assume that the specification is indeed
misleading.
Unfortunately, I'm pretty sure that at some point I will be asked to at least
<i>read</i> files which strictly adhere to the literal interpretation of the
document.
I'm also pretty sure that implementing code to read files written to conform to
both interpretations of the spec will be a very painful exercise.
</p>





