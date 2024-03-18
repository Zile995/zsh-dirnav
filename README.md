<div align="center">

<h1>
zsh-dirnav
</h1>

A simple `Alt` + `arrow` directory navigation for zsh with more functionallity.

This functionality is extracted from the [zsh4humans](https://github.com/romkatv/zsh4humans) project, so be sure to check it out. :blush:

![demo](https://github.com/Zile995/zsh-dirnav/assets/32335484/28004500-fa24-4026-a56b-85a1a9e5c710)

<details>
<summary>v2 screenshot</summary>

![image](https://github.com/Zile995/zsh-dirnav/assets/32335484/643a307f-a2d4-4cd7-b271-6d9f6e421315)

</details>

</div>

# Installation
  - ## Manual
    ```Shell
    git clone --depth=1 -b down-v2 https://github.com/Zile995/zsh-dirnav.git ${ZDOTDIR:-$HOME}/zsh-dirnav
    echo 'source ${ZDOTDIR:-$HOME}/zsh-dirnav/zsh-dirnav.zsh' >>${ZDOTDIR:-$HOME}/.zshrc
    ```
  - ## Antidote
    Add this line to `${ZDOTDIR:-$HOME}/.zsh_plugins.txt` bundle file:

    ```Shell
    Zile995/zsh-dirnav branch:down-v2
    ```
  - ## Sheldon
    Add these lines to `plugins.toml` file:

    ```R
    [plugins.zsh-dirnav]
    github = "Zile995/zsh-dirnav"
    branch = "down-v2"
    ```
# Key-bindings
`Alt` + `↑` - Move into the parent directory

`Alt` + `↓` - Fuzzy find directory below the current one, and move into it.

`Alt` + `←` - Go to previous directory

`Alt` + `→` - Go to next directory

`Ctrl` + `D` - Search directories

`Ctrl` + `F` - Search files

`Ctrl` + `O` - Copy the selected path

`Alt` + `O` - XDG Open, open the selected directory in file manager or selected file in text editor

`Alt` + `P` - Print the selected item 

> Use `Shift` instead of `Alt` on a Mac

# `Alt` + `↓` and fzf
Dependencies:
  - `fzf`
  - `eza`
  - `bat`
  - `xdg-utils`
  - `xclip` or `wl-clipboard`
  - Any nerdfont

This plugin uses the `FZF_ALT_C_COMMAND` environment variable. If it is not set, fzf will use this command:
```Shell
find . -type d \( ! -name '.git' -a ! -name '.hg' -a ! -name '.svn' -a ! -name 'node_modules' \)
```
If you want to use the `fd` command, you can set something like this in your `.zshrc` file:
```Shell
export FZF_ALT_C_COMMAND='fd --hidden --type d --exclude={.git,.hg,.svn,node_modules}'
```
In the case of `bfs`:
```Shell
export FZF_ALT_C_COMMAND='bfs -type d -exclude -name '.git' -exclude -name '.hg' -exclude -name '.svn' -exclude -name 'node_modules''
```
# Custom keybindings
Simply set the keybindings for `cd-up`, `cd-down`, `cd-forward` and `cd-back` widgets in the `.zshrc` file, for example: 
```Shell
bindkey '^[[1;3A' cd-up
bindkey '^[[1;3B' cd-down
bindkey '^[[1;3D' cd-back
bindkey '^[[1;3C' cd-forward
```
# Credits
All credit goes to [@romkat](https://github.com/romkatv)
