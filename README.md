# zsh-dirnav

Simple `Alt` + `arrow` directory navigation for zsh.
This functionality is extracted from the [zsh4humans](https://github.com/romkatv/zsh4humans) project, so be sure to check it out. :blush:

# Installation
  - ## Manual
    ```Shell
    git clone --depth=1 https://github.com/Zile995/zsh-dirnav.git ${ZDOTDIR:-$HOME}/zsh-dirnav
    echo 'source ${ZDOTDIR:-$HOME}/zsh-dirnav/zsh-dirnav.zsh' >>${ZDOTDIR:-$HOME}/.zshrc
    ```
  - ## Antidote
    Add this line to `${ZDOTDIR:-$HOME}/.zsh_plugins.txt` bundle file:

    ```Shell
    Zile995/zsh-dirnav
    ```
  - ## Sheldon
    Add these lines to `plugins.toml` file:

    ```R
    [plugins.zsh-dirnav]
    github = "Zile995/zsh-dirnav"
    ```

# Key-bindings
`Alt` + `↑` - Move into the parent directory

`Alt` + `↓` - Fuzzy find directory below the current one, and move into it.

`Alt` + `←` - Go to previous directory

`Alt` + `→` - Go to next directory

> Use `Shift` instead of `Alt` on a Mac

# `Alt` + `↓` and fzf
Dependencies:
  - `fzf`
  - `eza`

This plugin is using the `FZF_ALT_C_COMMAND` environment variable. If it is not set, fzf will use this command:
```Shell
find . -type d \( ! -name '.git' -a ! -name 'node_modules' -a ! -name '.hg' -a ! -name '.svn' \)
```

If you want to use the `fd` command, you can set something like this in your `.zshrc` file:
```Shell
export FZF_ALT_C_COMMAND='fd --hidden --exclude={.git,.hg,.svn} --type d'
```

# Credits
All credits goes to [@romkat](https://github.com/romkatv)
