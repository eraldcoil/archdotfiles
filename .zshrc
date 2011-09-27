autoload -U colors
colors
#PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%n%{\e[0;34m%}@%{\e[0m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;34m%}'$(date +'%a (%R) %d/%m/%Y')$'%{\e[0;34m%}%B]%b%{\e[0m%}
#%{\e[0;34m%}%B└─[%b%{\e[0m%}%~%{\e[0;34m%}%B]%b%{\e[0;34m%}>%{\e[0m%}' 

#PROMPT="%{$fg[yellow]%}%n%{$reset_color%} an %{$fg[blue]%}%m%{$reset_color%} in %{$fg[red]%}%~%{$reset_color%}$(git_prompt_info)
#%{$fg[green]%}>%{$fg[blue]%}>%{$fg[cyan]%}>%{$reset_color%} "
# key bindings
autoload -U compinit zrecompile
setopt prompt_subst
compinit
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

#  # Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
setopt extendedhistory
bindkey "e[1~" beginning-of-line
bindkey "e[4~" end-of-line
bindkey "e[5~" beginning-of-history
bindkey "e[6~" end-of-history
bindkey "e[3~" delete-char
bindkey "e[2~" quoted-insert
bindkey "e[5C" forward-word
bindkey "eOc" emacs-forward-word
bindkey "e[5D" backward-word
bindkey "eOd" emacs-backward-word
bindkey "ee[C" forward-word
bindkey "ee[D" backward-word
bindkey "^H" backward-delete-word
# # for rxvt
bindkey "e[8~" end-of-line
bindkey "e[7~" beginning-of-line
# # for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "eOH" beginning-of-line
bindkey "eOF" end-of-line
# # for freebsd console
bindkey "e[H" beginning-of-line
bindkey "e[F" end-of-line
# # completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
alias l='ls -lh --color'
alias la='ls -la --color'
alias ll='ls -l --color'
alias ls='ls -F --color'
alias v='vim'
alias vv='vim ~/.vimrc'
alias z='vim ~/.zshrc'
alias x='vim ~/.xmonad/xmonad.hs'
alias xd='vim .Xdefaults'
alias gg='g++ -Wall -W -pedantic -ansi'
alias ..="cd .."
alias cd..="cd .."
alias tt='echo $(git_prompt_info)'
alias ttt='echo $(parse_git_branch)'
alias tball='tar xvf'


#pacman stuff
alias pacup="pacman -Syu"
alias pacs='pacman -Ss'
alias pacU='pacman -U'
alias pacS='pacman -S'
alias pacQ='pacman -Q'

ZSH_THEME_GIT_PROMPT_PREFIX=" @ [branch: $fg[magenta]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color]"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[green]!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$fg[green]?"
ZSH_THEME_GIT_PROMPT_CLEAN=" "


# Gittiness
# # get the name of the branch we are on
#
function git_prompt_info() 
{
    ref=$(git symbolic-ref HEAD  2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
    #echo "[branch: "${ref#refs/heads/}"]"
}


function parse_git_dirty() 
{ 
    gitstat=$(git status 2> /dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')

    if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
        echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi

    if [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Changed but not updated:\)$") > 0 ]]; then
        echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi

    if [[ $(echo ${gitstat} | wc -l | tr -d ' ') == 0 ]]; then
        echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}


#
#    # Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gd='git diff | mate'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias ac='acpi -V'
alias cl='clear'
alias mkp='makepkg --asroot'
alias mt='/opt/metasploit/msfconsole'
alias p_='poweroff'
alias nes='/opt/nessus/sbin/nessusd start'

# End git
#function parse_git_dirty {
#  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
#  }
#  function parse_git_branch {
#    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
#}
precmd()
{
    if [ $? -eq 0 ]; then
    PROMPT='%{$fg[yellow]%}%B%n%{$reset_color%} on %{$fg[blue]%}%B%m%{$reset_color%} in %{$fg[red]%}%~%{$reset_color%}$(git_prompt_info)
%{$fg[grey]%}%B>%{$fg[grey]%}%B>%{$fg[green]%}>%{$reset_color%} ' 
    RPROMPT='%{$fg[blue]%}-[%{$reset_color%}%{$fg[cyan]%}%*+%W%{$reset_color%}%{$fg[blue]%}]-%{$reset_color%}'
else
    PROMPT='%{$fg[yellow]%}%B%n%{$reset_color%} on %{$fg[blue]%}%B%m%{$reset_color%} in %{$fg[red]%}%~%{$reset_color%}$(git_prompt_info)
%{$fg[grey]%}%B>%{$fg[grey]%}%B>%{$fg[red]%}>%{$reset_color%} ' 
    RPROMPT='%{$fg[blue]%}-[%{$reset_color%}%{$fg[cyan]%}%*+%W%{$reset_color%}%{$fg[blue]%}]-%{$reset_color%}'
    fi 
}
#PROMPT="%{$fg[yellow]%}%B%n%{$reset_color%} on %{$fg[blue]%}%m%{$reset_color%} in %{$fg[red]%}%~%{$reset_color%}$(parse_git_branch)
#%{$fg[green]%}>%{$fg[blue]%}>%{$fg[cyan]%}>%{$reset_color%} " 

#testline
#
