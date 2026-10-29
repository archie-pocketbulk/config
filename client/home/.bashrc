# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='eza'
alias ll='eza -l --git'
alias cat='bat -p'
PS1='[\u@\h \W]\$ '
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export LIBSEAT_BACKEND=seatd
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
alias aider-open="aider --architect --model openrouter/deepseek/deepseek-v4-flash --editor-model openrouter/qwen/qwen3-coder"
# fzf: Ctrl-r history, Ctrl-t files, Alt-c cd; fd keeps it fast and honours .gitignore
export FZF_DEFAULT_COMMAND='fd --type f'
. /usr/share/fzf/key-bindings.bash
. /usr/share/fzf/completion.bash
