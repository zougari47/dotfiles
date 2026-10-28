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

## gh-dash

[gh-dash](https://github.com/dlvhdr/gh-dash) **v4.26.2**, a `gh` extension (`gh extension install dlvhdr/gh-dash`). Run it with `gh dash`. The config lives in `~/.config/gh-dash/config.yml`.

It has three views: **PRs**, **Issues** and **Notifications**. Each view is split into sections (the tabs at the top), and the preview pane on the right shows the selected item. Press <kbd>?</kbd> to see every key for the current view.

| Keys | What it does |
| --- | --- |
| **Moving around** | |
| <kbd>j</kbd> / <kbd>k</kbd> | Down / up in the list |
| <kbd>h</kbd> / <kbd>l</kbd> | Previous / next section |
| <kbd>g</kbd> / <kbd>G</kbd> | First / last item |
| <kbd>s</kbd> | Switch view (PRs → Issues → Notifications) |
| <kbd>/</kbd> | Edit the section's search, in GitHub syntax (`is:open repo:owner/name`) |
| <kbd>r</kbd> / <kbd>R</kbd> | Refresh this section / all sections |
| <kbd>?</kbd> | Help |
| <kbd>q</kbd> | Quit |
| **Reading** | |
| <kbd>p</kbd> | Show or hide the preview pane |
| <kbd>Ctrl</kbd> + <kbd>d</kbd> / <kbd>Ctrl</kbd> + <kbd>u</kbd> | Scroll the preview down / up |
| <kbd>[</kbd> / <kbd>]</kbd> | Previous / next preview tab |
| <kbd>e</kbd> | Expand the full PR description |
| <kbd>d</kbd> | View the PR diff in a pager |
| <kbd>o</kbd> | Open in the browser |
| <kbd>y</kbd> / <kbd>Y</kbd> | Copy the number / URL |
| **PRs** | |
| <kbd>c</kbd> | Comment |
| <kbd>v</kbd> | Approve |
| <kbd>m</kbd> | Merge |
| <kbd>x</kbd> / <kbd>X</kbd> | Close / reopen |
| <kbd>a</kbd> / <kbd>A</kbd> | Assign / unassign |
| <kbd>w</kbd> | Watch the CI checks |
| <kbd>W</kbd> | Mark a draft as ready for review |
| <kbd>u</kbd> | Update the branch from its base |
| <kbd>C</kbd> | Check the PR out locally (needs `repoPaths` in the config) |
| **Issues** | |
| <kbd>c</kbd>, <kbd>x</kbd> / <kbd>X</kbd>, <kbd>a</kbd> / <kbd>A</kbd> | Same as for PRs |
| <kbd>C</kbd> | Create and check out a branch for the issue |
| **Notifications** | |
| <kbd>Enter</kbd> | Open it (marks it read) |
| <kbd>m</kbd> / <kbd>M</kbd> | Mark it / all as read |
| <kbd>D</kbd> | Done: remove it from the inbox |
| <kbd>u</kbd> | Unsubscribe from the thread |
| <kbd>b</kbd> | Bookmark |
| <kbd>t</kbd> | Show only the current repo |
