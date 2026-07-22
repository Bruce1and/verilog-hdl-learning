"""
===============================================
Create FPGA project directory structure.
Usage:
    python fpga_mkdir.py <module_name> [path]
===============================================
"""

from pathlib import Path
from datetime import date
import argparse
import sys
import subprocess


def get_date():
    return date.today().strftime("%Y-%m-%d")

def load_template(template_name):
    template_dir = Path(__file__).parent / "templates"
    template_file = template_dir / template_name

    if not template_file.exists():
        print(f"Missing template {template_file}.")
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

def project_base(target_dir, module_name):

    return [
        {
            "folder_path": target_dir / "rtl",
            "file_path": target_dir / "rtl" / f"{module_name}.v",
            "template": render_template(
                load_template("rtl.v"),
                module_name
            )
        },
        {
            "folder_path": target_dir / "tb",
            "file_path": target_dir / "tb" / f"{module_name}_tb.v",
            "template": render_template(
                load_template("tb.v"),
                module_name
            )
        },
        {
            "folder_path": target_dir / "sim" / "bin",
            "file_path": target_dir / "sim" / "bin" / f"{module_name}_sim",
            "template": None
        },
        {
            "folder_path": target_dir / "sim" / "wave",
            "file_path": target_dir / "sim" / "wave" / f"{module_name}_tb.vcd",
            "template": None
        },
        {
            "folder_path": None,
            "file_path": target_dir / "fpga.toml",
            "template": None
        }
    ]

def create_folder(folder_path):
    """Create FPGA project folders."""

    if folder_path is not None:
        if folder_path.exists():
            print(f"Already exists: {folder_path.resolve()}")
            return
        folder_path.mkdir(parents = True, exist_ok = True)
        print(f"Created: {folder_path.resolve()}")

def create_file(file_path, content):

    if file_path.exists():
        print(f"Already exists: {file_path.resolve()}")
        return
    if content is not None:
        insert_template(file_path, content)
        print(f"Created: {file_path.resolve()}")
    else:
        file_path.touch(exist_ok = True)
        print(f"Created: {file_path.resolve()}")

def insert_template(file_path, content):
    file_path.write_text(content)

def check_syntax(files_path):
    v_files = [str(f) for f in files_path.rglob("*.v")]
    result = subprocess.run([
        "iverilog", "-g2012", "-Wall", "-t", "null"] + v_files,
        capture_output = True,
        text = True
    )

    if result.returncode == 0:
        print("Pass\n")
        for f in v_files:
            print(f)
    else:
        print("False\n")
        print(result.stdout)
        print(result.stderr)
        for f in v_files:
            print(f)

def find_project_root():
    current_path = Path.cwd()
    while current_path != current_path.parent:
        marker = current_path / "fpga.toml"
        if marker.exists():
            return current_path
        current_path = current_path.parent
    return None

def compile_files(rtl_path, tb_path, module_name):
    result = subprocess.run([
            "iverilog",
            "-g2012",
            "-o",
            f"{module_name}_sim",
            "null"
        ]
        + glob.glob("rtl/*.v"),
        + glob.glob("tb/*.v"),
        capture_output = True,
        text = True
    )
    print(result.stdout)
    print(result.stderr)


def main():

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest = "command", required = True)
    """ init parser """
    init_parser = subparsers.add_parser(
        "init",
        help = "Create FPGA project directory structure."
    )
    init_parser.add_argument(
        "module_name",
        type = str,
        help = "The name of the module to be created"
    )
    init_parser.add_argument(
        "output_path",
        nargs = "?",
        type = Path,
        default = Path.cwd(),
        help = "Display the path to the module to be created"
    )

    """ check parser """

    check_parser = subparsers.add_parser(
        "check",
        help = "Skip testbench file generation"
    )

    """ sim parser """

    compile_parser = subparsers.add_parser(
        "compile",
        help = "Skip testbench file generation"
    )
    compile_parser.add_argument(
        "module_name",
        type = str,
        help = "The name of the module to be created"
    )
    compile_parser.add_argument(
        "output_path",
        type = Path,
        help = "Display the path to the module to be created"
    )

    """ open wave parser """

    open_wave_parser = subparsers.add_parser(
        "open_wave",
        help = "Skip testbench file generation"
    )
    open_wave_parser.add_argument(
        "module_name",
        type = str,
        help = "The name of the module to be created"
    )
    open_wave_parser.add_argument(
        "output_path",
        nargs = "?",
        type = Path,
        default = Path.cwd(),
        help = "Display the path to the module to be created"
    )

    current_dir = Path.cwd()
    args = parser.parse_args()

    if args.command == "init":
        if not args.module_name.isidentifier():
            print("Please enter a valid module name.")
            sys.exit(1)
        module_name = args.module_name

        target_dir = args.output_path / module_name
        files_info = project_base(target_dir, module_name)
        for entry in files_info:
            folder_path = entry["folder_path"]
            file_path = entry["file_path"]

            create_folder(folder_path)
            if folder_path not in ["wave", "bin"]:
            # if not file_path.endswith("_sim") or file_path.endswith(".vcd")
                create_file(file_path, entry["template"])
    else:
        project_root = find_project_root()
        if project_root is None:
            print("Not a FPGA project.")
            sys.exit()
        check_syntax(project_root)





if __name__ == "__main__":
    main()
