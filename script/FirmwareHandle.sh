#!/bin/bash

# --------------------------------------------------

cd "$WRT_MainPath/package/"
pkgPath="$WRT_MainPath/package/"

echo '--------------------------------------------------'
echo 'FirmwareHandle.sh'
echo "WRT_MainPath: $WRT_MainPath"
echo ''

# --------------------------------------------------

# 修改 qca-nss-drv 启动顺序
cd "$pkgPath"
NSS_DRV="../feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init"
if [ -f "$NSS_DRV" ]; then
	sed -i 's/START=.*/START=85/g' $NSS_DRV
	echo 'Fixed: qca-nss-drv'
	echo ''
fi

# 修改 qca-nss-pbuf 启动顺序
cd "$pkgPath"
NSS_PBUF="./kernel/mac80211/files/qca-nss-pbuf.init"
if [ -f "$NSS_PBUF" ]; then
	sed -i 's/START=.*/START=86/g' $NSS_PBUF
	echo 'Fixed: qca-nss-pbuf'
	echo ''
fi

# --------------------------------------------------

# 修复 Rust 编译失败
cd "$pkgPath"
RUST_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE
	echo 'Fixed: rust'
	echo ''
fi

# 修复 DiskMan 编译失败
cd "$pkgPath"
DM_FILE="./luci-app-diskman/applications/luci-app-diskman/Makefile"
if [ -f "$DM_FILE" ]; then
	sed -i 's/fs-ntfs/fs-ntfs3/g' $DM_FILE
	sed -i '/ntfs-3g-utils /d' $DM_FILE
	echo 'Fixed: diskman'
	echo ''
fi

# 修复 Tailscale 配置文件冲突
cd "$pkgPath"
TS_FILE=$(find ../feeds/packages/ -maxdepth 3 -type f -wholename "*/tailscale/Makefile")
if [ -f "$TS_FILE" ]; then
	sed -i '/\/files/d' $TS_FILE
	echo 'Fixed: tailscale'
	echo ''
fi

# 修复 Coremark
cd "$pkgPath"
COREMARK_FILE="$WRT_MainPath/feeds/packages/utils/coremark/Makefile"
if [ -f "$COREMARK_FILE" ]; then
	sed -i 's/mkdir \$(PKG_BUILD_DIR)\/\$(ARCH)/mkdir -p \$(PKG_BUILD_DIR)\/\$(ARCH)/g' "$COREMARK_FILE"
	echo 'Fixed: coremark'
	echo ''
fi

# 修复 99_netspeedtest 相关问题
cd "$pkgPath"
if [ -d *"luci-app-netspeedtest"* ]; then
	cd ./luci-app-netspeedtest/
	sed -i '$a\exit 0' ./netspeedtest/files/99_netspeedtest.defaults
	sed -i 's/ca-certificates/ca-bundle/g' ./speedtest-cli/Makefile
	echo "Fixed: netspeedtest"
	echo ''
fi

# --------------------------------------------------

# 临时修复 nss-firmware 校验不通过
# cd "$pkgPath"
# NSS_FIRMWARE_FILE="$WRT_MainPath/feeds/nss_packages/firmware/nss-firmware/Makefile"
# if [ -f "$NSS_FIRMWARE_FILE" ]; then
# 	sed -i 's/3ec87f221e8905d4b6b8b3d207b7f7c4666c3bc8db7c1f06d4ae2e78f863b8f4/881cbf75efafe380b5adc91bfb1f68add5e29c9274eb950bb1e815c7a3622807/g' "$NSS_FIRMWARE_FILE"
# 	echo 'Fixed: nss-firmware'
# 	echo ''
# fi

# --------------------------------------------------

# 更新 Golang 为最新版
cd "$pkgPath"
rm -rf "$WRT_MainPath/feeds/packages/lang/golang"
git clone https://github.com/sbwml/packages_lang_golang -b 25.x "$WRT_MainPath/feeds/packages/lang/golang"
echo 'Updated: golang'
echo ''

# --------------------------------------------------

# 删除 luci-app-attendedsysupgrade
cd "$pkgPath"
COLLECTIONS_FILES=$(find ../feeds/luci/collections/ -type f -name "Makefile")
if [ -n "$COLLECTIONS_FILES" ]; then
	for COLLECTIONS_FILE in $COLLECTIONS_FILES; do
		echo "$COLLECTIONS_FILE"
    sed -i "/attendedsysupgrade/d" "$COLLECTIONS_FILE"
	done
	echo 'Delete: luci-app-attendedsysupgrade'
	echo ''
fi

# --------------------------------------------------

# 设置 Argon 主题字体和颜色
cd "$pkgPath"
if [ -d *"luci-theme-argon"* ]; then
	cd ./luci-theme-argon/
	sed -i "/font-weight:/ { /important/! { /\/\*/! s/:.*/: var(--font-weight);/ } }" $(find ./luci-theme-argon -type f -iname "*.css")
	sed -i -e "s/primary '.*'/primary '#6c8eb0'/" \
				 -e "s/dark_primary '.*'/dark_primary '#6c8eb0'/" \
				 -e "s/'0.2'/'0.5'/" \
				 -e "s/online_wallpaper '.*'/online_wallpaper 'bing'/" \
				 -e "s/'600'/'normal'/" \
				 -e "s/mode '.*'/mode 'normal'/" \
				 ./luci-app-argon-config/root/etc/config/argon
	echo 'Fixed: theme-argon'
	echo ''
fi

# 预置 HomeProxy 数据
cd "$pkgPath"
if [ -d *"homeproxy"* ]; then
	HP_RULE="surge"
	HP_PATH="homeproxy/root/etc/homeproxy"
	rm -rf ./$HP_PATH/resources/*
	git clone -q --depth=1 --single-branch --branch "release" "https://github.com/Loyalsoldier/surge-rules.git" ./$HP_RULE/
	cd ./$HP_RULE/ && RES_VER=$(git log -1 --pretty=format:'%s' | grep -o "[0-9]*")
	echo $RES_VER | tee china_ip4.ver china_ip6.ver china_list.ver gfw_list.ver
	awk -F, '/^IP-CIDR,/{print $2 > "china_ip4.txt"} /^IP-CIDR6,/{print $2 > "china_ip6.txt"}' cncidr.txt
	sed 's/^\.//g' direct.txt > china_list.txt ; sed 's/^\.//g' gfw.txt > gfw_list.txt
	mv -f ./{china_*,gfw_list}.{ver,txt} ../$HP_PATH/resources/
	cd .. && rm -rf ./$HP_RULE/
	echo 'Updated: homeproxy'
	echo ''
fi
