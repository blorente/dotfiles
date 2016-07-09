# MY DOTFILES

This is a place to gather my personal dotfiles, made with the help of [this guide](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.nufasynft) and inspired by [this repo](https://github.com/ferreiro/dotfiles). Of course, I am oh-so-new at this, and would love suggestions. If you are kind enough to have them, please open an issue with your feedback.

## Installation

### One-line installation

With `curl`, you can just type 
```bash
curl -s https://raw.githubusercontent.com/blorente/dotfiles/master/auto.sh
```
and it will automatically clone the repo and run the install script for you.

### Two-line installation

If you want to clone the repo by hand, you can just execute:
```bash
$ cd <parent directory>
$ git clone https://github.com/blorente/dotfiles.git
$ dotfiles/install.sh
```
__WARNING:__ If you have zsh as the main shell, this will download and install [Oh-My-Zsh](http://ohmyz.sh/), because it's amazing.

