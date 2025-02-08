#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* config/

sed -i.bak -E 's@(libPhotosppHepMC3_la_LIBADD = libPhotospp.la)@\1 -lHepMC -lHepMC3@g' src/Makefile.in
if diff src/Makefile.in.bak src/Makefile.in; then
    echo "Failed to patch Makefile.in"
    exit 1
fi

# Regenerate the configure script
autoreconf -fvi

./configure --prefix="${PREFIX}" --with-hepmc="${PREFIX}" --with-hepmc3="${PREFIX}"
# Yes, LD=CXX is intentional..
make -j${CPU_COUNT} LD=$CXX
make install
