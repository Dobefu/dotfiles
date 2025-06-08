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
