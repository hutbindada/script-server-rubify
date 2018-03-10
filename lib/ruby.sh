#!/bin/bash

function install_essentials_components {
  log "install_essentials: Installing Essentials and Components------------------------------------------------"
  sudo apt-get -y install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev \
  libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev gcc g++ libcurl4-openssl-dev \
  linux-headers-generic imagemagick libmysqlclient-dev git libjpeg-dev monit nginx libpq-dev redis-server nodejs \
  libmagickwand-dev libffi-dev iptables-persistent
  sudo ln -nfs /usr/bin/nodejs /usr/bin/node
}

function add_ffmpeg {
  log "add_ffmpeg: Adding FFMPEG-------------------------------------------------------------------------------"
  sudo add-apt-repository ppa:mc3man/trusty-media
  sudo apt-get -y update
  sudo apt-get -y dist-upgrade
  sudo apt-get -y install ffmpeg
}

function install_docsplit {
  log "install_docsplit: Installing DOCSPLIT-------------------------------------------------------------------"
  sudo apt-get -y install graphicsmagick
  sudo aptitude install poppler-utils poppler-data
  sudo apt-get -y install ghostscript
  sudo aptitude install pdftk
  sudo apt-get -y install tesseract tesseract-ocr # optional
  sudo aptitude install libreoffice # optional
}

function fix_locale_issue {
  log "fix_locale_issue: Updating locale to en_US.UTF-8--------------------------------------------------------"
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  locale-gen en_US.UTF-8
  sudo apt-get -y install locales
  sudo dpkg-reconfigure locales
}

function install_ntp {
  log "install_ntp: Install ntp time---------------------------------------------------------------------------"
  sudo apt-get -y install ntp
  sudo service ntp restart
}

function install_rbenv
{
  log "install_rbenv: Installing standard rbenv..."
  curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
}

function fix_locale_rbenv_command {
  log "fix_locale_rbenv_command: Add Locale Fix and Enable rbenv command in bash-------------------------------"
  echo 'export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  
  export RBENV_ROOT="${HOME}/.rbenv"
  if [ -d "${RBENV_ROOT}" ]; then
    export PATH="${RBENV_ROOT}/bin:${PATH}"
    eval "$(rbenv init -)"
  fi' >> ~/.bashrc
  source ~/.bashrc
}


function install_ruby
{
  log "install_ruby: Installing standard ruby, set global, install gem-----------------------------------------"
  rbenv install 2.4.1
  sudo aptitude purge ruby
  rbenv global 2.4.1
  gem install bundler
}

function install_mysql
{
  log "install_mysql: Installing mysql server------------------------------------------------------------------"
  sudo apt-get -y install mysql-server mysql-common mysql-client libmysqlclient-dev
}