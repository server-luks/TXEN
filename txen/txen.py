
from prompt_toolkit import PromptSession
from prompt_toolkit.history import InMemoryHistory
from prompt_toolkit.lexers import PygmentsLexer
from pygments.lexers.special import TextLexer
import time
import sys
import os

# Define a simple lexer (can be replaced with a custom lexer later)
lexer = PygmentsLexer(TextLexer)

# Session for prompt_toolkit (history and arrow key support)
session = PromptSession(history=InMemoryHistory())

# Symbol table
variables = {}
functions = {}

def execute_line(line):
    try:
        if line.startswith("print "):
            print(eval_expr(line[6:].strip()))
        elif line.startswith("wait "):
            time.sleep(float(eval_expr(line[5:].strip())))
        elif line.startswith("let "):
            var, val = line[4:].split("=", 1)
            variables[var.strip()] = eval_expr(val.strip())
        elif line.startswith("fn "):
            name, body = line[3:].split("=>", 1)
            functions[name.strip()] = body.strip()
        elif line.startswith("if "):
            parts = line[3:].split(" then ")
            condition = parts[0].strip()
            action = parts[1].strip() if len(parts) > 1 else ""
            if eval_expr(condition):
                execute_line(action)
        elif line in functions:
            execute_line(functions[line])
        elif line == "exit":
            print("Exiting Txen.")
            sys.exit(0)
        elif line.strip() == "":
            pass  # Ignore empty lines
        else:
            print(f"Syntax Error: Unrecognized command '{line}'")
    except Exception as e:
        print(f"Runtime Error: {e}")

def eval_expr(expr):
    # Replace variable names with values
    for var in variables:
        expr = expr.replace(var, str(variables[var]))
    try:
        return eval(expr)
    except Exception:
        return expr

def run_file(filename):
    if not os.path.exists(filename):
        print(f"File not found: {filename}")
        return
    with open(filename) as f:
        for line in f:
            execute_line(line.strip())

def main():
    if len(sys.argv) > 1:
        run_file(sys.argv[1])
        return

    print("Txen Shell - Type 'exit' to quit")
    while True:
        try:
            line = session.prompt("txen> ", lexer=lexer)
            execute_line(line.strip())
        except KeyboardInterrupt:
            continue
        except EOFError:
            break

if __name__ == "__main__":
    main()
