#!/bin/bash
# Copyright (C) 2000 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

# CheckExit
[[ "$CI_Owner" != "$ZD_Owner" ]] && exit 0
[[ "$WRT_ONLY_CONFIG" == 'true' ]] && exit 0

# --------------------------------------------------

# Source
source "$ZD_LibPath/private/getApp.sh"

# --------------------------------------------------

# PackZeroWrtModule
outputPath="$CI_TempPath/ZeroWrtModule" && mkdir -p "$outputPath"
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
"$appPath" packmodule \
  --isEncrypt=true \
  --dataPath "$WRT_MainPath/bin" \
  --configPath "$WRT_ConfigPath" \
  --outputPath "$outputPath"
[[ $? -ne 0 ]] && exit 1

# PackKernelModule
outputPath="$CI_TempPath/KernelModule" && mkdir -p "$outputPath"
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
"$appPath" packmodule \
  --isEncrypt=false \
  --dataPath "$WRT_MainPath/bin" \
  --configPath "$CI_VirtualPath/VirtualConfig" \
  --outputPath "$outputPath"
[[ $? -ne 0 ]] && exit 1

# --------------------------------------------------

exit 0
