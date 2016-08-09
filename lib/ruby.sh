#!/bin/bash

function install_essentials_components {
  log "install_essentials: Installing Essentials and Components..."
  apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev \
  libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev gcc g++ libcurl4-openssl-dev \
  linux-headers-generic imagemagick libmysqlclient-dev git libjpeg-dev monit nginx libpq-dev redis-server nodejs \
  libmagickwand-dev libffi-dev iptables-persistent
  ln -nfs /usr/bin/nodejs /usr/bin/node
}

function add_ffmpeg {
  log "add_ffmpeg: Adding FFMPEG..."
  add-apt-repository ppa:mc3man/trusty-media
  apt-get update
  apt-get dist-upgrade
  apt-get install ffmpeg
}

function install_docsplit {
  log "install_docsplit: Installing DOCSPLIT..."
  apt-get install graphicsmagick
  aptitude install poppler-utils poppler-data
  apt-get install ghostscript
  aptitude install pdftk
  apt-get install tesseract tesseract-ocr # optional
  aptitude install libreoffice # optional
}

function fix_locale_issue {
  log "fix_locale_issue: Updating locale to en_US.UTF-8..."
  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  locale-gen en_US.UTF-8
  apt-get install locales
  dpkg-reconfigure locales
}

function install_ntp {
  log "install_ntp: Install ntp time..."
  apt-get -y install ntp
  service ntp restart
}

function install_rbenv
{
  log "install_rbenv: Installing standard rbenv..."
  curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
}

function fix_locale_rbenv_command {
  log "fix_locale_rbenv_command: Add Locale Fix and Enable rbenv command in bash..."
  echo 'export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export RBENV_ROOT="${HOME}/.rbenv"
  if [ -d "${RBENV_ROOT}" ]; then
    export PATH="${RBENV_ROOT}/bin:${PATH}"
    eval "$(rbenv init -)"
  fi' >> ~/.bashrc
  . ~/.bashrc
}


function install_ruby
{
  log "install_ruby: Installing standard ruby, set global, install gem..."
  rbenv install 2.1.2
  aptitude purge ruby
  rbenv global 2.1.2
  gem install bundle
}

function install_mysql
{
  log "install_mysql: Installing mysql server..."
  apt-get install mysql-server mysql-common mysql-client libmysqlclient-dev
}