"""Install, update, and launch an isolated Neovim profile."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent
LOCAL = ROOT / ".local"
RELEASE = "https://api.github.com/repos/neovim/neovim/releases/latest"


def run(*args, **kwargs):
    return subprocess.run(args, check=True, **kwargs)


def environment():
    env = dict(os.environ)
    env.update(
        PORTABLE_NVIM_ROOT=str(ROOT), NVIM_APPNAME="config",
        XDG_CONFIG_HOME=str(ROOT), XDG_DATA_HOME=str(LOCAL / "data"),
        XDG_STATE_HOME=str(LOCAL / "state"), XDG_CACHE_HOME=str(LOCAL / "cache"),
        XDG_CONFIG_DIRS=str(LOCAL / "empty"), XDG_DATA_DIRS=str(LOCAL / "empty"),
    )
    for key in ("VIM", "VIMRUNTIME", "VIMINIT", "EXINIT", "MYVIMRC", "NVIM"):
        env.pop(key, None)
    return env


def installed_binary():
    subpath = "bin/nvim.exe" if os.name == "nt" else "bin/nvim"
    binary = LOCAL / "neovim" / subpath
    return str(binary) if binary.is_file() else shutil.which("nvim")


def download_editor():
    system = {"Darwin": "macos", "Linux": "linux", "Windows": "win64"}.get(platform.system())
    arch = {"arm64": "arm64", "aarch64": "arm64", "amd64": "x86_64", "x86_64": "x86_64"}.get(platform.machine().lower())
    if not system or not arch or (system == "win64" and arch != "x86_64"):
        raise RuntimeError("No bundled installer for this platform. Install Neovim 0.12+ on PATH and use --system.")
    name = "nvim-win64.zip" if system == "win64" else f"nvim-{system}-{arch}.tar.gz"
    release = json.loads(run("curl", "-fsSL", "--max-time", "30", RELEASE, capture_output=True).stdout)
    asset = next((a for a in release["assets"] if a["name"] == name), None)
    if not asset or not (asset.get("digest") or "").startswith("sha256:"):
        raise RuntimeError(f"Cannot verify the upstream release asset {name}")
    LOCAL.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(dir=LOCAL) as tmp:
        archive = Path(tmp) / name
        run("curl", "-fsSL", "--max-time", "120", "-o", archive, asset["browser_download_url"])
        if hashlib.sha256(archive.read_bytes()).hexdigest() != asset["digest"].split(":", 1)[1]:
            raise RuntimeError(f"Checksum mismatch for {name}")
        unpacked = Path(tmp) / "unpacked"
        shutil.unpack_archive(archive, unpacked)
        candidate, = unpacked.iterdir()
        target = LOCAL / "neovim"
        previous = LOCAL / "neovim.previous"
        subpath = "bin/nvim.exe" if os.name == "nt" else "bin/nvim"
        check_editor(str(candidate / subpath))
        if previous.exists():
            shutil.rmtree(previous)
        if target.exists():
            target.rename(previous)
        try:
            candidate.rename(target)
        except OSError:
            if previous.exists():
                previous.rename(target)
            raise
    print(f"Installed Neovim {release['tag_name']}", flush=True)


def check_editor(binary):
    if not binary:
        raise RuntimeError("No Neovim found. Run setup.py install.")
    run(binary, "--headless", "-u", "NONE", "-i", "NONE",
        "+lua if vim.fn.has('nvim-0.12') == 0 then vim.cmd('cquit') end", "+qa",
        env=environment())


def sync_plugins(binary, update):
    output = run(binary, "--headless", "-u", "NONE", "-i", "NONE",
                 "+lua io.write(vim.fn.stdpath([[data]]))", "+qa",
                 env=environment(), capture_output=True, text=True)
    packages = Path(output.stdout.strip()) / "site/pack/portable/start"
    if not packages.is_relative_to(LOCAL):
        raise RuntimeError(f"Neovim resolved a data path outside this checkout: {packages}")
    packages.mkdir(parents=True, exist_ok=True)
    for name, (repo, *branch) in json.loads((ROOT / "plugins.json").read_text()).items():
        dest = packages / name
        url = f"https://github.com/{repo}.git"
        if dest.exists():
            if update:
                origin = run("git", "-C", dest, "remote", "get-url", "origin", capture_output=True, text=True)
                if origin.stdout.strip() != url:
                    raise RuntimeError(f"Unexpected origin for {name}. Check {dest}")
                run("git", "-C", dest, "pull", "--ff-only")
            continue
        with tempfile.TemporaryDirectory(dir=packages) as tmp:
            checkout = Path(tmp) / "checkout"
            args = ["--branch", branch[0]] if branch else []
            run("git", "clone", "--depth", "1", *args, url, checkout)
            checkout.rename(dest)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    for name in ("install", "update"):
        sub = commands.add_parser(name)
        sub.add_argument("--system", action="store_true", help="reuse Neovim 0.12+ on PATH")
        sub.add_argument("--skip-parsers", action="store_true")
    commands.add_parser("check")
    if sys.argv[1:2] == ["run"]:
        return run(installed_binary() or "nvim", *sys.argv[2:], env=environment()).returncode
    args = parser.parse_args()
    if args.command in ("install", "update"):
        if not args.system and (args.command == "update" or not (LOCAL / "neovim").exists()):
            download_editor()
        binary = shutil.which("nvim") if args.system else installed_binary()
        check_editor(binary)
        sync_plugins(binary, args.command == "update")
        if not args.skip_parsers:
            env = environment()
            env["PORTABLE_NVIM_UPDATE"] = "1" if args.command == "update" else "0"
            run(binary, "--headless", "-u", ROOT / "config/init.lua", "-i", "NONE", "-l", ROOT / "scripts/parsers.lua", env=env)
    else:
        binary = installed_binary()
        check_editor(binary)
    run(binary, "--headless", "-u", ROOT / "config/init.lua", "-i", "NONE", "-l", ROOT / "scripts/check.lua", env=environment())
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as exc:
        sys.exit(str(exc))
