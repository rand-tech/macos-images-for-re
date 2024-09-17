#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-llvm.sh
##  Desc:  Install LLVM
################################################################################

source ~/utils/utils.sh

llvmVersion=$(get_toolset_value '.llvm.version')

brew_smart_install "llvm@${llvmVersion}"

echo 'export PATH="/opt/homebrew/opt/llvm@15/bin:$PATH"' >> ~/.zshrc
echo 'export LDFLAGS="-L/opt/homebrew/opt/llvm@15/lib"' >> ~/.zshrc
echo 'export CPPFLAGS="-I/opt/homebrew/opt/llvm@15/include"' >> ~/.zshrc