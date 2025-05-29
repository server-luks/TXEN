#!/usr/bin/env python3

import sys
import os
import time

def cmd_print(args):
    print(" ".join(args))

def cmd_wait(args):
    if args:
        try:
            time.sleep(float(args[0]))
        except ValueError:
            print("wait: invalid number")

def cmd_input(args):
    input(" ".join(args))

def cmd_clear(args):
    os.system("clear" if os.name != "nt" else "cls")

def cmd_exit(args):
    sys.exit()

commands = {
    "print": cmd_print,
    "wait": cmd_wait,
    "input": cmd_input,
    "clear": cmd_clear,
    "exit": cmd_exit,
}

def run_line(line):
    line = line.strip()
    if not line or line.startswith("#"):
        return
    parts = line.split()
    cmd, args = parts[0], parts[1:]
    if cmd in commands:
        commands[cmd](args)
    else:
        print(f"Unknown command: {cmd}")

def run_script(path):
    if not os.path.isfile(path):
        print(f"Error: file '{path}' not found.")
        return
    with open(path) as f:
        for line in f:
            run_line(line)

def repl():
    print("Txen REPL - type 'exit' to quit")
    while True:
        try:
            line = input(">>> ")
            run_line(line)
        except KeyboardInterrupt:
            print("\nUse 'exit' to quit.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_script(sys.argv[1])
    else:
        repl()
