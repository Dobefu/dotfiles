#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
ln -sf "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/.gitignore_global" "$HOME/.gitignore_global"
ln -sf "$DOTFILES/.profile" "$HOME/.profile"
ln -sf "$DOTFILES/.sshrc" "$HOME/.sshrc"
ln -sf "$DOTFILES/.sshrc.d" "$HOME/.sshrc.d"
ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.config/gtk-2.0" "$HOME/.config/gtk-2.0"
ln -sf "$DOTFILES/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
ln -sf "$DOTFILES/.config/gtk-4.0" "$HOME/.config/gtk-4.0"

if [ ! -d "$HOME/.config/nvim" ]; then
  git clone git@github.com:Dobefu/nvim-config.git "$HOME/.config/nvim"
fi

if [ ! -d "$HOME/bin" ]; then
  git clone git@github.com:Dobefu/bin.git "$HOME/bin"
fi

if [ ! -d "$HOME/.config/ghostty" ]; then
  git clone git@github.com:Dobefu/ghostty-config.git "$HOME/.config/ghostty"
fi

if [ ! -d "$HOME/.config/zsh" ]; then
  git clone git@github.com:Dobefu/zsh-config.git "$HOME/.config/zsh"
fi
