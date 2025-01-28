#!/bin/bash

# kitty
echo "# Copying kitty cfg"
cp -r ~/.config/kitty ./config

# vim
echo "# Copying vim cfg"
cp -r ~/.vimrc ./config/vim

# nvim
echo "# Copying nvim cfg"
cp -r ~/.config/nvim ./config

# Yazi
echo "# Copying Yazi cfg"
cp ~/.config/yazi/init.lua ./config/yazi
cp ~/.config/yazi/yazi.toml ./config/yazi
cp ~/.config/yazi/theme.toml ./config/yazi
cp ~/.config/yazi/keymap.toml ./config/yazi
cp -r ~/.config/yazi/plugins ./config/yazi

# tmux
echo "# Copying tmux cfg"
cp ~/.config/tmux/tmux.conf ./config/tmux/

# sioyek
echo "# Copying Sioyek cfg"
cp -r ~/.config/sioyek/ ./config/

# VScode setting and VScodeVim settings
echo "# Copying VScode cfg"
cp ~/.config/Code/User/keybindings.json ./config/Code/User/keybindings.json
cp ~/.config/Code/User/settings.json ./config/Code/User/settings.json
cp -r ~/.config/Code/User/snippets ./config/Code/User/
