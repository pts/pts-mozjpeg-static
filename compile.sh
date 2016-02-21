#! /bin/bash --
# by pts@fazekas.hu at Sun Feb 21 20:41:36 CET 2016

set -ex
RELEASE_TGZ=mozjpeg-3.1-release-source.tar.gz
type -p xstatic  # From pts-xstatic.
test -f "$RELEASE_TGZ"
test -f simd.aa

rm -rf mozjpeg
tar xzvf "$RELEASE_TGZ"  # Extracts to `mozjpeg'.
cp -a jconfig.h jconfigint.h mozjpeg/
(cd mozjpeg && mkdir -p simd_o && cd simd_o && ar x ../../simd.aa) || exit "$?"

# TODO(pts): Add more flags.
CC="xstatic gcc"
CFLAGS="-Wall -O3"
# TODO(pts): Deduplicate these objs.
LIBJPEG_OBJS="jcapimin.o jcapistd.o jccoefct.o jccolor.o jcdctmgr.o jcext.o jchuff.o jcinit.o jcmainct.o jcmarker.o jcmaster.o jcomapi.o jcparam.o jcphuff.o jcprepct.o jcsample.o jctrans.o jdapimin.o jdapistd.o jdatadst.o jdatasrc.o jdcoefct.o jdcolor.o jddctmgr.o jdhuff.o jdinput.o jdmainct.o jdmarker.o jdmaster.o jdmerge.o jdphuff.o jdpostct.o jdsample.o jdtrans.o jerror.o jfdctflt.o jfdctfst.o jfdctint.o jidctflt.o jidctfst.o jidctint.o jidctred.o jquant1.o jquant2.o jutils.o jmemmgr.o jmemnobs.o jaricom.o jcarith.o jdarith.o"
JPEGTRAN_OBJS="jpegtran.o rdswitch.o cdjpeg.o transupp.o"
CJPEG_OBJS="cjpeg-cdjpeg.o cjpeg-cjpeg.o cjpeg-rdgif.o cjpeg-rdppm.o cjpeg-rdswitch.o cjpeg-rdjpeg.o cjpeg-rdbmp.o cjpeg-rdtarga.o cjpeg-rdpng.o"

$CC $CFLAGS -DHAVE_CONFIG_H -Imozjpeg -c mozjpeg/simd/jsimd_i386.c -o mozjpeg/jsimd_i386.o

for F_O in $LIBJPEG_OBJS; do
  F_C="${F_O%.*}.c"
  $CC $CFLAGS -DHAVE_CONFIG_H -Imozjpeg -c mozjpeg/"$F_C" -o mozjpeg/"$F_O"
done

for F_O in $JPEGTRAN_OBJS; do
  F_C="${F_O%.*}.c"
  $CC $CFLAGS -DHAVE_CONFIG_H -Imozjpeg -c mozjpeg/"$F_C" -o mozjpeg/"$F_O"
done

for F_O in $CJPEG_OBJS; do
  F_C="${F_O%.*}.c"
  F_C="${F_C#cjpeg-}"
  $CC $CFLAGS -DGIF_SUPPORTED -DPPM_SUPPORTED -DBMP_SUPPORTED -DTARGA_SUPPORTED -DPNG_SUPPORTED -Imozjpeg -c mozjpeg/"$F_C" -o mozjpeg/"$F_O"
done

rm -f mozjpeg/libjpeg.a
(cd mozjpeg && ar cr libjpeg.a $LIBJPEG_OBJS simd_o/*.o jsimd_i386.o) || exit "$?"
(cd mozjpeg && $CC -s -o ../mozjpegtran $JPEGTRAN_OBJS libjpeg.a -lm) || exit "$?"
(cd mozjpeg && $CC -s -o ../mozcjpeg $CJPEG_OBJS libjpeg.a -lpng -lz -lm) || exit "$?"
ls -l mozcjpeg mozjpegtran
rm -rf mozjpeg

: compile.sh OK
