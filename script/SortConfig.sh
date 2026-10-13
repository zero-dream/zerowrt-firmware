#!/bin/bash
# Copyright (C) 2026 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

cd "$WRT_MainPath/"

echo "$(printf -- '-%.0s' {1..50})"
echo "Handle: $(basename "${BASH_SOURCE[0]}")"
echo ''

# --------------------------------------------------

# Source
source "$ZD_ScriptPath/createPath.sh"

# --------------------------------------------------

# ! 越重要配置越放在后面

# 创建临时配置
tempConfigPath=$(createTempPath 'DefaultConfig:file')

# 添加原有配置
cat "$WRT_ConfigPath" >"$tempConfigPath"

# ! ZeroDreamPrivate
[[ -f "$CI_VirtualPath/NotSetKmod" ]] && cat "$CI_VirtualPath/NotSetKmod" >>"$tempConfigPath"
[[ -f "$CI_VirtualPath/ParseConfig" ]] && cat "$CI_VirtualPath/ParseConfig" >>"$tempConfigPath"

# 排除部分配置
cat "$CI_ConfigPath/Exclude" >>"$tempConfigPath"

# 添加自定义配置
cat "$CI_ConfigPath/Custom" >>"$tempConfigPath"

# 替换配置
cat "$tempConfigPath" >"$WRT_ConfigPath"

# 删除文件
rm -f "$tempConfigPath/"
