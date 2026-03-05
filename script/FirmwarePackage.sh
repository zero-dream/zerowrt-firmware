#!/bin/bash

# --------------------------------------------------

cd "$WRT_MainPath/package/"
pkgPath="$WRT_MainPath/package/"

echo '--------------------------------------------------'
echo 'FirmwarePackage.sh'
echo "WRT_PackagePath: $pkgPath"
echo ''

# --------------------------------------------------

# Source
source "$CI_ScriptPath/common/addPackage.sh"

# --------------------

# addPackage 'luci-theme-argon'

# ... other

# --------------------

getRepoIndexList

addAllPackage

# --------------------

curlPackage

# --------------------------------------------------

# Source
source "$CI_ScriptPath/common/updatePackage.sh"

# UPDATE_PACKAGE "argon" "jerrykuku/luci-theme-argon" "master"

# UPDATE_VERSION "sing-box"
