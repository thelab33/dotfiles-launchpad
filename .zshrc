# ─── ⚡ Instant Prompt (Powerlevel10k) ─────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── ⚙️ Base Environment ───────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export NVM_DIR="$HOME/.nvm"
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share

# ─── 🔮 PATH Setup (Clean & De-duplicated) ────────────────────────────────
typeset -U PATH
export PATH="$HOME/bin:$HOME/bin/browsers:$HOME/bin/windows:$PATH"

# ─── 🎨 Theme & Prompt ────────────────────────────────────────────────────
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh || echo -e "\033[1;33m⚠ Powerlevel10k config missing. Run \033[1;36mp10k configure\033[0m"
# eval "$(starship init zsh)"  # Uncomment if you prefer Starship

# ─── 🔌 Plugins ────────────────────────────────────────────────────────────
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  autoenv
  extract
  history-substring-search
  zsh-completions
  zsh-z
  fzf
)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-z/zsh-z.plugin.zsh 2>/dev/null

# ─── 🧠 Zsh Behavior Tweaks ────────────────────────────────────────────────
ENABLE_CORRECTION="true"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# ─── 🧵 Completion Optimizations ───────────────────────────────────────────
zstyle ':completion:*' menu select
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' case-sensitive false

# ─── ✨ UI / UX Enhancements ───────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240,bold"
ZSH_AUTOSUGGEST_IGNORE_CASE="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# ─── 🔍 FZF Aliases ────────────────────────────────────────────────────────
alias ff="fzf"
alias fh="history | fzf"
alias fg="git log --oneline | fzf | awk '{print \$1}' | xargs git checkout"
alias fhf="history | fzf | sed 's/^ *[0-9]* *//g' | xargs -I {} vim {}"

# ─── 🐍 Python Helpers ─────────────────────────────────────────────────────
[ -f ~/.autoenv/activate.sh ] && source ~/.autoenv/activate.sh

function newpythonproject() {
  mkdir -p ~/Projects/dev/"$1"
  cd ~/Projects/dev/"$1" || return
  python3 -m venv venv
  echo "🐍 Created new Python project: $1"
}

function init_git_repo() {
  git init && git add . && git commit -m "Initial commit"
  echo "🔧 Initialized Git repo"
}

function new_project() {
  mkdir -p ~/Projects/"$1"/{src,docs,tests}
  cd ~/Projects/"$1" || return
  echo "# $1" > README.md
  echo "📦 Created new project: $1"
}

# ─── 🔁 Git Prompt Info (Optional if not using full P10k) ──────────────────
autoload -Uz vcs_info
precmd() { vcs_info }

setopt prompt_subst
PS1='%n@%m %~ $(git_prompt_info)%# '

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}git:(%F{blue}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f) "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}✔"

# ─── 🪟 Windows App Aliases (WSL) ──────────────────────────────────────────
WINUSER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

alias vscode="/mnt/c/Users/$WINUSER/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe"
alias notepadpp="/mnt/c/Program\ Files\ \(x86\)/Notepad++/notepad++.exe"
alias explorer="/mnt/c/Windows/explorer.exe"
alias edge="/mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe"

# ─── 🧙 Auto-launch WSL Launchpad Menu ─────────────────────────────────────
if [[ $- == *i* && -t 1 ]] && command -v launchpad &>/dev/null; then
  launchpad
fi

