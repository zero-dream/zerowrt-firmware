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
touch "$CI_VirtualPath/GetNotSetKmod"
touch "$CI_VirtualPath/ParseConfig"

# GetNotSetKmod
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
notSetKmodOutput=$("$appPath" getnotsetkmod \
  --cfgPath "$CI_VirtualPath/OriginalConfig")
[[ $? -ne 0 ]] && exit 1
echo "$notSetKmodOutput" >"$CI_VirtualPath/GetNotSetKmod"

# ParseCfg
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
parseCfgOutput=$("$appPath" parsecfg \
  --originalCfgPath "$CI_VirtualPath/OriginalConfig" \
  --coreCfgPath "$CI_VirtualPath/CoreConfig" \
  --virtualCfgPath "$CI_VirtualPath/VirtualConfig")
[[ $? -ne 0 ]] && exit 1
echo "$parseCfgOutput" >"$CI_VirtualPath/ParseConfig"

# --------------------------------------------------

exit 0
