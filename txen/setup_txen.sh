#!/data/data/com.termux/files/usr/bin/bash

# 📦 Txen Setup Script (Termux)
# Author: You + ChatGPT 😎

echo -e "\033[1;36m🚀 Starting Txen Setup...\033[0m"
sleep 0.5

# 1. Make required directories
echo -e "\033[1;34m📁 Creating folders...\033[0m"
mkdir -p $HOME/.txen
mkdir -p $HOME/bin
sleep 0.5

# 2. Install Python if not installed
echo -e "\033[1;34m🐍 Installing Python...\033[0m"
pkg install -y python > $HOME/setup_txen.log 2>&1

# 3. Download txen.py
echo -e "\033[1;34m⬇️ Downloading main Txen file...\033[0m"
curl -s -o $HOME/.txen/txen.py https://raw.githubusercontent.com/server-luks/TXEN/refs/heads/main/txen/txen.py

# 4. Create the txen command
echo -e "\033[1;34m⚙️ Creating launcher command...\033[0m"
echo 'python3 $HOME/.txen/txen.py "$@"' > $HOME/bin/txen
chmod +x $HOME/bin/txen

# 5. Add ~/bin to PATH for both bash and sh
echo -e "\033[1;34m🔧 Updating PATH for bash and sh...\033[0m"
for rc in $HOME/.bashrc $HOME/.profile; do
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$rc"; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$rc"
    fi
done

# 6. Apply it now
export PATH="$HOME/bin:$PATH"

# 7. Done!
echo -e "\033[1;32m✅ Txen is ready to use! Just type:\033[0m \033[1;33mtxen\033[0m"
echo -e "\033[1;90m(Log saved to ~/setup_txen.log)\033[0m"
