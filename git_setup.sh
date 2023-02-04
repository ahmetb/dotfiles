#!/bin/bash
set -euo pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EMAIL_1="ahmetalpbalkan"
EMAIL_2="gmail.com"

set -x

# author
git config --global --replace user.name "Ahmet Alp Balkan"
git config --global --replace user.email "${EMAIL_1}@${EMAIL_2}"

# pull strategy
git config --global --replace pull.ff only

# use https remotes and osxkeychain for creds
git config --global --replace credential.helper osxkeychain
git config --global --replace url.git\@github\.com\:.pushInsteadOf https://github.com/
git config --global --replace gpg.program "gpg"
git config --global --replace commit.gpgsign true  # if you want to sign every commit

# use ssh in hub (commented out since pushInsteadOf)
# git config --global --replace hub.protocol ssh # https://github.com/github/hub/issues/1614

# diff-so-fancy and its color scheme
git config --global --replace core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global --replace color.ui true
git config --global --replace color.diff-highlight.oldNormal "red bold"
git config --global --replace color.diff-highlight.oldHighlight "red bold 52"
git config --global --replace color.diff-highlight.newNormal "green bold"
git config --global --replace color.diff-highlight.newHighlight "green bold 22"
git config --global --replace color.diff.meta "227"
git config --global --replace color.diff.frag "magenta bold"
git config --global --replace color.diff.commit "227 bold"
git config --global --replace color.diff.old "red bold"
git config --global --replace color.diff.new "green bold"
git config --global --replace color.diff.whitespace "red reverse"

# rebase helper
git config --global --replace sequence.editor interactive-rebase-tool

# install symlink for ssh config
# SSH_CONFIG="$HOME/.ssh/config"
# if [[ -f "$SSH_CONFIG" ]]; then
#   rm "$SSH_CONFIG"
# fi
# ln -s "$SCRIPT_DIR/ssh_config" "$SSH_CONFIG"

git config --global --replace core.editor "vim"
git config --global --replace core.excludesfile ~/.gitignore_global

git config --global --replace init.defaultBranch "main"

# use vscode as the editor
# git config --global --replace core.editor "code --wait"
