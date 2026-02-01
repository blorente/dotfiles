from pathlib import Path
import sys

def main(dirpath: Path, extension: str = ""):
    print(f"=== Finding {extension} files in {dirpath} ===", file=sys.stderr)
    for path in dirpath.glob(f'*{extension}'):
        old_name = path.name
        new_name = path.stem.title() + path.suffix
        print(f" -> Renaming {old_name} to {new_name}...", file=sys.stderr, end="", flush=True)
        path.rename(new_name)
        print(" Done", file=sys.stderr, flush=True)


if __name__ == "__main__":
    dirpath = Path(sys.argv[1])
    extension = sys.argv[2]
    if not dirpath.exists() or not dirpath.is_dir():
        print(f"Directory {dirpath} doesn't exist or is not a directory!")
        sys.exit(1)
    main(dirpath, extension)
