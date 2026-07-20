"""
===============================================
Create FPGA project directory structure.
Usage:
    python fpga_mkdir.py <module_name> [path]
===============================================
"""

from pathlib import Path
from datetime import date
import sys

today = date.today().strftime("%Y-%m-%d")

SUBDIRS = [
        "rtl",
        "tb",
        "sim/bin",
        "sim/wave",
        ]

def create_folders(target_dir):
    """Create FPGA project folders."""

    existing_files = 0
    for sub in SUBDIRS:
        full_dir = target_dir / sub
        if not full_dir.exists():
            full_dir.mkdir(parents = True, exist_ok = True)
            print(f"Created folder: {full_dir.resolve()}")
        else:
            existing_files += 1
    if existing_files == len(SUBDIRS):
        print("Your project floders already existed!")

def create_files(target_dir, module_name):
    tb_template = f"""\
/*
testbench: {module_name}_tb
Module under test: 
Description: 

Author: 
Date: {today}
Version: 

Updata history:

*/

`timescale 1ns / 1ps
module {module_name}_tb;
    reg clk;
    reg rst_n;

    {module_name} u_{module_name}(
        .clk_i(clk),
        .rst_n(rst_n)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;

        #100 rst_n = 1;

        #20;
        #100;
        $finish;
    end

    initial begin
        $dumpfile("sim/wave/{module_name}_tb.vcd");
        $dumpvars(0, {module_name}_tb);
    end

endmodule"""

    rtl_template = f"""\
/*
Module: {module_name}
Description: 
Function: 

Author: 
Date: {today}
Version: 

Updata history:

*/

module {module_name} #(

)(
    input clk_i,
    input rst_n

);


    always @(posedge clk_i or negedge rst_n) begin
        if(!rst_n) begin
            
        end else begin
            
        end
    end

endmodule"""

    file_index = {"rtl": f"{module_name}.v", "tb": f"{module_name}_tb.v"}
    template = {"rtl": rtl_templata, "tb": tb_template}
    existing_files = 0
    for floder in file_index:
        file_dir = target_dir/floder/file_index(floder)
        if not file_dir.exists():
            file_dir.write_text(template[floder])
            print(f"Created file: {file_dir.resolve()}")
        else:
            existing_files += 1

    if len(file_index) == existing_files:
        print("Your project files already existed!")

def files_detect(target_dir, module_name):
    file_index = {"rtl": f"{module_name}.v", "tb": f"{module_name}_tb.v"}
    for floder in file_index:
        file_path = target_dir/folder/file_index(folder)
        if file_path.exists():
            return file_path, files_existing
        
    


def main():
    current_dir = Path.cwd()
    if len(sys.argv) < 2:
        print("Usage: python fpga_mkdir.py <module name>.")
        sys.exit(1)
    if sys.argv[1].isidentifier():
        module_name = sys.argv[1]
    else:
        print("Please enter a valid module name.")
        sys.exit(1)
    match len(sys.argv):
        case 2:
            target_dir = current_dir / module_name
        case 3:
            target_dir = Path(sys.argv[2]) / module_name
        case _:
            print("Usage: python fpga_mkdir.py <module name>.")
            sys.exit(1)

    print(f"Module name: {module_name}")
    print(f"Project path: {target_dir.resolve()}")

    file_pathfiles_detect(target_dir, module_name)

    while True:
        start = input("Are you sure you want to create files? (y/n): ")
        if start == "y":
            create_folders(target_dir)
            create_file(target_dir, module_name)
            print("completed!")
            break
        elif start == "n":
            sys.exit(1)
        else:
            continue

if __name__ == "__main__":
    main()
