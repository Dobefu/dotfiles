#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

ln -sfF "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
ln -sfF "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sfF "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sfF "$DOTFILES/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
ln -sfF "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sfF "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
ln -sfF "$DOTFILES/.hushlogin" "$HOME/.hushlogin"
ln -sfF "$DOTFILES/.profile" "$HOME/.profile"
ln -sfF "$DOTFILES/.sshrc" "$HOME/.sshrc"
ln -sfF "$DOTFILES/.sshrc.d" "$HOME/.sshrc.d"
ln -sfF "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sfF "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sfF "$DOTFILES/gtk-2.0" "$HOME/.config/gtk-2.0"
ln -sfF "$DOTFILES/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sfF "$DOTFILES/gtk-4.0" "$HOME/.config/gtk-4.0"
ln -sfF "$DOTFILES/dolphinrc" "$HOME/.config/dolphinrc"
ln -sfF "$DOTFILES/hypr" "$HOME/.config/hypr"
ln -sfF "$DOTFILES/qt5ct" "$HOME/.config/qt5ct"
ln -sfF "$DOTFILES/qt6ct" "$HOME/.config/qt6ct"
ln -sfF "$DOTFILES/waybar" "$HOME/.config/waybar"

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
