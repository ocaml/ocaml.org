---
title: FFTW
image: /success-stories/fftw-thumb.png
url: https://www.fftw.org/
---

[FFTW](https://www.fftw.org/) is a [very fast](https://www.fftw.org/benchfft/) C
library for computing Discrete Fourier Transforms (DFT). It uses a powerful
symbolic optimizer written in OCaml which, given an integer N, generates highly
optimized C code to compute DFTs of size N. FFTW was awarded the 1999
[Wilkinson prize](https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software)
for numerical software.

Benchmarks, performed on a variety of platforms, show that FFTW's
performance is typically superior to that of other publicly available
DFT software, and is even competitive with vendor-tuned codes. In
contrast to vendor-tuned codes, however, FFTW's performance is portable:
the same program will perform well on most architectures without
modification. Hence the name, “FFTW,” which stands for the somewhat
whimsical title of “Fastest Fourier Transform in the West.”
