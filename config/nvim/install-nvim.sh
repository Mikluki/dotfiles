# Download the AppImage
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage

# Make it executable
chmod +x nvim-linux-x86_64.appimage

# Move to /opt or create a symlink in your PATH
sudo mkdir -p /opt/nvim
sudo mv nvim-linux-x86_64.appimage /opt/nvim/
sudo ln -sf /opt/nvim/nvim-linux-x86_64.appimage /usr/local/bin/nvim
