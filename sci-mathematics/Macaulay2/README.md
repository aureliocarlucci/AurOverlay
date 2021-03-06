# Macaulay2 live Ebuild

This Ebuild is meant as a simple wrapper around the standard Macaulay2 installation [instructions](https://github.com/Macaulay2/M2/blob/master/M2/INSTALL). Currently, it is not suitable for inclusion in the main Portage tree: Macaulay2 bundles quite a number of accessory software, which should be disentangled from the main build and packaged separately.

I based my work on the Macaulay2-9999 ebuild originally maintained by [Thomas Kahle](https://faculty.math.illinois.edu/Macaulay2/Downloads/GNU-Linux/Gentoo/index.html). It was available on the [Science Overlay](https://github.com/Macaulay2/M2/blob/master/M2/INSTALL), before being [removed](https://github.com/gentoo/sci/commit/1331916dfa9c5dfa3956973cdf12ad37c4c19634#diff-573cf62ee113f6db205c72d9ecacbd2c3185333be212702aed9f0e3fa1c854bc) due to relying on a deprecated Python version.

I would welcome any comment or suggestion on how to improve this Ebuild.

## To do
* The list of dependency is pulled from the official INSTALL, but could be shortened. 
* Emacs files are build and installed regardless of the _emacs_ USE flag, which is left for legacy reasons. This behaviour should be fixed.
