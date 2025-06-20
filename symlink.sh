#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

ln -sfT "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
ln -sfT "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sfT "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sfT "$DOTFILES/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
ln -sfT "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sfT "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
ln -sfT "$DOTFILES/.hushlogin" "$HOME/.hushlogin"
ln -sfT "$DOTFILES/.profile" "$HOME/.profile"
ln -sfT "$DOTFILES/.sshrc" "$HOME/.sshrc"
ln -sfT "$DOTFILES/.sshrc.d" "$HOME/.sshrc.d"
ln -sfT "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sfT "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sfT "$DOTFILES/gtk-2.0" "$HOME/.config/gtk-2.0"
ln -sfT "$DOTFILES/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sfT "$DOTFILES/gtk-4.0" "$HOME/.config/gtk-4.0"
ln -sfT "$DOTFILES/dolphinrc" "$HOME/.config/dolphinrc"
ln -sfT "$DOTFILES/hypr" "$HOME/.config/hypr"
ln -sfT "$DOTFILES/qt5ct" "$HOME/.config/qt5ct"
ln -sfT "$DOTFILES/qt6ct" "$HOME/.config/qt6ct"
ln -sfT "$DOTFILES/waybar" "$HOME/.config/waybar"

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
