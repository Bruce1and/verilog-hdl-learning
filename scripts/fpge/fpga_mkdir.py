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

SUBDIRS = [
    "rtl",
    "tb",
    "sim/bin",
    "sim/wave",
]

def get_date():
    return date.today().strftime("%Y-%m-%d")

def load_template(template_name):
    template_dir = Path(__file__).parent / "templates"
    template_file = template_dir / template_name

    if not template_file.exists():
        print("Missing template.")
        sys.exit(1)
    else:
        return template_file.read_text()

def render_template(content, module_name):
    today = get_date()
    content = content.replace(
        "{{module_name}}",
        module_name
    )

    content = content.replace(
        "{{today}}",
        today
    )

    return content

def create_folders(target_dir):
    """Create FPGA project folders."""

    existing_count = 0
    for sub in SUBDIRS:
        full_dir = target_dir / sub
        if not full_dir.exists():
            full_dir.mkdir(parents = True, exist_ok = True)
            print(f"Created folder: {full_dir.resolve()}")
        else:
            existing_count += 1
    if existing_count == len(SUBDIRS):
        print("Your project folders already existed!")

def get_files(module_name):
    return [
        {
            "folder_name": "rtl",
            "file_name": f"{module_name}.v",
            "template": render_template(
                load_template("rtl.v"),
                module_name
            )
        },
        {
            "folder_name": "tb",
            "file_name": f"{module_name}_tb.v",
            "template": render_template(
                load_template("tb.v"),
                module_name
            )
        }
    ]

def create_files(target_dir, module_name):
    files_to_create = get_files(module_name)

    created_count = 0
    for file_info in files_to_create:
        file_path = target_dir / file_info["folder_name"] / file_info["file_name"]
        if create_file(
            file_path,
            file_info["template"]
        ):
            created_count += 1
    if created_count == 0:
        print("\nNothing to do.")
    else:
        print("\nCompleted.")

def create_file(file_path, content):
    if file_path.exists():
        print(f"{file_path.parent.name} file already exists.")
        return False

    file_path.write_text(content)
    print(f"Created file: {file_path.resolve()}")
    return True

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

    print(f"\nModule name: {module_name}")
    print(f"Project path: {target_dir.resolve()}\n")

    create_folders(target_dir)
    create_files(target_dir, module_name)

if __name__ == "__main__":
    main()
