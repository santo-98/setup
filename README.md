# My Mac Setup

Yeah, I forget stuff.

So I made this list of configurations I need to do in a new Mac OS build.

## Basic Stuff 🤙

Some basic installations and updates that are the **NOT** optional.

### Update System Preferences

- ** > System Preferences > Software Update**
- General > Sidebar icon size > Large
- Dock > Automatically hide the dock
- Trackpad > Tap to click
- Accessibility > Pointer Control > Increase Double-click speed to full
- Dock & Menu bar > show recent applications in dock > off
- Clock > Announce time > every half hour
- Clock > Display time in seconds
- Finder > View > Show Path bar

### HD Wallpapers
- https://www.pexels.com/

#### Install [Homebrew](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

#### Brew [Node](https://nodejs.org/en/) and other binaries

```sh
brew install node
brew install mysql
```
## Tools for productivity
```sh
clipy
warp
Fliqlo
```
## Prezto for Zsh 😈

### Main Prezto Installation

```sh
zsh
```

```sh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

```sh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

```sh
chsh -s /bin/zsh
```

Open a new Zsh terminal window or tab.

#### Configure theme and modules

Go to,

```sh
open ~/.zpreztorc
```

And replace theme and modules,

```sh
zstyle ':prezto:module:prompt' theme 'minimal'
```

```sh
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'autosuggestions' \
  'spectrum' \
  'utility' \
  'completion' \
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt'
```

## Git love ❤️

### Setup Git

```sh
git config --global user.name "santhosh"
git config --global user.email "ssanthoshss@gmail.com"
git config --global color.ui true
```

Then connect [GitHub with SSH](https://help.github.com/articles/connecting-to-github-with-ssh/) and make sure you can [Sign commits with GPG](https://help.github.com/articles/signing-commits-with-gpg/).

### Folder for Git Version Control

```sh
mkdir ~/Projects
```

## Apps and Fonts ⚡️

```sh
# Apps
brew install google-chrome
brew install visual-studio-code
brew install zoom

```

## OS Changes 💿

Sometimes mac doesn't get it right.

```sh
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Show absolute path in finder's title bar.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# Quit finder using cmd-q
defaults write com.apple.finder QuitMenuItem -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

## Aliases 🙆‍♂️

In terminal do, `code ~/.zprofile` and add,

```sh
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Lazy git
gitpush() {
  echo -e "\e[0;32m YOUR GIT STATUS: \e[0m"
  git status -s -u -v
  echo -n "\e[0;32m Press ENTER to continue: \e[0m"
  read var_name
  echo -e "\e[0;32m ADDING ALL... \e[0m"
  git add . -v
  echo -e "\e[0;32m COMMITING... \e[0m"
  git commit -a -s -v -m "$*"
  echo -e "\e[0;32m PUSHING... \e[0m"
  git push -v
}
alias lg=gitpush

# Youtube Downloader
youtubedownload() {
  youtube-dl \
    -f '(bestvideo[ext=mp4]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' \
    --max-filesize 9999m \
    --console-title \
    -o "~/Downloads/%(title)s.%(ext)s" \
    $*
}
youtubedownloadlist() {
  youtube-dl \
    -f '(bestvideo[ext=mp4]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' \
    --max-filesize 9999m \
    --console-title \
    -o "~/Downloads/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" \
    $*
}
alias yd=youtubedownload
alias ydl=youtubedownloadlist

# To Convert Video Files to GIF for Dribbble
# Usage: vtg videofilename.mov
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=1600:1200:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}
alias vtg=videotogif

# Torrent Downloader (https://github.com/webtorrent/webtorrent-cli)
tplay() {
  webtorrent download $* --iina --out "Downloads/" --no-quit
}
tdown() {
  webtorrent download $* --out "Downloads/"
}

# Image Compressor (https://github.com/funbox/optimizt)
ic() {
  optimizt --verbose $*
}

# Find and delete .DS_Store Files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty Trash and Other Caches
alias emptytrash="sudo rm -rfv ~/Library/Caches/; sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# To Open VS Code
alias c='code .'

# Update everything at once
alias brewup='brew update && brew upgrade && brew cu -a -f --cleanup -y && brew cleanup; brew doctor'

# mysql DB
export DATABASE_USERNAME="root"
export DATABASE_PASSWORD=""
export DATABASE_DEV_USERNAME="root"
export DATABASE_DEV_PASSWORD=""
export DATABASE_SOCKET="/tmp/mysql.sock"
export DATABASE_DEV_SOCKET="/tmp/mysql.sock"

# Notes
pushnotes() {
  cd && cd projects/orison
  now=$(date '+%A %d %m %Y %X')
  git add . -v
  git commit -a -s -v -m $now
  git push -v
}
alias notes='cd && cd projects/orison && code .'

alias hn='cd && cd Projects/hellonext-webapp'

alias zoom='open "zoommtg://zoom.us/join?confno=682865740&pwd=SKCRIPT"'
# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
export PATH

alias python='python3'

alias newtab='ttab'

alias startrails="lsof -Fp -i:3000 | head -n 1 | sed 's/^p//' | xargs kill -9 && rails s"

starthn() {
  newtab "hn && make up"
  newtab "hn && bundle exec sidekiq"
  newtab "hn && startrails"
  newtab "hn && rails c"
  newtab "hn && mysql.server start && brew services restart memcached"
}
```

## That's it! 👏

Enjoy your fully configured mac os, future me.
