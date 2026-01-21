#!/bin/bash

# --------------------------------------------------

# Source
source "$ZD_LibPath/createPath.sh"

# --------------------------------------------------

cd "$WRT_MainPath/"

echo '--------------------------------------------------'
echo 'SortingConfig.sh'
echo "WRT_MainPath: $WRT_MainPath"
echo ''

# --------------------------------------------------

# ! 越重要配置越放在后面

# 创建默认配置
defaultConfigPath=$(createTempPath 'DefaultConfig:file')
touch "$defaultConfigPath"

# 添加 Wrt 配置
cat "$WRT_ConfigPath" >>"$defaultConfigPath"

# ! ZeroDreamPrivate
[[ -f "$CI_VirtualPath/ParsedConfig" ]] && cat "$CI_VirtualPath/ParsedConfig" >>"$defaultConfigPath"

# 添加自定义配置
cat "$CI_ConfigPath/CustomConfig" >>"$defaultConfigPath"

# 替换配置
cat "$defaultConfigPath" >"$WRT_ConfigPath"

# 删除文件
rm -f "$defaultConfigPath"
