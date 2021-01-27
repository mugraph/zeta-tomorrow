#!/bin/zsh
# zeta-tomorrow theme for oh-my-zsh
# Copyright (c) 2021 janebuoy

# Colors: black|red|blue|green|yellow|magenta|cyan|white
local black=$fg[black]
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local magenta=$fg[magenta]
local cyan=$fg[cyan]
local white=$fg[white]

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

local highlight_bg=$bg[red]

local symbol='➜'
local error_symbol='➜'

# Machine name.
function get_box_name {
    if [ -f ~/.box-name ]; then
        cat ~/.box-name
    else
        echo $HOST
    fi
}

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$highlight_bg%}%{$white_bold%}$name%{$reset_color%}"
    fi
    echo $name
}

# Directory info.
function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$blue_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"

# Git sha.
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$yellow%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

function get_git_prompt {
    local yadm_root="$(yadm rev-parse --show-toplevel)"
    # Check if current path is inside a git directory
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%}]"
        fi
        local git_prompt=" <$(git_prompt_info)$git_status>"
        echo $git_prompt
    # Check if current path is underneath yadm root.
    elif [[ $PWD/ = $yadm_root/* ]]; then
        get_yadm_prompt
    fi
}

function get_yadm_prompt {
    if [[ -n $(yadm rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local yadm_status="$(yadm_prompt_status)"
        if [[ -n $yadm_status ]]; then
            yadm_status="[$yadm_status%{$reset_color%}]"
        fi
        local yadm_prompt=" <$(yadm_prompt_info)$yadm_status>"
        echo $yadm_prompt
    fi
}

function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

# Prompt: # USER@MACHINE: DIRECTORY <BRANCH [STATUS]> --- (TIME_STAMP)
# > command
function print_prompt_head {
    IP=$(ifconfig -a | grep inet | tail -1 | awk '{print $2}' | cut -d':' -f2)
    local left_prompt="\
%{$yellow_bold%}$(get_usr_name)\
%{$magenta%}@\
%{$blue_bold%}$IP ($(get_box_name)): \
%{$cyan_bold%}$(get_current_dir)%{$reset_color%}\
$(get_git_prompt) "
    print -rP "$left_prompt$(get_space $left_prompt)"
}

function get_prompt_indicator {
    if [[ $? -eq 0 ]]; then
        echo "%{$magenta_bold%}$symbol %{$reset_color%}"
    else
        echo "%{$red_bold%}$error_symbol %{$reset_color%}"
    fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd print_prompt_head
setopt prompt_subst

PROMPT='$(get_prompt_indicator)'

# Check if in git or yadm dir
if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
    RPROMPT='$(git_prompt_short_sha) '
elif [[ $PWD/ = $yadm_root/* && -n $(yadm rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
    RPROMPT='$(yadm_prompt_short_sha) '
fi

