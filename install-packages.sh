# Detect the AUR wrapper
if pacman -Qi paru &>/dev/null ; then
   aurhelper="paru -S --skipreview"
elif pacman -Qi yay &>/dev/null ; then
   aurhelper="yay -S"
else
   if [ ! -d "/tmp/paru" ]; then
      sudo pacman -S --needed base-devel git
      git clone https://aur.archlinux.org/paru.git /tmp/paru
      pushd /tmp/paru && makepkg -si
      popd
      aurhelper="paru -S --skipreview"
   else
      pushd /tmp/paru && makepkg -si
      popd
      aurhelper="paru -S --skipreview"
   fi
fi

# for x in $(cat packages-pacman.txt); do sudo pacman -S $x --noconfirm --needed; done
$aurhelper $(cat packages-all.txt)
