"""Build a local student-and-teacher site using the pinned Verso executables.

Run from any directory: python3 /path/to/project/scripts/build_teacher_site.py
The ordinary student-only Lake build and its output are independent of this site.
"""

from pathlib import Path
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / ".lake" / "build"
OUTPUT = BUILD / "literate-html-teacher"
LIBRARIES = ("Cx2026Groups", "Cx2026GroupsTeacher")


def lake(*args):
    subprocess.run(["lake", *args], cwd=ROOT, check=True)


def main():
    BUILD.mkdir(parents=True, exist_ok=True)
    # These libraries use Lake's default source directory and module roots.
    entries = []
    for library in LIBRARIES:
        sources = [ROOT / f"{library}.lean", *sorted((ROOT / library).rglob("*.lean"))]
        for source in sources:
            module = ".".join(source.relative_to(ROOT).with_suffix("").parts)
            entries.append(f"{library}\t{module}\n")

    # Keep our plan and map separate from Lake's student-site build artifacts.
    with tempfile.TemporaryDirectory(prefix="teacher-site-", dir=BUILD) as temporary:
        work = Path(temporary)
        modules = work / "modules"
        plan = work / "plan"
        module_map = work / "module-map"
        html = work / "html"
        config = work / "literate.toml"
        lake("exe", "generateStudent", "--combined-config", str(config))
        modules.write_text("".join(entries), encoding="utf-8")
        lake("exe", "verso-literate-plan", str(modules), str(plan), str(config))
        planned = plan.read_text(encoding="utf-8").splitlines()
        lake("build", *(f"+{module}:literate" for module in planned))
        module_map.write_text(
            "".join(
                f"{module}\t{BUILD / 'literate' / Path(*module.split('.')).with_suffix('.json')}\t{ROOT}\n"
                for module in planned
            ),
            encoding="utf-8",
        )
        lake("exe", "verso-literate-html", str(html), str(module_map), str(config))
        # Replace only after successful rendering; avoid stale pages after renames.
        if OUTPUT.exists():
            shutil.rmtree(OUTPUT)
        html.rename(OUTPUT)

    print(f"Built combined site: {OUTPUT}")
    print("Preview: python3 -m http.server 8001 --bind 127.0.0.1 "
          "--directory .lake/build/literate-html-teacher")


if __name__ == "__main__":
    main()
