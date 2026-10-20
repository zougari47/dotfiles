# dotfiles

> [!WARNING]
> These are my personal config files, made for my own machine and habits.
> Use them at your own risk.

## nvim

Neovim **v0.12.6**.

## tmux

The prefix is <kbd>Ctrl</kbd> + <kbd>a</kbd>. "prefix, then <kbd>n</kbd>" means: press the prefix, let go, press <kbd>n</kbd>.

| Keys | What it does |
| --- | --- |
| **Sessions** | |
| <kbd>Alt</kbd> + <kbd>g</kbd> | Go to the first session |
| <kbd>Alt</kbd> + <kbd>f</kbd> | Go to the second session |
| <kbd>Alt</kbd> + <kbd>d</kbd> | Go to the third session |
| prefix, then <kbd>n</kbd> | New session, named with the lowest free number |
| prefix, then <kbd>$</kbd> | Rename the session; its number stays in front (`1-name`) |
| prefix, then <kbd>q</kbd> | Close the session, after a y/n |
| **Windows** | |
| <kbd>Alt</kbd> + <kbd>1</kbd> … <kbd>4</kbd> | Go to window 1 to 4 |
| prefix, then <kbd>c</kbd> | New window, in the current folder |
| prefix, then <kbd>,</kbd> | Rename the window |
| **Panes** | |
| prefix, then <kbd>%</kbd> | Split left and right, in the current folder |
| prefix, then <kbd>"</kbd> | Split top and bottom, in the current folder |
| prefix, then <kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd> | Move to the pane on the left, below, above, on the right |
| **Other** | |
| prefix, then <kbd>r</kbd> | Reload the config |
| <kbd>Shift</kbd> + click | Open a link (tmux takes plain clicks, so WezTerm needs Shift) |

## alacritty

Alacritty **v0.17.0**, built by `scripts/Scripts/install-alacritty.sh`. The config lives in `alacritty/.config/alacritty/alacritty.toml`; link it with `stow alacritty`.

| Keys | What it does |
| --- | --- |
| <kbd>Ctrl</kbd> + click | Open a link (inside tmux, add <kbd>Shift</kbd>: <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + click) |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd> | Pick a link on screen with the keyboard |
