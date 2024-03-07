ZSH_DIRNAV_HOME="${0:A:h}"

cd-up()      { 'builtin' cd -q .. && redraw_prompt 1; }
cd-back()    { cd_rotate +1; }
cd-forward() { cd_rotate -0; }

cd-down() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  (( $+commands[fzf] )) || return 1

  local INITIAL_QUERY="${*:-}"
  local fzf_command="$FZF_ALT_C_COMMAND"

  local preview
  (( $+commands[eza] )) &&
    preview="eza -1 --group-directories-first --all --icons --color=always {}" ||
    preview="ls -1A --color=always {}"

  [[ -n $FZF_ALT_C_COMMAND ]] ||
    fzf_command='find . -type d \( ! -name '.git' -a ! -name '.hg' -a ! -name '.svn' -a ! -name 'node_modules' \)'

  local selected_item=$(
    : | fzf \
      --exact \
      --reverse \
      --no-multi \
      --keep-right \
      --height '80%' \
      --query "$INITIAL_QUERY" \
      --preview "$preview" \
      --preview-window 'right:60%' \
      --tiebreak 'length,begin,index' \
      --bind 'ctrl-z:ignore' \
      --bind "start:reload($fzf_command)"
  )

  [[ -d $selected_item ]] && {
    'builtin' cd -- "$selected_item" 2>/dev/null && redraw_prompt 1
  } || redraw_prompt
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
