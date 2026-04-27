#!/bin/bash

# 切换Java版本
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk default java 26-tem

# 切换Node.js版本
source $NVM_DIR/nvm.sh
nvm use 24