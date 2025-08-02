# android_dotfiles

Configuration files for my android device and termux CLI environment. Before cloning the dotfiles repository be sure to install the termux app together with important extensions.

- Download Termux from F-Driod - <https://f-droid.org/packages/com.termux/>
- Termux API - <https://f-droid.org/en/packages/com.termux.api/>
- All Termux Apps - <https://search.f-droid.org/?q=termux&lang=en>
- Developer Wiki - <https://github.com/termux/termux-packages/wiki>
- Termux Wiki - <https://wiki.termux.com/wiki/Main_Page>

## Installation

Bootstrap the environment:

```sh
pkg update && pkg upgrade
pkg autoclean

termux-setup-storage
termux-change-repo
termux-upgrade-repo

```

Setup script and required config file is inside `_setup` directory

