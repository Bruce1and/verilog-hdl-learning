"""
=================================================
Funtion: auto creat FPGA stand folders sturture
Mothel: python fpge.py <module_name>
=================================================
"""

import os
import pathlib
import sys

if len(sys.argv) < 2:
    print("rule: python fifo.py <module_name>")
    sys.exit(1)

# define variations
module_name = sys.argv[1]

current_dir = pathlib.Path.cwd() # cwd: Current Working Directory
target_dir = None # default target_dir is empty

# make sure directory had existed
for path in current_dir.rglob(module_name): # rglob: recursive glob, find  directorys
    if path.is_dir(): # is_dir: is folder
        target_dir = path
        break

# if folder is not created
if target_dir is None:
    target_dir = current_dir / module_name
    print(f"Can not find folder: '{module_name}', creat a new folder: {target_dir}")

subdirs = [
    "rtl",
    "tb",
    "sim/bin",
    "sim/wave",
]

for sub in subdirs:
    full_path = target_dir / sub
    full_path.mkdir(parents = True, exist_ok = True)
    print(f"created folder: {full_path}")

print("completed!")
