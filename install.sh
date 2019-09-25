#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

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

echo "------------------------------"
echo "Installing font tools"

brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

echo "------------------------------"
echo "Installing git/git-lfs/git-flow/git-extras"
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras

echo "------------------------------"
echo "Installing imagemagick"

brew install imagemagick --with-webp

echo "------------------------------"
echo "Installing casks"

# Core casks
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="~/Applications" iterm2
brew cask install --appdir="~/Applications" java

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
brew install mongo
brew install redis
brew install elasticsearch

# Remove outdated versions from the cellar.
brew cleanup

echo "------------------------------"
echo "Setting up pip."

# Install pip
easy_install pip

echo "------------------------------"
echo "Setting up virtual environments."

# Install virtual environments globally
# It fails to install virtualenv if PIP_REQUIRE_VIRTUALENV was true
export PIP_REQUIRE_VIRTUALENV=false
pip install virtualenv
pip install virtualenvwrapper

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
echo "Setting up p2 virtual environment."

# Create a Python2 data environment
mkvirtualenv p2
workon p2

# Install Python data modules
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install sympy
pip install nose
pip install unittest2
pip install seaborn
pip install scikit-learn
pip install "ipython[all]"
pip install bokeh
pip install Flask

echo "------------------------------"
echo "Setting up p3 virtual environment."

# Create a Python3 data environment
mkvirtualenv --python=/usr/local/bin/python3 p3
workon p3

# Install Python data modules
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install sympy
pip install nose
pip install unittest2
pip install seaborn
pip install scikit-learn
pip install "ipython[all]"
pip install bokeh
pip install Flask


###############################################################################
# AWS                                                                         #
###############################################################################

echo "------------------------------"
echo "Setting up AWS."
echo "This script requires pip and virtualenvwrapper to be installed."
echo "See the pydata.sh script."

echo "------------------------------"
echo "Source virtualenvwrapper from ~/.extra"
source ~/.extra

echo "------------------------------"
echo "Updating p2 virtual environment with AWS modules."

# Create a Python2 data environment
# If this environment already exists from running pydata.sh,
# it will not be overwritten
mkvirtualenv p2
workon p2

pip install boto
pip install awscli
pip install mrjob
pip install s3cmd

EXTRA_PATH=~/.extra
echo $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "" >> $EXTRA_PATH
echo "# Configure aws cli autocomplete, added by aws.sh" >> $EXTRA_PATH
echo "complete -C '~/.virtualenvs/py2-data/bin/aws_completer' aws" >> $EXTRA_PATH
source $EXTRA_PATH

echo "------------------------------"
echo "Updating p3 virtual environment with AWS modules."

# Create a Python3 data environment
# If this environment already exists from running pydata.sh,
# it will not be overwritten
mkvirtualenv --python=/usr/local/bin/python3 p3
workon p3

pip install boto
pip install awscli

echo '[ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ] && . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash' >>~/.bash_profile

