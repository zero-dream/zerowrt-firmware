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

# TouchFile
touch "$CI_VirtualPath/OriginalConfig"
touch "$CI_VirtualPath/CoreConfig"

# GenOriginalCfg
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
"$appPath" genoriginalcfg \
  --wrtCfgPath "$WRT_ConfigPath" \
  --originalCfgPath "$CI_VirtualPath/OriginalConfig"
[[ $? -ne 0 ]] && exit 1

# GenCoreCfg
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
"$appPath" gencorecfg \
  --wrtCfgPath "$WRT_ConfigPath" \
  --coreCfgPath "$CI_VirtualPath/CoreConfig"
[[ $? -ne 0 ]] && exit 1

# --------------------------------------------------

exit 0
