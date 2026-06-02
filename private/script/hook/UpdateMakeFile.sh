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

# DeletePackages
deletePackages=(
  'feeds/packages/utils/exfatprogs/'
)

# UpdateMakeFile
tempPath="$CI_TempPath/UpdateMakeFile" && mkdir -p "$tempPath"

# Download
downloadPath="$tempPath/Download" && mkdir -p "$downloadPath"
makefilePath="$downloadPath/makefile"

gh release download \
  --repo 'zero-dream/zerowrt-makefile' \
  --pattern 'makefile' \
  --clobber \
  --dir "$downloadPath" || exit 1

# ZipDecrypt
decryptPath="$tempPath/Decrypt" && mkdir -p "$decryptPath"
appPath=$(getApp 'zerowrt-zerowrt-linux-amd64') || exit 1
"$appPath" zipcrypto decrypt \
  --dataPath "$makefilePath" \
  --outputPath "$decryptPath"
[[ $? -ne 0 ]] && exit 1

# Copy
if [[ -e "$decryptPath/updated" ]]; then
  for delete in "${deletePackages[@]}"; do
    rm -rf "$decryptPath/updated/$delete"
  done
  cp -a "$decryptPath/updated/." "$WRT_MainPath/"
fi

# DeletePath
rm -rf "$tempPath"

# --------------------------------------------------

exit 0
