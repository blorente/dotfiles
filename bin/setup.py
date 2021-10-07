#!/usr/bin/env python3

from dataclasses import dataclass
from pathlib import Path
import platform
import logging
from logging_utils import configure_logging, add_logging_to_arg_parser
import subprocess
import json
import argparse
from typing import List, Dict

log = logging.getLogger("dotfiles")

repo_path: Path = Path(__file__).parent.parent
config_root: Path = (repo_path / "configs").absolute()

# Packages common to linux and macOS
COMMON_PACKAGES: List[str] = [
    "neovim",
    "zsh",
    "ripgrep",
    "htop",
    "fzf",
    "tree",
    "tldr",
    "tmux",
]

BREW_PACKAGES: List[str] = COMMON_PACKAGES + []
APT_PACKAGES: List[str] = COMMON_PACKAGES + []


@dataclass
class PackageInstaller:
    install_cmd_template: str
    check_cmd_template: str

    def _run_cmd_for_package(cmd, package) -> subprocess.CompletedProcess:
        return subprocess.run(
            cmd.format(package=package),
            capture_output=True,
            check=False,
            shell=True,
        )

    def package_installed(self, package):
        return (
            PackageInstaller._run_cmd_for_package(
                self.check_cmd_template, package
            ).returncode
            == 0
        )

    def install_package(self, package):
        return PackageInstaller._run_cmd_for_package(self.install_cmd_template, package)


Brew = PackageInstaller(
    install_cmd_template="brew install {package}",
    check_cmd_template="brew list {package}",
)


@dataclass
class ConfigFile:
    in_system_home_location: Path
    in_repo_location: Path


COMMON_CONFIG_FILES: Dict[str, ConfigFile] = {
    "zshrc": ConfigFile(
        in_system_home_location=Path(".zshrc"), in_repo_location=Path("zshrc")
    ),
    "vim": ConfigFile(
        in_system_home_location=Path(".vimrc"), in_repo_location=Path("vimrc")
    ),
    "neovim": ConfigFile(
        in_system_home_location=Path(".config/nvim/init.vim"),
        in_repo_location=Path("neovim.init.vim"),
    ),
    "zsh-completions": ConfigFile(
        in_system_home_location=Path("completions.zsh"),
        in_repo_location=Path("zsh_completions"),
    ),
}

MACOS_CONFIG_FILES: Dict[str, ConfigFile] = COMMON_CONFIG_FILES
LINUX_CONFIG_FILES: Dict[str, ConfigFile] = COMMON_CONFIG_FILES


def ensure_packages_installed(packages: List[str], installer: PackageInstaller):
    failed_packages = []
    for package in packages:
        if installer.package_installed(package):
            log.info(f"-> Installed {package} [Cached]")
        else:
            success = install_package(package, installer)
            out = installer.install_package(package)
            if out.returncode == 0:
                log.info(f"-> Installed {package} [NEW]")
                return True
            else:
                log.error(f"-> Error Installing {package}: {out}")
                if not success:
                    failed_packages.append(package)
    return failed_packages


def ensure_config_files(filemap: Dict[str, ConfigFile]) -> List[str]:
    log.info("Ensuring config files...")
    failed_configs = []
    for (name, config_file) in filemap.items():
        log.debug(f" . Checking config file {name}")
        log.debug(f" .   Config: {config_file}")
        in_repo = config_root / config_file.in_repo_location
        in_system = Path.home() / config_file.in_system_home_location
        if in_system.exists():
            if in_system.is_symlink():
                if in_system.readlink() != in_repo:
                    log.error(
                        f"Config file {config_file} exists and is a symlink, but points to wrong file."
                    )
                    failed_configs.append(name)
                else:
                    log.info(f"-> {name} OK [Cached]")
            else:
                log.error(f"Config file {config_file} exists, but is not a symlink.")
                failed_configs.append(name)
        else:
            in_system.symlink_to(in_repo)
            log.info(f"-> {name} OK [NEW]")

    return failed_configs


def main_linux():
    log.info("Setting up dotfiles for Linux")


def main_macos():
    log.info("Setting up dotfiles for MacOS")
    failed_packages = ensure_packages_installed(BREW_PACKAGES, Brew)
    failed_configs = ensure_config_files(MACOS_CONFIG_FILES)

    return {
        "failed_packages": failed_packages,
        "failed_configs": failed_configs,
    }


def parse_args():
    parser = argparse.ArgumentParser(description="I want easy dotfiles.")
    add_logging_to_arg_parser(parser)
    return parser.parse_args()


def main(args):
    system = platform.system()
    configure_logging(log, args)
    log.debug(f"Repo root is {repo_path}, Config path is {config_root}")
    install_result = None
    if system == "Linux":
        log.info("🐧 Linux found")
        install_result = main_linux()
    elif system == "Darwin":
        log.info("🍎 MacOS found")
        install_result = main_macos()

    print(json.dumps(install_result))


if __name__ == "__main__":
    main(parse_args())