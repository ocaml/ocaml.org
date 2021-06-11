---
title: FFTW
image: success-stories/fftw-thumb.png
url: https://www.fftw.org/
---

[FFTW](https://www.fftw.org/) est une librairie C [très
rapide](https://www.fftw.org/benchfft/) permettant d'effectuer des
Transformées de Fourier Discrètes (DFT). Elle emploie un puissant
optimiseur symbolique écrit en OCaml qui, étant donné un entier N,
produit du code C hautement optimisé pour effectuer des DFTs de taille
N. FFTW a reçu en 1999 le [prix
Wilkinson](https://en.wikipedia.org/wiki/J._H._Wilkinson_Prize_for_Numerical_Software)
pour les logiciels de calcul numérique.

Des mesures effectuées sur diverses plate-formes montrent que les
performances de FFTW sont typiquement supérieures à celles des autres
logiciels de DFT disponibles publiquement, et peuvent même concurrencer
le code optimisé proposé par certains fabriquants de processeurs. À la
différence de ce code propriétaire, cependant, les performances de FFTW
sont portables : un même programme donnera de bons résultats sur la
plupart des architectures sans modification. D'où le nom « FFTW, » qui
signifie « Fastest Fourier Transform in the West. »
