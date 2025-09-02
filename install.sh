#!/usr/bin/env bash

echo "GIT: Cloning submodules..."
git submodule update --init

# Detect if running on Arch-based distro
isArch=false
if command -v pacman &> /dev/null; then
    isArch=true
fi

# Find package manager
if command -v brew &> /dev/null; then
    install="brew install"
else
    declare -A osInfo;
    osInfo[/etc/arch-release]="sudo pacman --noconfirm -S"
    osInfo[/etc/fedora-release]="sudo dnf install -y"
    osInfo[/etc/centos-release]="sudo yum install -y"
    osInfo[/etc/gentoo-release]="sudo emerge"
    osInfo[/etc/SuSE-release]="sudo zypper install"
    osInfo[/etc/debian_version]="sudo apt-get install -y"
    osInfo[/etc/alpine-release]="sudo apk --update add"
    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            install=${osInfo[$f]}
        fi
    done
fi

# Execute Arch package installation if on Arch-based system
# if [ "$isArch" = true ] && [ -f "install-packages.sh" ]; then
#     echo "Detected Arch-based system. Running package installation..."
#     ./install-packages.sh
# fi
#
if command -v lact &> /dev/null; then
    sudo systemctl enable --now lactd
fi

if ! command -v stow &> /dev/null; then
    $install "stow"
fi

# sddm theme
sudo cp -r ./sddm/sddm-astronaut-theme /usr/share/sddm/themes/
sudo cp -r ./sddm/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf

set -e
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# DOT_FOLDERS="bin,home,alacritty,btop,cava,hypr,i3,icons,kitty,Kvantum,lazygit,lf,MangoHud,mpv,neofetch,picom,rofi,starship,swappy,swaync,tmux,waybar,wezterm,wlogout,yazi,zsh"
# TODO: review swappy config
# TODO: add: bin
DOT_FOLDERS="
    bin
    cava
    home
    hypr
    themes
    kitty
    lazygit
    MangoHud
    mpv
    neofetch
    nvim
    rofi
    starship
    swappy
    swaync
    tmux
    wallpapers
    waybar
    wlogout
    yazi
    zsh
"

if [ ! -L "$HOME/.config/hypr/hyprland.conf" ]; then
   rm -f "$HOME/.config/hypr/hyprland.conf"
fi

for folder in $DOT_FOLDERS; do
    [ -z "$folder" ] && continue

    # echo "[+] SYMLINK :: $folder"
    stow -t $HOME -D $folder -v \
        --ignore=README.md --ignore=LICENSE \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
    stow -t $HOME $folder -v \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
done

sudo sed -i -e 's/^#BottomUp/BottomUp/' /etc/paru.conf
sudo sed -i -e 's/^#Color/Color/' /etc/pacman.conf

# Set catppuccin theme
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Mauve'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

chsh -s $(grep /zsh$ /etc/shells | tail -1)

# Reload shell once installed
echo "Reloading shell..."
echo "Done!"
exec $SHELL -l
