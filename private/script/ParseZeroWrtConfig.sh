#!/bin/bash
# Copyright (C) 2000 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

[[ -z "$ZeroDream_Secret" ]] && exit 0

# --------------------------------------------------

# 创建配置文件
touch "$CI_VirtualPath/ParsedConfig"

# ParseZeroWrtConfig
"$CI_AppPath/ParseZeroWrtConfig-linux-amd64" \
  --coreConfigPath "$CI_VirtualPath/CoreConfig" \
  --virtualConfigPath "$CI_VirtualPath/VirtualConfig" \
  >"$CI_VirtualPath/ParsedConfig"
(($? != 0)) && [[ "$ZD_Owner" == "$CI_Owner" ]] && exit 2
