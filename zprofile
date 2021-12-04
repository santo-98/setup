#
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

alias hn='cd Projects/hellonext-webapp'

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
  newtab "hn && mysql.server start"
}
