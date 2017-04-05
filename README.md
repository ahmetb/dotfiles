# ahmet’s macOS Setup

## Shell

Install oh-my-zsh from https://github.com/robbyrussell/oh-my-zsh

## Package manager

- Install Homebrew: https://brew.sh
- Run `brew analytics off`

## Install symlinks

Run `./install_symlinks.sh` to install the dotfiles. Restart the shell for it to
take effect.

## OS Settings

- Invert Trackpad Scroll Direction to non-natural.
- Show battery percentage on menu bar.
- Show date on menu bar.
- Remove useless items from the Dock.
- Move Dock to right, make it smaller.
- Drag `Downloads` folder next to the Trash on the Dock.
  - Right Click -> Sort by Date Added.
- Show Path Bar on Finder.
- Move $HOME folder to Finder sidebar.


- Set shortcuts
  - Accessibility: Invert colors: Cmd+Shift+I
  - Screenshots: Save selected area to file: Cmd+Shift+4
  - Screenshost: Save selected area to clipboard: Cmd+Shift+3
- Hot Corners:
  - Top-right: Put Display to Sleep
  - Clear other corners

Tweaks:

```
defaults write com.apple.finder AppleShowAllFiles true   # Show hidden files
defaults write com.apple.finder ShowStatusBar -bool true # Show Finder statusbar

# Default Finder location is the home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

chflags nohidden ~/Library                               # Unhide ~/Library

# disable smart quotes and dashes
defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0
```


## Installing software

All software installed on the system must be listed in `Brewfile`. This is
symlinked at `~/.Brewfile` and used by `brew bundle`.

To install all the software:

    brew bundle install --global

To remove software not declared in Brewfile:

    brew bundle cleanup --global

To save installed software to Brewfile (you should still reorganize file once
saved):

    brew bundle dump --global

## Post-insatllation Configuration

- **Spectacle**
  - Security->Accessibility: Give access
  - Launch at Login
- **ClipMenu**
  - Launch at Login
  - Hide from Menu Bar
- **fzf** completion scripts:

      /usr/local/opt/fzf/install

- **minikube** xhyve driver:

		# minikube uses xhyve, which requires privileged access to the hypervisor
		sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
		sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

## Settings Sync

- Clone this repo and run `install_symlinks.sh`
    - Open a new terminal to take effect.
- iTerm2->Preferences->Load Preferences From: com.googlecode.iterm2.plist directory.
    - Restart iTerm2.

- For GPG instructions, follow [.gnupg/README](.gnupg/README) file.

- VSCode:
  - Install "Settings Sync" extension and reload.
  - Run '> Sync: Download Settings'
  - Enter gist ID in `vscode.sync` file to prompt.
  - Once extensions are installed 'Reload' (or Restart)
  - Run '> Sync: Update/Upload Settings'
  - Create a token with 'gist' permissions and save it to the prompt
  - Wait for the Sync Summary.

## Git Setup

    git config --global user.name "Ahmet Alp Balkan"
    git config --global user.email 'email@here.com'
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"


Generate key with a password:

    ssh-keygen -f $HOME/.ssh/github_rsa

(You may want to redact hostname from the public key.)

Add key to the keychain:

    ssh-add $HOME/.ssh/github_rsa          # company-installed
    /usr/bin/ssh-add $HOME/.ssh/github_rsa # system

Upload the key to GitHub. https://github.com/settings/keys

Save this to ~/.ssh/config:

```
Host github.com
	HostName github.com
	User git
	IdentityFile ~/.ssh/github_rsa
```

Test connection:

    ssh -T git@github.com -i ~/.ssh/github_rsa
