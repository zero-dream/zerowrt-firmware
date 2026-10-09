#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY
# Copyright (C) 2026 ZeroDream

# --------------------------------------------------

cd "$WRT_MainPath/"
FEEDS_PATH="$WRT_MainPath/feeds"
PACKAGE_PATH="$WRT_MainPath/package"

echo "$(printf -- '-%.0s' {1..50})"
echo "Handle: $(basename "${BASH_SOURCE[0]}")"
echo ''

# --------------------------------------------------

# 安装和更新软件包
UPDATE_PACKAGE() {
	local PKG_NAME=$1
	local PKG_REPO=$2
	local PKG_BRANCH=$3
	local PKG_SPECIAL=$4
	local PKG_LIST=("$PKG_NAME" $5)
	local REPO_NAME=${PKG_REPO#*/}
	local REPO_PATH="$PACKAGE_PATH/$REPO_NAME"
	# 删除本地可能存在的不同名称的软件包
	for NAME in "${PKG_LIST[@]}"; do
		# 查找匹配的目录
		echo "Search directory: $NAME"
		local FOUND_DIRS=$(find "$FEEDS_PATH/luci/" "$FEEDS_PATH/packages/" -maxdepth 3 -type d -iname "*$NAME*" 2>/dev/null)
		# 删除找到的目录
		if [ -n "$FOUND_DIRS" ]; then
			while read -r DIR; do
				rm -rf "$DIR"
				echo "Delete directory: $DIR"
			done <<< "$FOUND_DIRS"
		else
			echo "Not fonud directory: $NAME"
		fi
	done
	# 克隆 GitHub 仓库
	git clone --depth=1 --single-branch --branch $PKG_BRANCH "https://github.com/$PKG_REPO.git" $REPO_PATH
	# 处理克隆的仓库
	if [[ "$PKG_SPECIAL" == "pkg" ]]; then
		find $REPO_PATH/*/ -maxdepth 3 -type d -iname "*$PKG_NAME*" -prune -exec cp -rf {} "$PACKAGE_PATH/" \;
		rm -rf $REPO_PATH
	fi
	echo ''
}

# 示例:
# UPDATE_PACKAGE "包名" "项目地址" "项目分支" "pkg (可选, 从大杂烩中单独提取包名插件)" "删除列表"

# UPDATE_PACKAGE "open-app-filter" "destan19/OpenAppFilter" "master" "" "luci-app-appfilter oaf"
# 这样会把原有的 open-app-filter, luci-app-appfilter, oaf 相关组件删除，不会出现 coremark 错误

# 调用:
# UPDATE_PACKAGE "argon" "jerrykuku/luci-theme-argon" "master"

# --------------------------------------------------

# 更新软件包到最新版本
UPDATE_VERSION() {
	local PKG_NAME=$1
	local PKG_MARK=${2:-false}
	local PKG_FILES=$(find "$PACKAGE_PATH/" "$FEEDS_PATH/packages/" -maxdepth 3 -type f -wholename "*/$PKG_NAME/Makefile")
	if [[ -z "$PKG_FILES" ]]; then
		echo "$PKG_NAME not found!"
		return
	fi
	echo -e "$PKG_NAME version update has started!"
	for PKG_FILE in $PKG_FILES; do
		# 获取 PKG_REPO 变量
		local SOURCE_URL=$(grep -oP "PKG_SOURCE_URL:=.*" "$PKG_FILE")
		while read -r match; do
			local var=$(echo "$match" | grep -oP '\$\(\K[^)]+(?=\))')
			local value=$(grep -oP "$var:=\K.*" "$PKG_FILE")
			local SOURCE_URL="${SOURCE_URL/$match/$value}"
		done < <(echo "$SOURCE_URL" | grep -oP '\$\([^)]+\)')
		local PKG_REPO=$(echo "$SOURCE_URL" | grep -oP 'PKG_SOURCE_URL:=https://.*github.com/\K[^/]+/[^/]+(?=.*)')
		# 获取其他变量
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

# 示例:
# UPDATE_VERSION "包名" "测试版 (可选, 默认:false;)"

# 调用:
# UPDATE_VERSION "sing-box"
