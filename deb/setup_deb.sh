curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

# If the ./nvim.appimage command fails, try:
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

git clone https://github.com/stefanhoedl/nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim --headless "+Lazy! sync" +qa

# vs code
sudo apt install apt-transport-https lsb-release wget gpg git gnome-tweaks curl zsh

# notion-enhancer
echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list

# vs code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# signal
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
# cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
#   sudo tee /etc/apt/sources.list.d/signal-xenial.list

# eduvpnn
wget -O- https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --dearmor | sudo tee /usr/share/keyrings/eduvpn-v4.gpg >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/eduvpn-v4.gpg] https://app.eduvpn.org/linux/v4/deb/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/eduvpn-v4.list

# spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list


sudo apt update && sudo apt install signal-desktop eduvpn-client code notion-app-enhanced spotify-client

# zsh 
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

# whatsapp
sudo apt install gconf2 libgconf-2-4 gconf2-common gconf2-service
gnome-extensions install dash-to-dock@micxgx.gmail.com 
gnome-extensions install 
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable wintile@nowsci.com
#https://extensions.gnome.org/extension/1723/wintile-windows-10-window-tiling-for-gnome/
#https://extensions.gnome.org/extension/307/dash-to-dock/

# gnome-control-center
# gsettings get/set
# name 'ZTerminal'
# command 'gnome-terminal'
# binding '<Super>T'

# DOCKER
# sudo usermod -aG docker user_name

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update 
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 

# https://github.com/oOthkOo/whatsapp-desktop
wget -O- https://github.com/oOthkOo/whatsapp-desktop/releases/download/v0.5.2/whatsapp-desktop-x64.deb
sudo apt install ./build/releases/whatsapp-desktop-x64.deb
sudo apt install -f

# discord
wget -O- discord.deb https://discordapp.com/api/download?platform=linux&format=deb
dpkg --install ~/Downloads/discord.deb

# firefox
# https://support.mozilla.org/en-US/kb/install-firefox-linux#w_system-firefox-installation-for-advanced-users
#

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla

sudo apt update && sudo apt install firefox


# conda
curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
sudo install -o root -g root -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg
gpg --keyring /usr/share/keyrings/conda-archive-keyring.gpg --no-default-keyring --fingerprint 34161F5BF5EB1D4BFBBB8F0A8AEB4F8B29D82806

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list

sudo apt update && sudo apt install conda

