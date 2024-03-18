ZSH_DIRNAV_HOME="${0:A:h}"

cd-up()      { 'builtin' cd -q .. && redraw_prompt 1; }
cd-back()    { cd_rotate +1; }
cd-forward() { cd_rotate -0; }

cd-down() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  (( $+commands[fzf] )) || return
  zmodload -F zsh/files b:zf_rm || return

  # Set copy command
  (( $+commands[wl-copy] || $+commands[xclip] )) &&
    local copy_command='printf "%q" $PWD/{} | { wl-copy -n || xclip -r -in -sel c }'

  # Set preview window for dir search
  local dir_preview file_preview
  (( $+commands[eza] )) &&
    dir_preview='[[ -f {} ]] || eza -1 --group-directories-first --all --icons --color=always -- {}' ||
    dir_preview='[[ -f {} ]] || ls -1A --color=always -- {}'
  # Set preview window for file search
  (( $+commands[bat] )) &&
    file_preview='[[ -d {} ]] || bat --color=always -- {}' ||
    file_preview='[[ -d {} ]] || cat -- {}'

  # Set fzf reload commands
  local fzf_dir_command="$FZF_ALT_C_COMMAND"
  local fzf_file_command="$FZF_DEFAULT_COMMAND"
  [[ -n $FZF_ALT_C_COMMAND ]] ||
    fzf_dir_command='find . -type d \( ! -name '.git' -a ! -name '.hg' -a ! -name '.svn' -a ! -name 'node_modules' \)'
  [[ -n $FZF_DEFAULT_COMMAND ]] ||
    fzf_file_command='find . -type f \( ! -name '.git' -a ! -name '.hg' -a ! -name '.svn' -a ! -name 'node_modules' \)'

  # Set tmp file path
  local tmp_print="$(dirname $(mktemp -u))/zsh_dirnav"
  [[ ! -e $tmp_print ]] || zf_rm -f -- "$tmp_print" 2>/dev/null

  local INITIAL_QUERY="${*:-}"
  local header_text='CTRL-D: Directories / CTRL-F: Files\nCTRL-O: Copy the path / ALT-O: XDG Open / ALT-P: Print selected'

  local selected_item=$( \
    : | fzf \
      --exact \
      --reverse \
      --no-multi \
      --keep-right \
      --height '80%' \
      --query "$INITIAL_QUERY" \
      --preview "$dir_preview" \
      --prompt '󰉋  Directories ❯ ' \
      --tiebreak 'length,begin,index' \
      --header "$(echo -e $header_text)" \
      --bind "start:reload($fzf_dir_command)" \
      --bind "alt-p:execute-silent(echo 1 > $tmp_print)+accept" \
      --bind "alt-o:execute-silent(xdg-open {} & disown)" \
      --bind "ctrl-o:execute-silent($copy_command)+abort" \
      --bind "ctrl-f:change-prompt(  Files ❯ )+reload($fzf_file_command)+change-preview($file_preview)" \
      --bind "ctrl-d:change-prompt(󰉋  Directories ❯ )+reload($fzf_dir_command)+change-preview($dir_preview)"
  )

  [[ -r $tmp_print ]] && local should_print="$(<$tmp_print)"
  if (( $should_print )); then
    LBUFFER+="${(q)selected_item}"
    zf_rm -f -- "$tmp_print" 2>/dev/null
  else
    [[ -d $selected_item ]] && {
      'builtin' cd -- "$selected_item" 2>/dev/null
      redraw_prompt 1
    } && return || {
      [[ ! -f $selected_item ]] || $EDITOR -- "$selected_item" <$TTY
    }
  fi

  redraw_prompt
}

'builtin' zle -N cd-up
'builtin' zle -N cd-down
'builtin' zle -N cd-back
'builtin' zle -N cd-forward

# Init
() {
  setopt autopushd

  (( $fpath[(I)${ZSH_DIRNAV_HOME}/functions] )) ||
    fpath+=(${ZSH_DIRNAV_HOME}/functions)

  autoload -Uz ${ZSH_DIRNAV_HOME}/functions/*

  'builtin' local keymap
  for keymap in 'emacs' 'viins' 'vicmd'; do
    'builtin' bindkey -M "$keymap" '^[^[[A'  cd-up
    'builtin' bindkey -M "$keymap" '^[[1;3A' cd-up
    'builtin' bindkey -M "$keymap" '^[[1;9A' cd-up
    'builtin' bindkey -M "$keymap" '^[^[[B'  cd-down
    'builtin' bindkey -M "$keymap" '^[[1;3B' cd-down
    'builtin' bindkey -M "$keymap" '^[[1;9B' cd-down
    'builtin' bindkey -M "$keymap" '^[^[[D'  cd-back
    'builtin' bindkey -M "$keymap" '^[[1;3D' cd-back
    'builtin' bindkey -M "$keymap" '^[[1;9D' cd-back
    'builtin' bindkey -M "$keymap" '^[^[[C'  cd-forward
    'builtin' bindkey -M "$keymap" '^[[1;3C' cd-forward
    'builtin' bindkey -M "$keymap" '^[[1;9C' cd-forward
  done
}
