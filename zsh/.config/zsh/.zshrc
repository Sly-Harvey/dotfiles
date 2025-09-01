# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
ZSH=$ZDOTDIR/.oh-my-zsh/

# Path to powerlevel10k theme
source $ZDOTDIR/.powerlevel10k/powerlevel10k.zsh-theme

ZSH_AUTOSUGGEST_STRATEGY=(history)

# List of plugins used
plugins=(git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting aliases z)
source $ZSH/oh-my-zsh.sh

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="100000"
SAVEHIST="100000"

HISTFILE="${XDG_DATA_HOME}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY

# Key Bindings
# bindkey -s ^t "tmux-sessionizer\n"
# bindkey '^f' "cd $(/nix/store/d8gs5vih8f1nkck5q8jrndzxzdkpsl01-fd-10.2.0/bin/fd . /mnt/work /mnt/work/Projects/ /run/current-system ~/ --max-depth 1 | fzf)\n"
bindkey '^l' "yazi\r"
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# options
unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

function lf {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
            tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
            7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
            echo "Unsupported format"
            return 1
            ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
 fi
}

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

alias -- att='tmux attach'
alias -- attach='tmux attach'
alias -- bc='bc -ql'
alias -- cls=clear
alias -- cp='cp -iv'
alias -- dev='cd /mnt/work/Projects/'
alias -- dots='cd ~/dotfiles'
alias -- find-store-path='function { nix-shell -p $1 --command "nix eval -f \"<nixpkgs>\" --raw $1" }'
alias -- games='cd /mnt/games/'
alias -- grep='grep --color=always'
alias -- l='eza -lh  --icons=auto'
alias -- ld='eza -lhD --icons=auto'
alias -- lg=lazygit
alias -- ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias -- ls='eza -1   --icons=auto'
alias -- media='cd /mnt/work/media/'
alias -- mkd='mkdir -pv'
alias -- mv='mv -iv'
alias -- nf='microfetch'
alias -- nv=nvim
alias -- pokemon='pokego --random 1-8 --no-title'
alias -- proj='cd /mnt/work/Projects/'
alias -- projects='cd /mnt/work/Projects/'
alias -- rm='rm -vI'
alias -- sysup='paru'
alias -- tml='tmux list-sessions'
alias -- tp=trash-put
alias -- tpr=trash-restore
alias -- tree='eza --icons=auto --tree'
alias -- vc='code --disable-gpu'
alias -- work='cd /mnt/work/'
alias -g -- G='| grep'
alias -g -- UUID='$(uuidgen | tr -d \n)'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
# test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh

