"""
===============================================
Create FPGA project directory structure.
Usage:
    python fpga_mkdir.py <module_name> [path]
===============================================
"""

from pathlib import Path
import sys

SUBDIRS = [
        "rtl",
        "tb",
        "sim/bin",
        "sim/wave",
        ]

def create_folder(target_dir):
    """Create FPGA project folders."""

    created = 0
    for sub in SUBDIRS:
        full_dir = target_dir / sub
        if not full_dir.exists():
            full_dir.mkdir(parents = True, exist_ok = True)
            print(f"created folder: {full_dir}")
        else:
            created += 1
    if created == len(SUBDIRS):
        print("Your project files already existed!")

def create_file(target_dir, module_name):
    """Create FPGA project files"""

    rtl_file = target_dir / "rtl" / f"{module_name}.v"
    tb_file = target_dir / "tb" / f"{module_name}_tb.v"

    if rtl_file.exists():
        print("The RTL file already exists")
    else:
        with open(rtl_file, "w") as f:
            f.write("/*\n")
            f.write(f"Module: {module_name}\n")
            f.write("Description: \n")
            f.write("\n")
            f.write("Function: \n")
            f.write("*/\n")
            f.write("\n")
            f.write(f"module {module_name} (\n")
            f.write("input clk_i,\n")
            f.write("input rst_n,\n")
            f.write(");\n")
            f.write("\n")
            f.write("endmodule")
            print(f"{rtl_file} was created.\n")

    if tb_file.exists():
        print("The tb file already exists")
    else:
        with open(tb_file, "w") as f:
            f.write(f"module {module_name}_tb;\n")
            f.write("reg clk;\n")
            f.write("reg rst_n;\n")
            f.write("\n")
            f.write("always #10 clk = ~clk;\n")
            f.write("initial begin \n")
            f.write("clk = 1'b0;\n")
            f.write("rst_n = 1'b0;\n")
            f.write("#100\n")
            f.write("rst_n = ~rst_n\n")
            f.write("end\n")
            f.write("\n")
            f.write("endmodule")
            print(f"{tb_file} was created.\n")

def main():
    current_dir = Path.cwd()
    match len(sys.argv):
        case 2:
            module_name = sys.argv[1]
            target_dir = current_dir / module_name
        case 3:
            module_name = sys.argv[1]
            target_dir = Path(sys.argv[2]) / module_name
        case _:
            print("rule: python new_module.py <module name>")
            sys.exit(1)
    create_folder(target_dir)
    create_file(target_dir, module_name)
    print("completed!")

if __name__ == "__main__":
    main()
