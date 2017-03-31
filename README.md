# ahmet’s macOS Setup

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


- Shortcuts
  - Accessibility: Invert colors: Cmd+Shift+I
  - Screenshots: Save selected area to file: Cmd+Shift+4
  - Screenshost: Save selected area to clipboard: Cmd+Shift+3
- Hot Corners:
  - Top-right: Put Display to Sleep
  - clear others

Tweaks:

```
defaults write com.apple.finder AppleShowAllFiles true   # Show hidden files
defaults write com.apple.finder ShowStatusBar -bool true # Show Finder statusbar

# Default Finder location is the home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

chflags nohidden ~/Library                               # Unhide ~/Library
```

## Base Software

- Install Homebrew: https://brew.sh
  - `brew analytics off`
- Install iTerm2:
  - `brew install Caskroom/cask/iterm2`
- Install oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh

## Other Software

Utilities:

    brew cask install spectacle flux clipmenu

- Security->Accessibility: Give Spectacle access
- Launch Spectacle at Login
- Launch ClipMenu at Login and hide from Menu Bar

System Tools:

```
brew install coreutils \
	findutils \
	proctools \
	htop \
	pstree \
	tree \
	watch \
	gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
```

Development Tools:

```
brew install \
	git \
	diff-so-fancy \
	ccat \
	hub \
	go \
	jq \
	ack \
	protobuf \
	wget \
	Caskroom/cask/google-cloud-sdk \
	Caskroom/cask/visual-studio-code
```

Containers:

```
brew install \
	kubectl \
	Caskroom/cask/docker \
	Caskroom/cask/minikube \
	docker-machine-driver-xhyve

# minikube uses xhyve, which requires privileged access to the hypervisor
sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

Misc:

```
brew install \
	Caskroom/cask/coconutbattery \
	Caskroom/cask/slack \
	Caskroom/cask/spotify
```

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
    git config --global core.pager "diff-so-fancy | less --tabs=1,5 -R"

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
