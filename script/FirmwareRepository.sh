#!/bin/bash
# Copyright (C) 2026 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

# env:
#   GH_TOKEN: ${{secrets.WORKFLOW_TOKEN}}

# --------------------------------------------------

cd "$WRT_MainPath/"
PACKAGE_PATH="$WRT_MainPath/package"

echo "$(printf -- '-%.0s' {1..50})"
echo "Handle: $(basename "${BASH_SOURCE[0]}")"
echo ''

# --------------------------------------------------

ZeroWrtRepo="$ZD_Owner/zerowrt-repository"
ZeroWrtIndexName='00-IndexList'

ZeroWrtPackages=()
ZeroWrtIndexList=''

function addPackage() {
	local name=$1
	findDeletePackage "$name"
	ZeroWrtPackages+=("$name")
}

function findDeletePackage() {
	local name=$1
	echo "Find dir: $name"
	local findDirs=$(find "$WRT_MainPath/feeds/luci/" "$WRT_MainPath/feeds/packages/" \
		-type d \
		-iname "*$name*" \
		2>/dev/null)
	if [[ -n "$findDirs" ]]; then
		while read -r dir; do
			rm -rf "$dir"
			echo "Delete dir: $dir"
		done <<<"$findDirs"
	else
		echo "Dir not found"
	fi
	echo ''
}

function getRepoIndexList() {
	local repoPath="$CI_TempPath/ZeroWrtRepo" && mkdir -p "$repoPath"
	local indexPath="$repoPath/IndexList" && touch "$indexPath"
	ZeroWrtIndexList=$(gh release download \
		--repo "$ZeroWrtRepo" \
		--pattern "$ZeroWrtIndexName" \
		--output -)
	echo "$ZeroWrtIndexList" >"$indexPath"
}

function addAllPackage() {
	while IFS= read -r line; do
		addPackage "$line"
	done <<<"$ZeroWrtIndexList"
}

function downloadPackage() {
  echo "Download List:"
	for package in "${ZeroWrtPackages[@]}"; do
		local pkgPath="$WRT_MainPath/package"
		mkdir -p "$pkgPath"
		gh release download \
			--repo "$ZeroWrtRepo" \
			--pattern "$package.tar.gz" \
			--output - | tar -xz -C "$pkgPath"
    echo "  - $package"
	done
  echo ''
}

# --------------------------------------------------

# addPackage 'luci-theme-argon'

# --------------------------------------------------

getRepoIndexList

addAllPackage

# --------------------------------------------------

downloadPackage
