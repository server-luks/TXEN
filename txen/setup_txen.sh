#!/data/data/com.termux/files/usr/bin/bash

echo -e "\033[1;36m🚀 Starting Txen Setup...\033[0m"
sleep 0.5

# Step 1: Create required folders
echo -e "\033[1;34m📁 Creating folders...\033[0m"
mkdir -p $HOME/.txen
mkdir -p $HOME/bin
sleep 0.3

# Step 2: Install Python silently
echo -e "\033[1;34m🐍 Installing Python...\033[0m"
pkg install -y python > $HOME/setup_txen.log 2>&1

# Step 3: Download txen.py
echo -e "\033[1;34m⬇️ Downloading main Txen file...\033[0m"
curl -s -o $HOME/.txen/txen.py https://raw.githubusercontent.com/server-luks/TXEN/refs/heads/main/txen/txen.py

# Step 4: Create txen launcher script in ~/bin
echo -e "\033[1;34m⚙️ Creating launcher command...\033[0m"
echo 'python3 $HOME/.txen/txen.py "$@"' > $HOME/bin/txen
chmod +x $HOME/bin/txen

# Step 5: Ensure ~/bin is in PATH
echo -e "\033[1;34m🔧 Adding ~/bin to PATH (profile)...\033[0m"
touch $HOME/.profile
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.profile"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
fi
export PATH="$HOME/bin:$PATH"

# Step 6: Reload shell profile
echo -e "\033[1;34m🔁 Reloading shell...\033[0m"
source $HOME/.profile
sleep 0.5

# Step 7: Clear and finish
clear
echo -e "\033[1;32m✅ Txen installation complete!\033[0m"
echo -e ""
echo -e "\033[1;33m📜 How to use Txen:\033[0m"
echo -e " - Run \033[1;36mtxen\033[0m to open the interactive shell"
echo -e " - Run \033[1;36mtxen yourfile.txn\033[0m to execute a Txen script"
echo -e ""
echo -e "\033[1;90m(Installer log saved at ~/setup_txen.log)\033[0m"
