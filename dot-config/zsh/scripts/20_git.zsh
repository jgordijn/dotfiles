# Git aliases
# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# This function, `gro`, opens the current branch of a Git repository in the default web browser.
grob () {
    local REMOTE="${1:-origin}"
    local CURRENT_BRANCH=`git branch --show-current`
    local BASE_URL=`git remote get-url "${REMOTE}" | sed 's|\.git$||' | sed -E 's;^(git@|https://);;' | sed 's|:|/|'`
    if [[ $BASE_URL == *"github.com"* ]]
    then
        open "https://${BASE_URL}/tree/${CURRENT_BRANCH}"
    else
        open "https://${BASE_URL}/-/tree/${CURRENT_BRANCH}"\;
    fi
}

# Open the main branch
unalias grm 2>/dev/null
grm () {
    local REMOTE="${1:-origin}"
    local BASE_URL=`git remote get-url "${REMOTE}" | sed 's|\.git$||' | sed -E 's;^(git@|https://);;' | sed 's|:|/|'`
    open "https://${BASE_URL}"
}

# Open the pull requests
grps() {
    local REMOTE="${1:-origin}"
    local BASE_URL=`git remote get-url "${REMOTE}" | sed 's|\.git$||' | sed -E 's;^(git@|https://);;' | sed 's|:|/|'`
    open "https://${BASE_URL}/pulls"
}

alias gro="gh pr view --web"

alias gf='git fetch'
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gst='git status'
alias gmom='git merge origin/$(git_main_branch)'
alias gcm='git checkout $(git_main_branch)'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glog='git log --oneline --decorate --graph'
# Go to root of the git repo
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gpf='git push --force-with-lease --force-if-includes'
alias gd='git diff'
alias gwl='git worktree list'
alias gwr='git worktree remove'
alias gwa='git worktree add'
