alias ll='ls -lha'
alias p=python
alias venvact='source .venv/bin/activate'
alias md='mkdir'
alias opte='open -a 'textedit''
alias obsidian='./Documents/obsidian/weekly_notes.sh'
alias n="nvim"
alias redock="~/Dev/docker_init.sh"

# git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '(%b)%c%u'

export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
