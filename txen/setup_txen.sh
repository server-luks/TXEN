#!/bin/bash

set -e

echo "🚀 Setting up Txen interpreter..."

# Check for essential packages (python, curl)
pkg_install_if_missing() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo "$1 not found. Installing $1..."
    pkg install -y "$1"
  else
    echo "$1 already installed."
  fi
}

pkg_install_if_missing python
pkg_install_if_missing curl

# Create bin directory if missing
BIN_DIR="$HOME/bin"
if [ ! -d "$BIN_DIR" ]; then
  echo "Creating bin directory: $BIN_DIR"
  mkdir -p "$BIN_DIR"
fi

# Create a hidden folder to keep the actual interpreter code clean and out of sight
TXEN_DIR="$HOME/.txen"
if [ ! -d "$TXEN_DIR" ]; then
  echo "Creating Txen directory: $TXEN_DIR"
  mkdir -p "$TXEN_DIR"
fi

# Download the interpreter to the hidden folder
TXEN_PY="$TXEN_DIR/txen.py"
TXEN_URL="https://raw.githubusercontent.com/server-luks/TXEN/refs/heads/main/txen/txen.py"

echo "Downloading Txen interpreter to $TXEN_PY ..."
curl -fsSL "$TXEN_URL" -o "$TXEN_PY"
chmod +x "$TXEN_PY"

# Create a small wrapper script in ~/bin that calls the interpreter with python3
WRAPPER="$BIN_DIR/txen"
echo "Creating wrapper executable at $WRAPPER ..."

cat > "$WRAPPER" << EOF
#!/bin/bash
python3 "$TXEN_PY" "\$@"
EOF

chmod +x "$WRAPPER"

echo "✅ Installed 'txen' command in $WRAPPER"

# Create sample script in home folder
SAMPLE_SCRIPT="$HOME/hello.txen"
cat > "$SAMPLE_SCRIPT" << 'EOF'
print Hello from Txen!
EOF

echo "📄 Created sample script at $SAMPLE_SCRIPT"

echo
echo "To run Txen REPL, type:"
echo "    txen"
echo
echo "To run the sample script, type:"
echo "    txen hello.txen"
echo
echo "Make sure '$BIN_DIR' is in your PATH environment variable."
echo "If not, add this to your shell config file (~/.bashrc or ~/.zshrc):"
echo "    export PATH=\"$BIN_DIR:\$PATH\""
echo "Then reload your shell or restart Termux."
