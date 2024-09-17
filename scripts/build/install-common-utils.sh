#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-common-utils.sh
##  Desc:  Install utils listed in toolset file
################################################################################

source ~/utils/utils.sh

# Monterey needs future review:
# aliyun-cli, gnupg, helm have issues with building from the source code.
# Added gmp for now, because toolcache ruby needs its libs. Remove it when php starts to build from source code.
common_packages=$(get_toolset_value '.brew.common_packages[]')
for package in $common_packages; do
    echo "Installing $package..."
    if is_Monterey && [[ $package == "xcbeautify" ]]; then
        # Pin the version on Monterey as 2.0.x requires Xcode >=15.0 which is not available on OS12
        xcbeautify_path=$(download_with_retry "https://raw.githubusercontent.com/Homebrew/homebrew-core/d3653e83f9c029a3fddb828ac804b07ac32f7b3b/Formula/x/xcbeautify.rb")
        brew install "$xcbeautify_path"
    else
        brew_smart_install "$package"
    fi
done
