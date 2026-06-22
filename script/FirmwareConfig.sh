#!/bin/bash

# --------------------------------------------------

cd "$WRT_MainPath/"

echo '--------------------------------------------------'
echo 'FirmwareCore.sh'
echo "WRT_MainPath: $WRT_MainPath"
echo "WRT_ConfigPath: $WRT_ConfigPath"
echo ''

# --------------------------------------------------

# ! 越重要配置越放在后面
touch "$WRT_ConfigPath"

# 添加主题配置
cat >>"$WRT_ConfigPath" <<EOF
# Luci Theme
CONFIG_PACKAGE_luci-theme-$WRT_THEME=y
CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y
EOF
echo 'Successful: addLuciThemeConfig'
echo ''

# 添加内存回收补丁配置
cat >>"$WRT_ConfigPath" <<EOF
# SKB Recycler
CONFIG_KERNEL_SKB_RECYCLER=y
CONFIG_KERNEL_SKB_RECYCLER_MULTI_CPU=y
EOF
echo 'Successful: addSkbRecyclerConfig'
echo ''

# 添加固件通用配置
cat "$CI_ConfigPath/GeneralConfig" >>"$WRT_ConfigPath"

# 添加设备平台配置
cat "$CI_ConfigPath/Platform/$WRT_CONFIG" >>"$WRT_ConfigPath"
