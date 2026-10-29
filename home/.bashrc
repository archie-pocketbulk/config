# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export LIBSEAT_BACKEND=seatd
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
alias aider-open="aider --architect --model openrouter/deepseek/deepseek-v4-flash --editor-model openrouter/qwen/qwen3-coder"
