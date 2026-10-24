#!/bin/zsh

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# update mods, resource packs, shader packs and data packs from Modrinth
node mod-update.js
