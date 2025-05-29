import readline
import time
import sys
import os
import re

variables = {}
functions = {}
in_function = False
function_body = []
function_name = ""

def colorize(code):
    code = re.sub(r'\".*?\"', lambda m: f'\033[93m{m.group(0)}\033[0m', code)  # Strings yellow
    code = re.sub(r'\b(let|print|input|wait|if|elif|else|loop|end|func|return|clear|run|show)\b', 
                  lambda m: f'\033[96m{m.group(0)}\033[0m', code)  # Keywords cyan
    code = re.sub(r'\b([a-zA-Z_][a-zA-Z0-9_]*)\b', 
                  lambda m: f'\033[94m{m.group(0)}\033[0m' if m.group(0) in variables else m.group(0), code)
    return code

def run_txen_code(code):
    global in_function, function_body, function_name

    code = code.strip()
    if not code or code.startswith("#"):
        return

    if in_function:
        if code == "end":
            functions[function_name] = list(function_body)
            in_function = False
            function_body = []
            function_name = ""
        else:
            function_body.append(code)
        return

    if code.startswith("print "):
        msg = code[6:].strip().strip('"')
        print(msg)

    elif code.startswith("wait "):
        try:
            time.sleep(float(code[5:].strip()))
        except ValueError:
            print("Invalid wait time")

    elif code.startswith("input "):
        prompt = code[6:].strip().strip('"')
        val = input(prompt + ": ")
        variables['_'] = val

    elif code.startswith("let "):
        parts = code[4:].split('=')
        if len(parts) == 2:
            var = parts[0].strip()
            val = parts[1].strip()
            if val.isdigit():
                variables[var] = int(val)
            else:
                variables[var] = val.strip('"')
        else:
            print("Invalid syntax")

    elif code.startswith("show "):
        var = code[5:].strip()
        print(variables.get(var, f"{var} not defined"))

    elif code.startswith("if "):
        condition = code[3:].strip(':')
        try:
            if not eval(condition, {}, variables):
                skip_block()
        except:
            print("Error in if condition")

    elif code.startswith("loop "):
        try:
            count = int(code[5:].strip(':'))
            loop_block(count)
        except ValueError:
            print("Invalid loop count")

    elif code.startswith("func "):
        in_function = True
        function_name = code[5:].strip('():')

    elif code.startswith("call "):
        name = code[5:].strip()
        if name in functions:
            for line in functions[name]:
                run_txen_code(line)
        else:
            print(f"Function '{name}' not found.")

    elif code == "clear":
        os.system("clear" if os.name == "posix" else "cls")

    elif code.startswith("run "):
        file = code[4:].strip().strip('"')
        if os.path.isfile(file):
            with open(file) as f:
                for line in f:
                    run_txen_code(line.strip())
        else:
            print(f"File '{file}' not found.")

    elif code == "exit":
        sys.exit(0)

    else:
        print("Unknown command")

def skip_block():
    print("Skipping block (not implemented yet)")

def loop_block(count):
    print("Looping block (not implemented yet)")

def interactive_shell():
    print("Txen Shell Ready. Type 'exit' to quit.")
    while True:
        try:
            command = input("txen> ")
            print(colorize(command))
            run_txen_code(command)
        except KeyboardInterrupt:
            print("\nUse 'exit' to quit")
        except EOFError:
            break

def run_file(file_path):
    if not os.path.isfile(file_path):
        print(f"File not found: {file_path}")
        return
    with open(file_path) as f:
        for line in f:
            run_txen_code(line.strip())

if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_file(sys.argv[1])
    else:
        interactive_shell()
