#!/bin/bash

set -e

echo "🚀 Setting up Txen interpreter..."

BIN_DIR="$HOME/bin"
TXEN_URL="https://raw.githubusercontent.com/server-luks/TXEN/refs/heads/main/txen/txen.py"
TXEN_PATH="$BIN_DIR/txen"

# Create bin directory if it doesn't exist
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating directory: $BIN_DIR"
    mkdir -p "$BIN_DIR"
fi

# Download the txen.py file
echo "Downloading txen.py from GitHub..."
curl -fsSL "$TXEN_URL" -o "$TXEN_PATH"

# Make it executable
chmod +x "$TXEN_PATH"

echo "✅ Txen installed as command 'txen' in $BIN_DIR."

# Create a sample script
cat > "$HOME/hello.txen" << 'EOF'
print Hello from Txen!
EOF

echo "📄 Sample script 'hello.txen' created in your home directory."

echo
echo "To start Txen REPL, run:"
echo "    txen"
echo
echo "To run the sample script, run:"
echo "    txen hello.txen"
echo

echo "⚠️  Make sure '$HOME/bin' is in your PATH environment variable."
echo "If it's not, add this line to your shell config (~/.bashrc or ~/.zshrc):"
echo "    export PATH=\"$HOME/bin:\$PATH\""
echo "Then reload your shell or restart Termux."
