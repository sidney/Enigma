#!/bin/sh 
rm -Rf lib-src/tinygettext/build
mkdir lib-src/tinygettext/build
cd lib-src/tinygettext/build
cmake .. "$@"
