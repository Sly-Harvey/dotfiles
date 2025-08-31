# Detect the AUR wrapper
if pacman -Qi paru &>/dev/null ; then
   aurhelper="paru -S --skipreview"
elif pacman -Qi yay &>/dev/null ; then
   aurhelper="yay -S"
fi

# for x in $(cat list.txt); do sudo pacman -S $x --noconfirm --needed; done
$aurhelper $(cat list.txt)
