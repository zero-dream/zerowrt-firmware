#!/bin/bash
# Copyright (C) 2000 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

[[ -z "$ZeroDream_Secret" ]] && exit 0

# --------------------------------------------------

# 创建配置文件
touch "$CI_VirtualPath/TempConfig"
touch "$CI_VirtualPath/VirtualConfig"

# 备份配置
cat "$WRT_ConfigPath" >"$CI_VirtualPath/TempConfig"

# 生成初步的虚拟配置
make defconfig -j$(nproc) && make clean -j$(nproc)
cat "$WRT_ConfigPath" >"$CI_VirtualPath/VirtualConfig"

# 生成最终的虚拟配置
virtualConfig=$("$CI_AppPath/EnableLuciAppConfig-linux-amd64" --configPath "$CI_VirtualPath/VirtualConfig")
(($? != 0)) && [[ "$ZD_Owner" == "$CI_Owner" ]] && exit 2
cat "$CI_VirtualPath/TempConfig" >"$WRT_ConfigPath" # 读取配置
echo '# LuciApp' >>"$WRT_ConfigPath"
echo "$virtualConfig" >>"$WRT_ConfigPath"
echo '# VirtualConfig' >>"$WRT_ConfigPath"
cat "$CI_PrivatePath/VirtualConfig" >>"$WRT_ConfigPath"
make defconfig -j$(nproc) && make clean -j$(nproc)
cat "$WRT_ConfigPath" >"$CI_VirtualPath/VirtualConfig"

# 还原配置
cat "$CI_VirtualPath/TempConfig" >"$WRT_ConfigPath"
