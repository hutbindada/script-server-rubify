function log {
  if [ ! -n "$1" ]; then
    log "log: requires text string as its argument"
    return 1;
  fi
  echo "`date '+%D %T'` -  $1" >> $LOG_FILE
  echo "`date '+%D %T'` -  $1"
}


function upgrade_system {
  log "upgrade_system: Upgrading System------------------------------------------------------------------------"
  sudo apt-get -y update
  sudo apt-get -y upgrade
  sudo apt-get -y install aptitude
  sudo aptitude -y update
  sudo aptitude -y safe-upgrade
  sudo aptitude -y full-upgrade
}
