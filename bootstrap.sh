#!/bin/bash

# Check if FBC is set, otherwise prompt user to run SET FBC=fbc32 or preferred compiler first
if [ -z "$FBC" ]; then
  echo "Please run SET FBC=fbc32 or your preferred compiler first"
  exit 1
fi

# Clear old build files
rm -rf src/*.o
rm -rf .obj/*.o
rm weld bootstrap-weld inc/options.bi inc/strings.bi inc/strings/*.bi inc/fbefile/*.bi inc/fbefile/detail/*.bi
rm -rf inc/strings
rm -rf inc/fbefile
rm -rf lib/libfbeoptions.a lib/libfbefile.a lib/libfbefilemt.a lib/libfbestrings.a

# Build submodules
cd submodules/fbeoptions && make && cd ../..
cp submodules/fbeoptions/inc/options.bi inc/
cp submodules/fbeoptions/lib/libfbeoptions.a lib/

cd submodules/fbefile && make && cd ../..
cp -r submodules/fbefile/inc/ inc/
cp submodules/fbefile/lib/libfbefile.a lib/
cp submodules/fbefile/lib/libfbefilemt.a lib/

cd submodules/festrings && make && cd ../..
cp -r submodules/festrings/inc/ inc/
cp submodules/festrings/lib/libfbestrings.a lib/

# Build objects
$FBC -c -i inc -w all -g main src/main.bas
$FBC -c -i inc -w all -g src/compiler.bas
$FBC -c -i inc -w all -g src/list-compiler.bas
$FBC -c -i inc -w all -g src/module.bas
$FBC -c -i inc -w all -g src/list-module.bas
$FBC -c -i inc -w all -g src/parser.bas
$FBC -c -i inc -w all -g src/utilities.bas
$FBC -c -i inc -w all -g src/crc32.bas
$FBC -c -i inc -w all -g src/semver.bas

# Link objects into executable
$FBC -p lib -m main src/main.o src/crc32.o src/compiler.o src/list-compiler.o src/module.o src/list-module.o src/parser.o src/utilities.o src/semver.o -x bootstrap-weld

# Make final exe
./bootstrap-weld

# Clean up old build files
rm -rf src/*.o
rm bootstrap-weld