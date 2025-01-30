# README

## TL;DR

Follow the YouTube guides referenced below to get started quickly.

---

## Table of Contents

1. [Kitty](#kitty-and-zsh)
2. [Tmux](#tmux)
3. [Yazi](#yazi)
4. [Neovim](#neovim)
   - [Base Configuration](#base)
   - [Plugins](#plugins)
   - [Features](#features)
5. [Code](#visual-studio-code)

---

## Kitty and zsh

Nothing too fancy. However, note that `tmux` does not support `super + key` inputs. Some of these bindings are instead assigned to the `F` row keys, which are supported.

### Quality of Life CLI Tools

Here are some tools that can significantly enhance your command-line experience:

- **zsh**: A powerful and customizable shell, often used as a replacement for `bash`. Known for its robust autocompletion, theme support, and plugin ecosystem (e.g., Oh My Zsh).

- **zoxide**: A smarter, faster way to navigate directories. It's a replacement for `cd` that uses a ranking algorithm to remember your most frequently accessed directories.

- **fzf**: A blazing-fast, interactive fuzzy finder. Use it to quickly search and filter files, directories, and more, directly from the command line.

- **lazygit**: A simple terminal UI for Git commands. It provides a streamlined and intuitive way to manage branches, stage changes, and view logs without typing complex Git commands.

<details><summary>Installation Steps</summary
   
 ```
 sudo apt update
 sudo apt install build-essential

 # Rust
 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
 rustup update

 # Yazi
 ## Yazi is available as `yazi-fm` and `yazi-cli` on crates.io. To install them, setup the latest stable Rust toolchain via rustup:
 ## If it fails to build, please check if make and gcc is installed on your system.
 cargo install --locked yazi-fm yazi-cli

 # ripgrep
 cargo install ripgrep

 # lsd
 cargo install lsd

 # zoxide
 curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

 # fzf
 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
 ~/.fzf/install

 # lazygit
 sudo apt install -y software-properties-common
 sudo add-apt-repository -y ppa:lazygit-team/release
 sudo apt update
 sudo apt install -y lazygit
 ```
</details>

## Tmux

- [Josean's Tmux Guide](https://www.youtube.com/watch?v=U-omALWIBos)

---

## Yazi

- [Josean's Setup with Blog Post](https://www.youtube.com/watch?v=iKb3cHDD9hw)

### Note

Plugins sometimes do not work when connected via SSH. I have not tackled this problem yet, so I use a vanilla configuration when needed.

---

## Neovim

### Base

- [Josean's Neovim Setup with Blog Post](https://www.youtube.com/watch?v=6pAG3BHurdM)

### Plugins

Plugins are managed by `lazy.nvim`. To add new plugins, drop configuration Lua files (containing a `return` statement) into the `plugins` directory.

Linters and formatters are managed by Mason. Ensure up-to-date Mason dependencies (requires `npm`).

<details>
  <summary>Installation Steps</summary>

```bash
sudo apt update -y
sudo apt install -y git

# Install Curl (or Wget as an alternative)
sudo apt install -y curl
# sudo apt install -y wget

# Install Unzip
sudo apt install -y unzip

# Install GNU Tar
sudo apt install -y tar
# sudo apt install -y gtar  # Alternative for some platforms

# Install Gzip
sudo apt install -y gzip

# Install Node.js and npm (Node Package Manager). Adjust for a newer version if needed.
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs  # npm is included with Node.js

# Install Cargo (Rust's package manager)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Add Cargo to PATH
source $HOME/.cargo/env
```

</details>

### Features

- [Advanced Telescope by TJ DeVries](https://www.youtube.com/watch?v=xdXE1tOT-qg)
- Highlights from kickstart.nvim ([Great video by TJ DeVries](https://www.youtube.com/watch?v=m8C0Cq9Uv9o&t=103s)):
  - Line highlighting on yank.

### Tools I Do Not Use

- **Neotree** plugin: Basic configuration available in `[plugins-removed]`. I prefer using `yazi.nvim` instead.
- **WhichKey** plugin: Basic configuration available in `[plugins-removed]`.
- **Neovim Terminal**: Instead, I maximize the Vim pane using `bind -r m resize-pane -Z` (`leader + m`).

---

## Visual Studio Code

Currently used exclusively for working with notebooks. The configuration is tailored around the Vim extension, ensuring that Code's default shortcuts do not conflict with Vim extension shortcuts.

### Key Configuration Files

- **keybindings.json**: Contains custom keybindings to avoid clashes between Code and the Vim extension.
- **settings.json**: Holds other relevant configurations for an optimized workflow.

Refer to these files for detailed adjustments and customization.
