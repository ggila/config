PATH=~/.brew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin:$HOME/.brew/bin
HISTFILE=~/.zshrc_history
SAVEHIST=5000
HISTSIZE=5000


setopt inc_append_history
setopt share_history

if [[ -f ~/.myzshrc ]]; then
	source ~/.myzshrc
fi

USER=`/usr/bin/whoami`
export USER
GROUP=`/usr/bin/id -gn $user`
export GROUP
MAIL="$USER@student.42.fr"
export MAIL

#Color
autoload -U colors && colors

PS1="%{$fg[red]%}%m %{$fg[green]%}%~%{$reset_color%}|%"
#
##ALIAS
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias dd='clear'
alias oldvim='/usr/bin/vim'
alias szsh='source ~/.zshrc'

function gc
{
	dir="$1";
	git clone https://github.com/ggila/"$1".git;
}

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}

# Git rev
function _ps1_git_rev()
{
	if [[ "$4" -gt "0" ]]; then
		printf "%s" "$2-$4$3 "
	fi
	if [[ "$5" -gt "0" ]]; then
		printf "%s" "$1+$5$3 "
	fi
};

# Git status
function _ps1_git()
{
	BRANCH=`git rev-parse --abbrev-ref HEAD 2> /dev/null` > /dev/null
	if [[ $? -eq 0 ]]; then
		if [[ ! "$BRANCH" == "master" ]]; then
			PRINT="[$BRANCH] "
		else
			PRINT=""
		fi
		STATUS=$(git status --porcelain)
		COLUM1=`echo "$STATUS" | cut -c 1-1`
		COLUM2=`echo "$STATUS" | cut -c 2-2`
		if [[ "$COLUM1" == *"A"* ]]; then
			PRINT=$PRINT"$1A"
		fi
		if [[ "$COLUM1" == *"D"* ]]; then
			PRINT=$PRINT"$1D"
		fi
		if [[ "$COLUM1" == *"M"* ]]; then
			PRINT=$PRINT"$1M"
		fi
		if [[ "$COLUM1" == *"R"* ]]; then
			PRINT=$PRINT"$1R"
		fi
		if [[ "$COLUM2" == *"D"* ]]; then
			PRINT=$PRINT"$2D"
		fi
		if [[ "$COLUM2" == *"M"* ]]; then
			PRINT=$PRINT"$2M"
		fi
		if [[ "$COLUM2" == *"?"* ]]; then
			PRINT=$PRINT"$2?"
		fi
		if [[ "${#PRINT}" -gt "0" ]]; then
			printf "%s " "$PRINT$3"
		fi
		_ps1_git_rev "$1" "$2" "$3" `git rev-list --left-right --count origin...HEAD 2> /dev/null || echo "0 0"`
	fi
};

# Zsh
function precmd()
{
	export PROMPT="%F{grey}%m %F{green}%\->%f `_ps1_git "%F{green}" "%F{red}" "%f"`|"
};
