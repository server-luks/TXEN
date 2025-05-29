#!/bin/bash

set -e

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

LOGFILE="$HOME/.txen_setup.log"

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 "$pid" 2>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "      \b\b\b\b\b\b"
}

echo -e "${CYAN}🚀 Starting Txen setup...${RESET}"

pkg_install_if_missing() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo -ne "${YELLOW}Installing $1...${RESET}"
    pkg install -y "$1" > "$LOGFILE" 2>&1 &
    spinner $!
    wait $!
    echo -e "${GREEN} Done!${RESET}"
  else
    echo -e "${GREEN}$1 is already installed.${RESET}"
  fi
}

pkg_install_if_missing python
pkg_install_if_missing curl

BIN_DIR="$HOME/bin"
mkdir -p "$BIN_DIR"

TXEN_DIR="$HOME/.txen"
mkdir -p "$TXEN_DIR"

TXEN_PY="$TXEN_DIR/txen.py"
TXEN_URL="https://raw.githubusercontent.com/server-luks/TXEN/refs/heads/main/txen/txen.py"

echo -ne "${YELLOW}Downloading Txen interpreter...${RESET}"
curl -fsSL "$TXEN_URL" -o "$TXEN_PY" > "$LOGFILE" 2>&1 &
spinner $!
wait $!
chmod +x "$TXEN_PY"
echo -e "${GREEN} Done!${RESET}"

WRAPPER="$BIN_DIR/txen"
echo -e "${CYAN}Creating wrapper executable at $WRAPPER...${RESET}"

cat > "$WRAPPER" << EOF
#!/bin/bash
python3 "$TXEN_PY" "\$@"
EOF
chmod +x "$WRAPPER"
echo -e "${GREEN}Wrapper created successfully.${RESET}"

SAMPLE_SCRIPT="$HOME/hello.txen"
cat > "$SAMPLE_SCRIPT" << 'EOF'
print Hello from Txen!
EOF
echo -e "${CYAN}Sample script created at $SAMPLE_SCRIPT.${RESET}"

echo
echo -e "${GREEN}Setup complete! 🎉${RESET}"
echo
echo -e "To run Txen REPL, type: ${YELLOW}txen${RESET}"
echo -e "To run the sample script, type: ${YELLOW}txen hello.txen${RESET}"
echo
echo -e "Make sure ${YELLOW}$BIN_DIR${RESET} is in your PATH environment variable."
echo -e "If not, add this to your shell config (~/.bashrc or ~/.zshrc):"
echo -e "  ${CYAN}export PATH=\"$BIN_DIR:\$PATH\"${RESET}"
echo -e "Then reload your shell or restart Termux."
