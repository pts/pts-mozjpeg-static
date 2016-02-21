pts-mozjpeg-static: mozjpeg tools for Linux i386, statically linked

pts-mozjpeg-static is a set of tools for compiling the cjpeg and jpegtran
tools of mozjpeg (3.1) for Linux i386, statically linked.

Dependencies:

* gcc, tested with gcc-3.8
* ar (from GNU Binutils)
* (assembler not necessary)
* pts-xstatic
* libz.a and zlib headers
* libpng.a (for libpng 1.2) and libpng headers

How to compile:

1. Install the dependencies.
2. Download pts-mozjpeg-xstatic.
3. Run: ./compile.sh
4. The results are the mozcjpeg and mozjpegtran binaries.

Notes:

* TODO(pts): Why are some files different created with mozcjpeg -quality 75
  within pts-mozjpeg-static (i386) and within mozjpeg (amd64)? There is e.g.
  a 40 byte .jpg file size difference: 195813 vs 195853.


__EOF__
