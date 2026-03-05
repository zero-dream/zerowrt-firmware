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
touch "$CI_VirtualPath/VirtualConfig"

# GenVirtualCfg
appPath=$(getApp 'zerowrt-virtual-linux-amd64') || exit 1
"$appPath" genvirtualcfg \
  --wrtCfgPath "$WRT_ConfigPath" \
  --virtualCfgPath "$CI_VirtualPath/VirtualConfig" \
  --otherCfgPath "$CI_PrivatePath/config/VirtualConfig"
[[ $? -ne 0 ]] && exit 1

# --------------------------------------------------

exit 0
