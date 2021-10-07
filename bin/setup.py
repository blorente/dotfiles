#!/usr/bin/env python3.9

import argparse
import json
import logging
import platform
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List

from logging_utils import add_logging_to_arg_parser, configure_logging

log = logging.getLogger("dotfiles")

repo_path: Path = Path(__file__).parent.parent
config_root: Path = (repo_path / "configs").absolute()


@dataclass
class PackageInstaller:
    name: str
    install_cmd_template: str
    check_cmd_template: str
    add_source_template: str = None

    def _run_cmd(f_cmd) -> subprocess.CompletedProcess:
        log.trace(f"Running installer command: {f_cmd}")
        return subprocess.run(
            f_cmd,
            capture_output=True,
            check=False,
            shell=True,
        )

    def package_installed(self, package: "SystemPackage"):
        log.debug(f"Checking if {package} is installed...")
        return (
            PackageInstaller._run_cmd(
                self.check_cmd_template.format(package=package.name)
            ).returncode
            == 0
        )

    def install_package(self, package: "SystemPackage"):
        log.debug(f"Installing {package}")
        if package.sources and self.name in package.sources:
            my_source = package.sources[self.name]
            PackageInstaller._run_cmd(self.add_source_template.format(source=my_source))
        if package.pre_install:
            PackageInstaller._run_cmd(package.pre_install)
        install_res = PackageInstaller._run_cmd(
            self.install_cmd_template.format(package=package.name)
        )
        if package.post_install:
            PackageInstaller._run_cmd(package.post_install)
        return install_res


Brew = PackageInstaller(
    name="Brew",
    install_cmd_template="brew install {package}",
    check_cmd_template="brew list {package}",
    add_source_template="brew tap {source}",
)
Apt = PackageInstaller(
    name="Apt",
    install_cmd_template="sudo apt-get install {package}",
    check_cmd_template="dpkg -l {package}",
    add_source_template="sudo add-apt-repository {source}; sudo apt-get update",
)
Pip = PackageInstaller(
    name="Pip",
    install_cmd_template="pip3 install {package}",
    check_cmd_template="pip list | grep -F {package}",
)


@dataclass
class SystemPackage:
    name: str
    pre_install: str = None
    post_install: str = None
    sources: Dict[str, str] = None


SP = lambda name: SystemPackage(name=name)


# Packages common to linux and macOS
COMMON_SYSTEM_PACKAGES: List[SystemPackage] = [
    SystemPackage(name="neovim", sources={"Apt": "ppa:neovim-ppa/unstable"}),
    SystemPackage(
        name="zsh",
        post_install="chsh -s $(which zsh)",
    ),
    SP("ripgrep"),
    SP("htop"),
    SP("fzf"),
    SP("tldr"),
    SP("tmux"),
    SP("tree"),
    SP("python3"),
]

BREW_PACKAGES: List[SystemPackage] = COMMON_SYSTEM_PACKAGES + []
APT_PACKAGES: List[SystemPackage] = COMMON_SYSTEM_PACKAGES + []
PIP_PACKAGES: List[SystemPackage] = [SP("click"), SP("emoji")]


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
            log.info(f"-> Installed {package.name} [☑️ ]")
        else:
            out = installer.install_package(package)
            if out.returncode == 0:
                log.info(f"-> Installed {package.name} [✅]")
            else:
                log.error(
                    f"-> Error Installing {package.name} [❌]:\nPackage: {package}\nOut: {out}"
                )
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
                    log.info(f"-> {name} OK [☑️ ]")
            else:
                log.error(f"Config file {config_file} exists, but is not a symlink.")
                failed_configs.append(name)
        else:
            in_system.symlink_to(in_repo)
            log.info(f"-> {name} OK [✅]")

    return failed_configs


def ensure_system_agnostic_packages_installed():
    failed_packages = []
    failed_packages += ensure_packages_installed(PIP_PACKAGES, Pip)
    return failed_packages


def main_linux():
    log.info("Setting up dotfiles for Linux")
    failed_packages = ensure_packages_installed(APT_PACKAGES, Apt)
    failes_packages = ensure_system_agnostic_packages_installed()
    failed_configs = ensure_config_files(LINUX_CONFIG_FILES)
    return {
        "failed_packages": failed_packages,
        "failed_configs": failed_configs,
    }


def main_macos():
    log.info("Setting up dotfiles for MacOS")
    failed_packages = ensure_packages_installed(BREW_PACKAGES, Brew)
    failes_packages = ensure_system_agnostic_packages_installed()
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
