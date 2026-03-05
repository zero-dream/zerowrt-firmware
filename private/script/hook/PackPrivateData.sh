#!/bin/bash
# Copyright (C) 2000 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

# CheckExit
[[ "$CI_Owner" != "$ZD_Owner" ]] && exit 0

# --------------------------------------------------

# Source
source "$ZD_LibPath/private/getApp.sh"

# --------------------------------------------------

# PackPrivateData

# CreatePath
outputPath="$CI_TempPath/PackPrivateData" && mkdir -p "$outputPath"
tempPath="$outputPath/Temp" && mkdir -p "$tempPath"

# WrtConfig
cp -a "$WRT_ConfigPath" "$tempPath/$WRT_NAME-WrtConfig-$WRT_CONFIG-$ZD_Date"

# OutputAnalyzeFile
analyzePath="$tempPath/VirtualAnalyze" && mkdir -p "$analyzePath"
[[ -e "$CI_VirtualPath/OriginalConfig" ]] && cp -a "$CI_VirtualPath/OriginalConfig" "$analyzePath/01-$WRT_NAME-OriginalConfig-$WRT_CONFIG-$ZD_Date"
[[ -e "$CI_VirtualPath/CoreConfig" ]] && cp -a "$CI_VirtualPath/CoreConfig" "$analyzePath/02-$WRT_NAME-CoreConfig-$WRT_CONFIG-$ZD_Date"
[[ -e "$CI_VirtualPath/VirtualConfig" ]] && cp -a "$CI_VirtualPath/VirtualConfig" "$analyzePath/03-$WRT_NAME-VirtualConfig-$WRT_CONFIG-$ZD_Date"
[[ -e "$CI_VirtualPath/GetNotSetKmod" ]] && cp -a "$CI_VirtualPath/GetNotSetKmod" "$analyzePath/04-$WRT_NAME-GetNotSetKmod-$WRT_CONFIG-$ZD_Date"
[[ -e "$CI_VirtualPath/ParseConfig" ]] && cp -a "$CI_VirtualPath/ParseConfig" "$analyzePath/05-$WRT_NAME-ParseConfig-$WRT_CONFIG-$ZD_Date"

# UpdatePkgFile
updatePkgPath="$tempPath/UpdatePkg" && mkdir -p "$updatePkgPath"
[[ -e "$CI_TempPath/UpdatePkg" ]] && cp -a "$CI_TempPath/UpdatePkg/." "$updatePkgPath/"

# ... Add other files

# ZipEncrypt
appPath=$(getApp 'zerowrt-zerowrt-linux-amd64') || exit 1
"$appPath" zipcrypto encrypt \
  --dataPath "$tempPath/" \
  --outputPath "$outputPath/PrivateData"
[[ $? -ne 0 ]] && exit 1

# DeletePath
rm -rf "$tempPath"

# --------------------------------------------------

exit 0
