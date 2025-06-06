#! /usr/bin/env bash
#
# Copyright (C) 2021 Matt Reach<qianlongxu@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

THIS_DIR=$(DIRNAME=$(dirname "$0"); cd "$DIRNAME"; pwd)
cd "$THIS_DIR"

MESON_OTHER_FLAGS="$1"

echo "----------------------"
echo "[*] configurate $LIB_NAME"
echo "[*] other meson flags: $MESON_OTHER_FLAGS"
echo "----------------------"

# prepare build config
CFG_FLAGS="--prefix=$MR_BUILD_PREFIX --default-library static"

if [[ "$MR_DEBUG" == "debug" ]]; then
    CFG_FLAGS="$CFG_FLAGS --buildtype=debug"
else
    CFG_FLAGS="$CFG_FLAGS --buildtype=release"
fi

export CC="$MR_TRIPLE_CC"
export CXX="$MR_TRIPLE_CXX"
export AR="$MR_AR"
export AS="$MR_AS"
export RANLIB="$MR_RANLIB"
export STRIP="$MR_STRIP"

if [[ $(uname -m) != "$MR_ARCH" || "$MR_FORCE_CROSS" ]]; then
    if [[ $MR_IS_SIMULATOR == 1 ]]; then
        echo "[*] cross compile, on $(uname -m) compile $MR_PLAT $MR_ARCH simulator."
        CFG_FLAGS="$CFG_FLAGS --cross-file $MR_SHELL_CONFIGS_DIR/meson-crossfiles/$MR_ARCH-$MR_PLAT-simulator.meson"
    else
        echo "[*] cross compile, on $(uname -m) compile $MR_PLAT $MR_ARCH."
        CFG_FLAGS="$CFG_FLAGS --cross-file $MR_SHELL_CONFIGS_DIR/meson-crossfiles/$MR_ARCH-$MR_PLAT.meson"
    fi
fi

CFG_FLAGS="$CFG_FLAGS $MESON_OTHER_FLAGS"

echo "----------------------"
echo "[*] compile $LIB_NAME"
echo "CC: $MR_CC"
echo "CFG_FLAGS: $CFG_FLAGS"
echo "----------------------"
echo

cd $MR_BUILD_SOURCE
build=./meson_wksp
rm -rf $build

meson setup $build $CFG_FLAGS

cd $build

meson compile && meson install

# ninja -C build
# ninja -C build install
