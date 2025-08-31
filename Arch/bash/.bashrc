#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

export TERM="xterm-256color"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
# export STARSHIP_CONFIG=~/.config/starship/starship-pastel.toml

### PATH
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.emacs.d/bin" ] ;
  then PATH="$HOME/.emacs.d/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi

if [ -d "/var/lib/flatpak/exports/bin/" ] ;
  then PATH="/var/lib/flatpak/exports/bin/:$PATH"
fi

if [ -d "$HOME/.config/emacs/bin/" ] ;
  then PATH="$HOME/.config/emacs/bin/:$PATH"
fi

_set_liveuser_PS1() {
    PS1='[\u@\h \W]\$ '
    if [ "$(whoami)" = "liveuser" ] ; then
        local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
        if [ -n "$iso_version" ] ; then
            local prefix="eos-"
            local iso_info="$prefix$iso_version"
            PS1="[\u@$iso_info \W]\$ "
        fi
    fi
}
_set_liveuser_PS1
unset -f _set_liveuser_PS1

ShowInstallerIsoInfo() {
    local file=/usr/lib/endeavouros-release
    if [ -r $file ] ; then
        cat $file
    else
        echo "Sorry, installer ISO info is not available." >&2
    fi
}

cgen() {
  mkdir $1
  cd $1
  touch CMakeLists.txt
  cat $ZSH/templates/ListTemplate.txt >> CMakeLists.txt
  mkdir src
  mkdir include
  touch src/main.cpp
  cat $ZSH/templates/HelloWorldTemplate.txt >> src/main.cpp
}

crun() {
  #VAR=${1:-.} 
  mkdir build 2> /dev/null
  cmake -B build
  cmake --build build
  build/main
}

crun-mingw() {
  #VAR=${1:-.} 
  mkdir build-mingw 2> /dev/null
  x86_64-w64-mingw32-cmake -B build-mingw
  make -C build-mingw
  build-mingw/main.exe
}

cbuild() {
  mkdir build 2> /dev/null
  cmake -B build
  cmake --build build
}

cbuild-mingw() {
  mkdir build-mingw 2> /dev/null
  x86_64-w64-mingw32-cmake -B build-mingw
  make -C build-mingw
}

alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."
alias cls='clear'
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias zshrc='nvim ~/.zshrc'
alias vc='code --disable-gpu' # gui code editor
alias nv='nvim'
alias nf='neofetch'
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias bc="bc -ql"
alias mkd="mkdir -pv"
alias tp="trash-put"
alias tpr="trash-restore"
alias grep='grep --color=always'

# Nixos
alias list-gens='sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/'

# Directory Shortcuts.
alias dev='cd /mnt/seagate/dev/'
alias dots='cd ~/.dotfiles/'
alias nvimdir='cd ~/.config/nvim/'
alias cppdir='cd /mnt/seagate/dev/C++/'
alias zigdir='cd /mnt/seagate/dev/Zig/'
alias csdir='cd /mnt/seagate/dev/C#/'
alias rustdir='cd /mnt/seagate/dev/Rust/'
alias pydir='cd /mnt/seagate/dev/Python/'
alias javadir='cd /mnt/seagate/dev/Java/'
alias luadir='cd /mnt/seagate/dev/lua/'
alias webdir='cd /mnt/seagate/dev/Website/'
alias seagate='cd /mnt/seagate/'
alias media='cd /mnt/seagate/media/'
alias games='cd /mnt/games/'

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.
##
## October 2021: removed many obsolete functions. If you still need them, please look at
## https://github.com/EndeavourOS-archive/EndeavourOS-archiso/raw/master/airootfs/etc/skel/.bashrc

_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1:
    #    - Do not use for executable files!
    # Note2:
    #    - Uses 'mime' bindings, so you may need to use
    #      e.g. a file manager to make proper file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $@" >&2
        setsid exo-open "$@" >& /dev/null
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            setsid xdg-open "$file" >& /dev/null
        done
        return
    fi

    echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=eos-pacdiff
################################################################################

if command -v starship; then
  eval "$(starship init bash)"
fi

