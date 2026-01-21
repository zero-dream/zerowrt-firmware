#!/bin/bash

# --------------------------------------------------

cd "$WRT_MainPath/package/"

echo '--------------------------------------------------'
echo 'FirmwarePackage.sh'
echo "WRT_MainPath: $WRT_MainPath"
echo ''

# --------------------------------------------------

# function addPackage() {
# 	local name=$1
# }

# packages=(
# 	'luci-app-partexp'
# )
# repoUrl='https://github.com/zero-dream/zerowrt-repository/releases/latest/download'
# for package in "${packages[@]}"; do
# 	pkgPath="$WRT_MainPath/package/zerowrt"
# 	mkdir -p "$pkgPath"
# 	curl -L "$repoUrl/$package.tar.gz" | tar -xz -C "$pkgPath"
# done

# --------------------------------------------------

# 安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1               # 包名
	local PKG_REPO=$2               # 项目地址
	local PKG_BRANCH=$3             # 项目分支
	local PKG_SPECIAL=$4            # pkg/name (可选, pkg:从大杂烩中单独提取包名插件; name:重命名为包名;)
	local PKG_LIST=("$PKG_NAME" $5) # 第 5 个参数为自定义名称列表
	local REPO_NAME=${PKG_REPO#*/}
	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		# 查找匹配的目录
		echo "Search directory: $NAME"
		local FOUND_DIRS=$(find ../feeds/luci/ ../feeds/packages/ -maxdepth 3 -type d -iname "*$NAME*" 2>/dev/null)
		# 删除找到的目录
		if [ -n "$FOUND_DIRS" ]; then
			while read -r DIR; do
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<<"$FOUND_DIRS"
		else
			echo "Not fonud directory: $NAME"
		fi
	done
	# 克隆 GitHub 仓库
	git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git"
	# 处理克隆的仓库
	if [[ "$PKG_SPECIAL" == "pkg" ]]; then
		find ./$REPO_NAME/*/ -maxdepth 3 -type d -iname "*$PKG_NAME*" -prune -exec cp -rf {} ./ \;
		rm -rf ./$REPO_NAME/
	elif [[ "$PKG_SPECIAL" == "name" ]]; then
		mv -f $REPO_NAME $PKG_NAME
	fi
	echo ''
}

# 调用示例
# UPDATE_PACKAGE "open-app-filter" "destan19/OpenAppFilter" "master" "" "luci-app-appfilter oaf"
# 这样会把原有的 open-app-filter, luci-app-appfilter, oaf 相关组件删除，不会出现 coremark 错误

# UPDATE_PACKAGE "argon" "sbwml/luci-theme-argon" "openwrt-25.12"
# UPDATE_PACKAGE "partexp" "sirpdboy/luci-app-partexp" "main"
# UPDATE_PACKAGE "diskman" "lisaac/luci-app-diskman" "master"
# UPDATE_PACKAGE "viking" "VIKINGYFY/packages" "main" "" "luci-app-timewol luci-app-wolplus"
# UPDATE_PACKAGE "openlist2" "sbwml/luci-app-openlist2" "main"
# UPDATE_PACKAGE "netspeedtest" "sirpdboy/luci-app-netspeedtest" "master" "" "homebox speedtest"
# UPDATE_PACKAGE "luci-app-tailscale" "asvow/luci-app-tailscale" "main"
# UPDATE_PACKAGE "easytier" "EasyTier/luci-app-easytier" "main"
# UPDATE_PACKAGE "qbittorrent" "sbwml/luci-app-qbittorrent" "master" "" "qt6base qt6tools rblibtorrent"
# UPDATE_PACKAGE "homeproxy" "VIKINGYFY/homeproxy" "main"
# UPDATE_PACKAGE "ddns-go" "sirpdboy/luci-app-ddns-go" "main"
# UPDATE_PACKAGE "mosdns" "sbwml/luci-app-mosdns" "v5" "" "v2dat"
# UPDATE_PACKAGE "gecoosac" "lwb1978/openwrt-gecoosac" "main"

# --------------------------------------------------

# 更新软件包到最新版本
UPDATE_VERSION() {
	local PKG_NAME=$1          # 软件包名
	local PKG_MARK=${2:-false} # 测试版 (可选, 默认:false;)
	local PKG_FILES=$(find ./ ../feeds/packages/ -maxdepth 3 -type f -wholename "*/$PKG_NAME/Makefile")
	if [ -z "$PKG_FILES" ]; then
		echo "$PKG_NAME not found!"
		return
	fi
	echo -e "$PKG_NAME version update has started!"
	for PKG_FILE in $PKG_FILES; do
		# 获取 SOURCE_URL 变量
		local SOURCE_URL=$(grep -oP "PKG_SOURCE_URL:=.*" "$PKG_FILE")
		echo "$SOURCE_URL" | grep -oP '\$\([^)]+\)' | while read -r match; do
			local var=$(echo "$match" | grep -oP '\$\(\K[^)]+(?=\))')
			local value=$(grep -oP "$var:=\K.*" "$PKG_FILE")
			local SOURCE_URL="${SOURCE_URL/$match/$value}"
		done
		# 获取其他变量
		local PKG_REPO=$(echo "$SOURCE_URL" | grep -oP "PKG_SOURCE_URL:=https://.*github.com/\K[^/]+/[^/]+(?=.*)")
		echo '--------------------------------------------------'
		echo "$PKG_REPO"
		echo '--------------------------------------------------'
		local PKG_TAG=$(curl -sL "https://api.github.com/repos/$PKG_REPO/releases" | jq -r "map(select(.prerelease == $PKG_MARK)) | first | .tag_name")
		local OLD_VER=$(grep -oP "PKG_VERSION:=\K.*" "$PKG_FILE")
		local OLD_URL=$(grep -oP "PKG_SOURCE_URL:=\K.*" "$PKG_FILE")
		local OLD_FILE=$(grep -oP "PKG_SOURCE:=\K.*" "$PKG_FILE")
		local OLD_HASH=$(grep -oP "PKG_HASH:=\K.*" "$PKG_FILE")
		local PKG_URL=$([[ "$OLD_URL" == *"releases"* ]] && echo "${OLD_URL%/}/$OLD_FILE" || echo "${OLD_URL%/}")
		local NEW_VER=$(echo $PKG_TAG | sed -E 's/[^0-9]+/\./g; s/^\.|\.$//g')
		local NEW_URL=$(echo $PKG_URL | sed "s/\$(PKG_VERSION)/$NEW_VER/g; s/\$(PKG_NAME)/$PKG_NAME/g")
		local NEW_HASH=$(curl -sL "$NEW_URL" | sha256sum | cut -d ' ' -f 1)
		echo "old version: $OLD_VER $OLD_HASH"
		echo "new version: $NEW_VER $NEW_HASH"
		if [[ "$NEW_VER" =~ ^[0-9].* ]] && dpkg --compare-versions "$OLD_VER" lt "$NEW_VER"; then
			sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VER/g" "$PKG_FILE"
			sed -i "s/PKG_HASH:=.*/PKG_HASH:=$NEW_HASH/g" "$PKG_FILE"
			echo "$PKG_FILE version has been updated!"
		else
			echo "$PKG_FILE version is already the latest!"
		fi
	done
	echo ''
}

# 调用示例
# UPDATE_VERSION "软件包名" "测试版 (可选, 默认:false;)"

# 看看这里怎么更新的逻辑

UPDATE_VERSION "sing-box"
UPDATE_VERSION "tailscale"
UPDATE_VERSION "docker"

exit 1
