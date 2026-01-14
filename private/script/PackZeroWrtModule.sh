#!/bin/bash
# Copyright (C) 2000 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

[[ -z "$ZeroDream_Secret" ]] && exit 0

# --------------------------------------------------

# PackZeroWrtModule
outputPath="$CI_TempPath/FirmwareModule" && mkdir -p "$outputPath"
"$CI_AppPath/PackZeroWrtModule-linux-amd64" \
  --dataPath "$WRT_MainPath/bin" \
  --configPath "$WRT_ConfigPath" \
  --outputPath "$outputPath"
(($? != 0)) && [[ "$ZD_Owner" == "$CI_Owner" ]] && exit 2
