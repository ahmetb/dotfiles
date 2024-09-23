# ahmet’s macOS Setup

## Download Xcode

For google, go/xcode. This will take a lot of time, so start with this.

## OS Settings

> TODO: find `defaults write` commands for these.

- Invert Trackpad Scroll Direction to non-natural.
- Show battery percentage on menu bar.
- Show date on menu bar.
- Keyboard &rarr; Text &rarr; Uncheck autocorrect and such settings.
- Remove useless items from the Dock.
- Move Dock to right, make it smaller.
- Drag `Downloads` folder next to the Trash on the Dock.
  - Right Click &rarr; Sort by Date Added.
- Show Path Bar on Finder.
- Move $HOME folder to Finder sidebar.

- Set shortcuts
  - Accessibility: Invert colors: Cmd+Shift+I
  - Screenshots:
    - Uncheck all
    - Save selected area to file: Cmd+Shift+4
    - Save selected area to clipboard: Cmd+Shift+2
- Hot Corners:
  - Top-left: Put Display to Sleep
  - Clear other corners

Tweaks:

```
defaults write NSGlobalDomain AppleShowScrollBars -string "Always" # show scrollbar always
defaults write com.apple.finder AppleShowAllFiles true   # Show hidden files
defaults write com.apple.finder ShowStatusBar -bool true # Show Finder statusbar

# Default Finder location is the home folder
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

chflags nohidden ~/Library                               # Unhide ~/Library

# default screenshot path
defaults write com.apple.screencapture location ~/Downloads

# disable smart quotes and dashes
defaults write 'Apple Global Domain' NSAutomaticDashSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticQuoteSubstitutionEnabled 0
defaults write 'Apple Global Domain' NSAutomaticPeriodSubstitutionEnabled 0
```

## Shell

Install oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh

## Package manager

- Install Homebrew &mdash;to `$HOME/.homebrew` instead of /usr/local:

      git clone https://github.com/Homebrew/brew.git $HOME/.homebrew

- Run `which brew` to confirm the one in home directory is picked up.
- Run `brew analytics off`

## Installing software manually

- Download Dropbox
  - Sign in 
  - Sync only 1Password
- Download iPassword 6
  - Choose .opvault file from Dropbox
  - Go to Software Licenses &rarr; open the 1Password license file
  - Accept to use 1Password Mini when prompted

## Installing software via Homebrew

All software installed on the system must be listed in `.Brewfile`. This is
symlinked at `~/.Brewfile` and used by `brew bundle`.

To install all the software, add it to `.Brewfile` and run:

    brew bundle --global

Some stuff will take long, in that case, identify which packages and update
`.Brewfile` to install them with `args: ['force-bottle']` or do a one-off
`brew install --force-bottle [pkg]` install.

Some things that require manual installation after Homebrew:

```sh
# if pip requires sudo, something is wrong, because the
# Homebrew bundle should install a $USER-writable over system-python.
    
pip install virtualenv
pip install virtualenvwrapper
```

## Post-Installation Configuration

- **Rectangle**
  - Security->Accessibility: Give access
  - Launch at Login
- **Clipy**
  - Launch at Login
  - Hide from Menu Bar
  - Set history size to 200
  - Set paste key to <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>
- **fzf** completion scripts:

      "$HOMEBREW_PREFIX"/opt/fzf/install

- **minikube** xhyve driver:

      # minikube uses xhyve, which requires privileged access to the hypervisor
      sudo chown root:wheel /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
      sudo chmod u+s /usr/local/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

## Settings Sync

- Clone this repo and run `install_symlinks.sh`
    - Open a new terminal to take effect.
- iTerm2->Preferences->Load Preferences From: com.googlecode.iterm2.plist directory.
    - Restart iTerm2.

- VSCode:
  - Install "Settings Sync" extension and reload.
  - Run '> Sync: Download Settings'
  - Enter gist ID in `vscode.sync` file to prompt.
  - Once extensions are installed 'Reload' (or Restart)
  - Run '> Sync: Update/Upload Settings'
  - Create a token with 'gist' permissions and save it to the prompt
  - Wait for the Sync Summary.

## Hardware

- Evoluent ergo mouse driver: https://evoluent.com/support/download/
- Das Keyboard
  - Settings &rarr; Keyboard &rarr; Modifier Keys: flip the Option/Command keys for "daskeyboard" profile.
