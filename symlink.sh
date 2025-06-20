#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"
LN_FLAGS="-sfT"

if [[ "$(uname)" == "Darwin" ]]; then
  LN_FLAGS="-sfF"
fi

ln "$LN_FLAGS" "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
ln "$LN_FLAGS" "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln "$LN_FLAGS" "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln "$LN_FLAGS" "$DOTFILES/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
ln "$LN_FLAGS" "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln "$LN_FLAGS" "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
ln "$LN_FLAGS" "$DOTFILES/.hushlogin" "$HOME/.hushlogin"
ln "$LN_FLAGS" "$DOTFILES/.profile" "$HOME/.profile"
ln "$LN_FLAGS" "$DOTFILES/.sshrc" "$HOME/.sshrc"
ln "$LN_FLAGS" "$DOTFILES/.sshrc.d" "$HOME/.sshrc.d"
ln "$LN_FLAGS" "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln "$LN_FLAGS" "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln "$LN_FLAGS" "$DOTFILES/gtk-2.0" "$HOME/.config/gtk-2.0"
ln "$LN_FLAGS" "$DOTFILES/gtk-3.0" "$HOME/.config/gtk-3.0"
ln "$LN_FLAGS" "$DOTFILES/gtk-4.0" "$HOME/.config/gtk-4.0"
ln "$LN_FLAGS" "$DOTFILES/dolphinrc" "$HOME/.config/dolphinrc"
ln "$LN_FLAGS" "$DOTFILES/hypr" "$HOME/.config/hypr"
ln "$LN_FLAGS" "$DOTFILES/qt5ct" "$HOME/.config/qt5ct"
ln "$LN_FLAGS" "$DOTFILES/qt6ct" "$HOME/.config/qt6ct"
ln "$LN_FLAGS" "$DOTFILES/waybar" "$HOME/.config/waybar"

if [ ! -d "$HOME/.config/nvim" ]; then
  git clone --recurse-submodules git@github.com:Dobefu/nvim-config.git "$HOME/.config/nvim"
fi

if [ ! -d "$HOME/bin" ]; then
  git clone --recurse-submodules git@github.com:Dobefu/bin.git "$HOME/bin"
  cd "$HOME/bin/motd-git" && go build
fi

if [ ! -d "$HOME/.config/ghostty" ]; then
  git clone --recurse-submodules git@github.com:Dobefu/ghostty-config.git "$HOME/.config/ghostty"
fi

if [ ! -d "$HOME/.config/zsh" ]; then
  git clone --recurse-submodules git@github.com:Dobefu/zsh-config.git "$HOME/.config/zsh"
  touch "$HOME/.config/zsh/config/private.zsh"
fi
