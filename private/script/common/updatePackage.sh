#!/bin/bash

# --------------------------------------------------

# Source
source "$ZD_LibPath/private/getApp.sh"

# --------------------------------------------------

ZeroWrtPackages=()

function addPackage() {
	local name=$1
	ZeroWrtPackages+=("$name")
}

function addAllPackage() {
	local repoPath="$CI_TempPath/ZeroWrtRepo"
	local indexPath="$repoPath/IndexList"
	local indexList=$(cat "$indexPath")
	while IFS= read -r line; do
		addPackage "$line"
	done <<<"$indexList"
}

function updatePackage() {
	local pkgArgs=()
	for package in "${ZeroWrtPackages[@]}"; do
		pkgArgs+=(--pkgName "$package")
	done
	local outputPath="$CI_TempPath/UpdatePkg" && mkdir -p "$outputPath"
	if [[ ${#pkgArgs[@]} -ne 0 ]]; then
		local appPath=$(getApp 'zerowrt-zerowrt-linux-amd64') || exit 1
		"$appPath" updatepkg \
			--wrtPath "$WRT_ConfigPath" \
			"${pkgArgs[@]}" \
			--outputPath "$outputPath"
	fi
}
