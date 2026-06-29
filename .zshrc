local BASE_DIR="$HOME"
local ZSH_DIR="$BASE_DIR/.config/zsh"

# Display the MOTD.
$BASE_DIR/bin/motd

# Load plugins.
. $ZSH_DIR/plugins/gitstatus/gitstatus.plugin.zsh
. $ZSH_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
. $ZSH_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. $ZSH_DIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Load config.
. $ZSH_DIR/config/keybindings.zsh
. $ZSH_DIR/config/gitstatus.zsh
. $ZSH_DIR/config/prompt.zsh
. $ZSH_DIR/config/history.zsh
. $ZSH_DIR/config/completion.zsh
. $ZSH_DIR/config/aliases.zsh
. $ZSH_DIR/config/exports.zsh
. $ZSH_DIR/config/functions.zsh
. $ZSH_DIR/config/private.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/connor.vanspronssen/.lmstudio/bin"
# End of LM Studio CLI section


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/dobefu/.lmstudio/bin"
# End of LM Studio CLI section

