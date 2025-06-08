#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
ln -sf "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/.config/gtk-2.0" "$HOME/.config/gtk-2.0"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
ln -sf "$DOTFILES/.hushlogin" "$HOME/.hushlogin"
ln -sf "$DOTFILES/.profile" "$HOME/.profile"
ln -sf "$DOTFILES/.sshrc" "$HOME/.sshrc"
ln -sf "$DOTFILES/.sshrc.d" "$HOME/.sshrc.d"
ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/gtk-2.0" "$HOME/.gtk-2.0"
ln -sf "$DOTFILES/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sf "$DOTFILES/gtk-4.0" "$HOME/.config/gtk-4.0"
ln -sf "$DOTFILES/waybar" "$HOME/.config/waybar"
ln -sf "$DOTFILES/hypr" "$HOME/.config/hypr"
ln -sf "$DOTFILES/qt5ct" "$HOME/.config/qt5ct"
ln -sf "$DOTFILES/qt6ct" "$HOME/.config/qt6ct"

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
