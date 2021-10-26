#!/usr/bin/env python3.9

"""
TODO
- [ ] Rewrite in Rust?
- [ ] Make post and pre install be a list of actions, which can be either scripts, or config files.
- [ ] Mark pre-post installs as failures as well.
- [ ] Installed checks are broken:
    - [ ] For apt-get packages
    - [ ] For go packages
"""

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
    add_source_template: str = ""

    @staticmethod
    def _run_cmd(f_cmd: str) -> subprocess.CompletedProcess:
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
                PackageInstaller._format_template(self.check_cmd_template, package)
            ).returncode
            == 0
        )

    @staticmethod
    def _format_template(template: str, pkg: "SystemPackage") -> str:
        return template.format_map({"name": pkg.name, "package": pkg.package})

    def install_package(self, package: "SystemPackage"):
        log.debug(f"Installing {package}")
        if package.sources and self.name in package.sources:
            my_source = package.sources[self.name]
            PackageInstaller._run_cmd(self.add_source_template.format(source=my_source))
        if package.pre_install:
            PackageInstaller._run_cmd(package.pre_install)
        install_res = PackageInstaller._run_cmd(
            PackageInstaller._format_template(self.install_cmd_template, package)
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
    install_cmd_template="sudo apt-get -y install {package}",
    check_cmd_template="dpkg -s {package} | grep \"dpkg-query: package '{package}' is not installed\"",
    add_source_template="sudo add-apt-repository -y {source}; sudo apt-get update",
)
Pip = PackageInstaller(
    name="Pip",
    install_cmd_template="sudo pip3 install {package}",
    check_cmd_template="pip list | grep -F {package}",
)
Freeform = PackageInstaller(
    name="Freeform",
    install_cmd_template="/bin/bash -c '{package}' && echo '{name}' >> ~/.freeform.installed",
    check_cmd_template="cat ~/.freeform.installed | grep {name}",
)
Npm = PackageInstaller(
    name="Npm",
    install_cmd_template="npm install -g {package}",
    check_cmd_template="npm list -g {package}",
)
Go = PackageInstaller(
    name="Go",
    install_cmd_template="go install {package}",
    check_cmd_template="go list $HOME/go/{package}",
)


@dataclass
class SystemPackage:
    name: str
    package: str
    pre_install: str = ""
    post_install: str = ""
    sources: Dict[str, str] = None


SP = lambda name: SystemPackage(name=name, package=name)


# Packages common to linux and macOS
COMMON_SYSTEM_PACKAGES: List[SystemPackage] = [
    SystemPackage(
        name="neovim",
        package="neovim",
        sources={"Apt": "ppa:neovim-ppa/unstable"},
        post_install="nvim --headless +PlugInstall +'TSInstall all' +qa",
    ),
    SystemPackage(
        name="zsh",
        package="zsh",
        post_install="sudo chsh -s $(which zsh)",
    ),
    SP("ripgrep"),
    SP("htop"),
    SP("fzf"),
    SP("tldr"),
    SP("tmux"),
    SP("tree"),
    SP("python3"),
    SP("exa"),
    SystemPackage(
        name="golang", package="golang", post_install='mkdir -p "$HOME/go{bin,src,pkg}"'
    ),
    SP("git-extras"),
]

BREW_PACKAGES: List[SystemPackage] = COMMON_SYSTEM_PACKAGES + [SP("rust-analyzer")]
APT_PACKAGES: List[SystemPackage] = COMMON_SYSTEM_PACKAGES + []
PIP_PACKAGES: List[SystemPackage] = [
    SP("click"),
    SP("emoji"),
]
NPM_PACKAGES: List[SystemPackage] = [
    SP("pyright"),
    SP("pm2"),
    SP("netlify"),
    SP("bash-language-server"),
]
GO_PACKAGES: List[SystemPackage] = [SP("golang.org/x/tools/gopls@latest")]
FREEFORM_PACKAGES: List[SystemPackage] = [
    SystemPackage(
        name="powerlevel10k",
        package="git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k",
    ),
    SystemPackage(
        name="nvim-plug",
        package='curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
    ),
    SystemPackage(
        name="nvm+node",
        package="curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash",
        post_install="nvm install 16",
    ),
    SystemPackage(
        name="rustup+rust",
        package="curl --proto '=https' --tlsv1.2 -sSf --output /tmp/rustup https://sh.rustup.rs && chmod +x /tmp/rustup && /tmp/rustup -y",
    ),
]


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
    "p10k": ConfigFile(
        in_system_home_location=Path(".p10k.zsh"),
        in_repo_location=Path("p10k.zsh"),
    ),
    "alacritty": ConfigFile(
        in_system_home_location=Path(".config/alacritty/alacritty.yml"),
        in_repo_location=Path("alacritty.yml"),
    ),
    "tmux": ConfigFile(
        in_system_home_location=Path(".tmux.conf"),
        in_repo_location=Path("tmux.conf"),
    ),
}

MACOS_CONFIG_FILES: Dict[str, ConfigFile] = COMMON_CONFIG_FILES
LINUX_CONFIG_FILES: Dict[str, ConfigFile] = COMMON_CONFIG_FILES


def ensure_packages_installed(
    packages: List[SystemPackage], installer: PackageInstaller
):
    log.info(f"Ensuring packages installed for {installer.name}")
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


def ensure_freeform_packages_installed():
    failed_packages = []
    failed_packages += ensure_packages_installed(FREEFORM_PACKAGES, Freeform)
    return failed_packages


def ensure_language_packages_installed():
    failed_packages = []
    failed_packages += ensure_packages_installed(PIP_PACKAGES, Pip)
    failed_packages += ensure_packages_installed(NPM_PACKAGES, Npm)
    failed_packages += ensure_packages_installed(GO_PACKAGES, Go)
    return failed_packages


def main_linux(args):
    log.info("Setting up dotfiles for Linux")
    failed_packages = []
    failed_configs = []

    failed_configs = ensure_config_files(LINUX_CONFIG_FILES)

    if not args.config_only:
        failed_packages += ensure_freeform_packages_installed()
        failed_packages += ensure_packages_installed(APT_PACKAGES, Apt)
        failed_packages += ensure_language_packages_installed()

    return {
        "failed_packages": failed_packages,
        "failed_configs": failed_configs,
    }


def main_macos(args):
    log.info("Setting up dotfiles for MacOS")
    failed_packages = []
    failed_configs = []

    failed_configs = ensure_config_files(MACOS_CONFIG_FILES)

    if not args.config_only:
        failed_packages += ensure_freeform_packages_installed()
        failed_packages = ensure_packages_installed(BREW_PACKAGES, Brew)
        failed_packages += ensure_language_packages_installed()

    return {
        "failed_packages": failed_packages,
        "failed_configs": failed_configs,
    }


def parse_args():
    parser = argparse.ArgumentParser(description="I want easy dotfiles.")
    parser.add_argument(
        "--config-only", action="store_true", help="only install config files"
    )
    add_logging_to_arg_parser(parser)
    return parser.parse_args()


def main(args):
    system = platform.system()
    configure_logging(log, args)
    log.debug(f"Repo root is {repo_path}, Config path is {config_root}")
    install_result = None
    if system == "Linux":
        log.info("🐧 Linux found")
        install_result = main_linux(args)
    elif system == "Darwin":
        log.info("🍎 MacOS found")
        install_result = main_macos(args)

    if not install_result["failed_packages"] and not install_result["failed_configs"]:
        log.info("✨ All done! ✨")
    else:
        print(json.dumps(install_result))


if __name__ == "__main__":
    main(parse_args())
