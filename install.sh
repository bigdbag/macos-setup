# This script installs commonly used dev tools:
# x-code command line tools, Homebrew
# Node, nvm, ruby, rbenv
# gitflow, git-lfs, git-extras, git-autocomplete
# Chrome, Firefox, Slack, VirtualBox, VSCode, Alfred, iTerm2, OpenJDK, Java, Docker
# ElasticSearch, Postresql, Redis, MySQL
# python3, pip, virtualenv with a default python3 env called 'p3'
# AWS-CLI
#
# Automatic addition of Slack, VSCode, iTerm2, and Chrome to the MacOS dock
#
# Optional font tooling, imagemagick, and commonly used python packages are commented out.  

#!/usr/bin/env bash

# Install command-line tools using Homebrew.
xcode-select --install

# Ask for the administrator password upfront.
sudo -K

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

echo "------------------------------"
echo "Installing python"

brew install python
brew install python3

echo "------------------------------"
echo "Installing ruby"

brew install ruby-build
brew install rbenv
LINE='eval "$(rbenv init -)"'
grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

echo "------------------------------"
echo "Installing node and npm"

brew install node

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install-latest-npm

echo "------------------------------"
echo "Installing font tools"

# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

echo "------------------------------"
echo "Installing git/git-lfs/git-flow/git-extras"
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras

echo "------------------------------"
echo "Installing imagemagick"

# brew install imagemagick

echo "------------------------------"
echo "Installing casks"

# Core casks
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="~/Applications" iterm2
brew cask install --appdir="~/Applications" java
brew cask install homebrew/cask-versions/adoptopenjdk8

# Development tool casks
brew cask install --appdir="/Applications" visual-studio-code
brew cask install --appdir="/Applications" virtualbox

# Misc casks
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" firefox
brew cask install --appdir="/Applications" slack

echo "------------------------------"
echo "Installing Docker"

# Install Docker, which requires virtualbox
brew install docker
brew install boot2docker

echo "------------------------------"
echo "Installing data stores"

# Install data stores
brew install mysql
brew install postgresql
brew install redis
brew install elasticsearch

# Remove outdated versions from the cellar.
brew cleanup

echo "------------------------------"
echo "Setting up pip."

# Install pip
sudo easy_install pip

echo "------------------------------"
echo "Setting up virtual environments."

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
export PIP_REQUIRE_VIRTUALENV=false
sudo pip install virtualenv
sudo pip install virtualenvwrapper

echo "------------------------------"
echo "Source virtualenvwrapper from ~/.extra"

EXTRA_PATH=~/.extra
echo $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Source virtualenvwrapper, added by pydata.sh" >> $EXTRA_PATH
echo "export WORKON_HOME=~/.virtualenvs" >> $EXTRA_PATH
echo "source /usr/local/bin/virtualenvwrapper.sh" >> $EXTRA_PATH
echo "" >> $BASH_PROFILE_PATH
source $EXTRA_PATH

echo "------------------------------"
echo "Setting up p3 virtual environment."

# Create a Python3 data environment
mkvirtualenv --python=/usr/local/bin/python3 p3
# workon p3

# # Install Python data modules
# sudo pip install numpy
# sudo pip install scipy
# sudo pip install matplotlib
# sudo pip install pandas
# sudo pip install sympy
# sudo pip install nose
# sudo pip install unittest2
# sudo pip install seaborn
# sudo pip install scikit-learn
# sudo pip install "ipython[all]"
# sudo pip install bokeh
# sudo pip install Flask

echo "------------------------------"
echo "Setting up AWS-CLI"

pip3 install awscli --upgrade --user

# git autocompletion
echo '[ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ] && . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash' >>~/.bash_profile

# add icons to MacOS dock
brew install dockutil

dockutil --add /Applications/Chrome.app
dockutil --add /Applications/iTerm.app
dockutil --add '/Applications/Visual Studio Code.app'
dockutil --add /Applications/Slack.app


