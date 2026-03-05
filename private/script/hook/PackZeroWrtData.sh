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

# PackZeroWrtData

# CreatePath
outputPath="$CI_TempPath/PackZeroWrtData" && mkdir -p "$outputPath"
tempPath="$outputPath/Temp" && mkdir -p "$tempPath"

# PackCompileData
tar -czf "$tempPath/CompileData.tar.gz" \
  --exclude='*.bin' \
  --exclude='*.ubi' \
  -C "$WRT_MainPath" \
  'bin'

# ... Add other files

# ZipEncrypt
appPath=$(getApp 'zerowrt-zerowrt-linux-amd64') || exit 1
"$appPath" zipcrypto encrypt \
  --dataPath "$tempPath/" \
  --outputPath "$outputPath/ZeroWrtData"
[[ $? -ne 0 ]] && exit 1

# DeletePath
rm -rf "$tempPath"

# --------------------------------------------------

exit 0
