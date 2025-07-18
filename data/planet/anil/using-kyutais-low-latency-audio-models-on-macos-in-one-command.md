---
title: Using Kyutai's low latency audio models on macOS in one command
description:
url: https://anil.recoil.org/notes/kyutai-streaming-voice-mlx
date: 2025-07-16T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---

<p>I've just taken <a href="https://unmute.sh/">Kyutai's speech-to-text model</a> for a spin on my Mac laptop, and it's stunningly good. As background, this is what the prolific <a href="https://github.com/laurentmazare">Laurent Mazare</a> has been hacking on; he has made a ton of contributions to the OCaml community as well, such as <a href="https://github.com/LaurentMazare/ocaml-torch">ocaml-torch</a> and starred in a very fun <a href="https://signalsandthreads.com/python-ocaml-and-machine-learning/">Signals to Threads episode</a> on machine learning at Jane Street back in 2020.</p>
<p>You can get the microphone-to-speech running on your Mac in a few commands, assuming you have <a href="https://github.com/astral-sh/uv">uv</a> installed (which you should!).</p>
<pre><code>git clone https://github.com/kyutai-labs/delayed-streams-modeling
cd delayed-streams-modeling
uvx --with moshi-mlx python scripts/stt_from_mic_mlx.py
</code></pre>
<p>It understands my accent near perfectly; if that isn't a machine learning miracle, I don't know what is! I'm looking forward to trying this out more with our <a href="https://anil.recoil.org/ideas/embedded-whisper">Low power audio transcription with Whisper</a> project over the summer with <a href="https://profiles.imperial.ac.uk/joshua.millar22" class="contact">Josh Millar</a> and <a href="mailto:dk729@cam.ac.uk" class="contact">Dan Kvit</a>.</p>

