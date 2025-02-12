#!/usr/bin/bash

set -e

echo "Start time: $(date)" >  duration

echo "Updating ZMK"
pushd .. && git pull && popd >& /dev/null
echo

echo "Updating zmk-pmw3610-driver"
pushd ../../zmk-pmw3610-driver && git pull && popd >& /dev/null
echo

echo "Updating zmk-keyboards"
pushd ../../zmk-keyboards && git pull && popd >& /dev/null
echo

echo "Removing previous build artifacts"
rm -rf build/*
mkdir build/artifacts
echo

west update
echo

west zephyr-export
echo

echo "Building left side"
west build -p -d build/left -b assimilator-bt -- -DSHIELD=imprint_left  -DZMK_CONFIG="/home/tmitchem/src/zmk-user-config-template" -DZMK_EXTRA_MODULES="/home/tmitchem/src/zmk-keyboards;/home/tmitchem/src/zmk-pmw3610-driver"
echo


echo "Building right side"
west build -p -d build/right -b assimilator-bt -- -DSHIELD=imprint_right  -DZMK_CONFIG="/home/tmitchem/src/zmk-user-config-template" -DZMK_EXTRA_MODULES="/home/tmitchem/src/zmk-keyboards;/home/tmitchem/src/zmk-pmw3610-driver"
echo

echo "Renaming artifacts"
cp build/left/zephyr/zmk.uf2 build/artifacts/imprint_left-assimilator-bt-zmk.uf2
cp build/right/zephyr/zmk.uf2 build/artifacts/imprint_right-assimilator-bt-zmk.uf2
ls -l build/artifacts
echo


echo "End time:   $(date)" >>  duration

echo "Build duration"
cat duration
