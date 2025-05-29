#!/bin/bash

echo "Setting up Txen interpreter..."

# Create txen.py locally
cat > txen.py << 'EOF'
#!/usr/bin/env python3
import sys
import os

def tokenize(line):
    return line.strip().split()

def parse(tokens):
    if not tokens:
        return None
    if tokens[0] == "print":
        return ("print", " ".join(tokens[1:]))
    else:
        raise Exception(f"Unknown command: {tokens[0]}")

def evaluate(ast):
    if ast is None:
        return
    cmd, arg = ast
    if cmd == "print":
        print(arg)

def repl():
    print("Welcome to Txen REPL! Type 'exit' to quit.")
    while True:
        try:
            line = input("txen> ")
            if line.strip() == "exit":
                break
            tokens = tokenize(line)
            ast = parse(tokens)
            evaluate(ast)
        except Exception as e:
            print(f"Error: {e}")

def run_file(filename):
    if not os.path.isfile(filename):
        print(f"Error: File '{filename}' not found.")
        return
    with open(filename, "r") as f:
        for line in f:
            line = line.strip()
            if line == "" or line.startswith("#"):
                continue
            try:
                tokens = tokenize(line)
                ast = parse(tokens)
                evaluate(ast)
            except Exception as e:
                print(f"Error in line: {line}")
                print(f"  {e}")

def main():
    if len(sys.argv) == 1:
        repl()
    else:
        run_file(sys.argv[1])

if __name__ == "__main__":
    main()
EOF

chmod +x txen.py

# Detect bin folder
BIN_DIR="$HOME/bin"
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating bin directory at $BIN_DIR"
    mkdir -p "$BIN_DIR"
fi

# Copy txen.py to bin folder as 'txen'
cp txen.py "$BIN_DIR/txen"
chmod +x "$BIN_DIR/txen"

echo "Txen installed as 'txen' command in $BIN_DIR."

# Optionally create sample script in home folder
cat > "$HOME/hello.txen" << 'EOF'
print Hello from Txen!
EOF

echo "Sample script 'hello.txen' created in your home folder."
echo "You can run the REPL by typing: txen"
echo "You can run the sample script by typing: txen hello.txen"
