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
cat >> "$WRT_ConfigPath" <<EOF
# Luci Theme
CONFIG_PACKAGE_luci-theme-$WRT_THEME=y
CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y
EOF
echo 'Successful: addLuciThemeConfig'
echo ''

# 添加内存回收补丁配置
cat >> "$WRT_ConfigPath" <<EOF
# SKB Recycler
CONFIG_KERNEL_SKB_RECYCLER=y
CONFIG_KERNEL_SKB_RECYCLER_MULTI_CPU=y
EOF
echo 'Successful: addSkbRecyclerConfig'
echo ''

# 添加固件通用配置
cat "$CI_ConfigPath/GeneralConfig" >>"$WRT_ConfigPath"

# 添加高通平台配置
if [[ "${WRT_TARGET^^}" == *"QUALCOMMAX"* ]]; then
	# 取消 NSS 相关 Feed
	echo "CONFIG_FEED_nss_packages=n" >>"$WRT_ConfigPath"
	echo "CONFIG_FEED_sqm_scripts_nss=n" >>"$WRT_ConfigPath"
	# 开启 sqm-nss 插件
	echo "CONFIG_PACKAGE_luci-app-sqm=y" >>"$WRT_ConfigPath"
	echo "CONFIG_PACKAGE_sqm-scripts-nss=y" >>"$WRT_ConfigPath"
	# 设置 NSS 版本
	echo "CONFIG_NSS_FIRMWARE_VERSION_11_4=n" >> "$WRT_ConfigPath"
	echo "CONFIG_NSS_FIRMWARE_VERSION_12_5=y" >>"$WRT_ConfigPath"
  # 添加配置成功
  echo 'Successful: addQualcommaxConfig'
	echo ''
fi

# 添加设备平台配置
cat "$CI_ConfigPath/Platform/$WRT_CONFIG" >>"$WRT_ConfigPath"
