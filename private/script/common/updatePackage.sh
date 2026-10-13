#!/bin/bash
# Copyright (C) 2026 ZeroDream
# https://github.com/zero-dream

# --------------------------------------------------

# Source
source "$ZD_ScriptPath/getLib.sh"

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
	local line
	while IFS= read -r line; do
		addPackage "$line"
	done <<<"$indexList"
}

function updatePackage() {
	local pkgArgs=()
	local package
	for package in "${ZeroWrtPackages[@]}"; do
		pkgArgs+=(--pkgName "$package")
	done
	local outputPath="$CI_TempPath/UpdatePkg" && mkdir -p "$outputPath"
	if [[ ${#pkgArgs[@]} -ne 0 ]]; then
		local appPath=$(getLib 'zerowrt-zerowrt-linux-amd64') || exit 1
		"$appPath" updatepkg \
			--wrtPath "$WRT_MainPath" \
			"${pkgArgs[@]}" \
			--outputPath "$outputPath"
	fi
}
