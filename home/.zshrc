alias ll='ls -lha'
alias path=realpath
alias to_show_full_path_of_command=whence
alias vt=vimtutor
alias zbuilt='man zshbuiltins'
alias p3=python
alias op=open
alias venvact='source venv/bin/activate'
alias md='mkdir'
alias opte='open -a 'textedit''

autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'
# PROMPT='${vcs_info_msg_0_}%# '
zstyle ':vcs_info:git:*' formats '%b'
