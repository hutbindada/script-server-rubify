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
  apt-get update
  apt-get upgrade
  apt-get install aptitude
  aptitude -y update
  aptitude -y safe-upgrade
  aptitude -y full-upgrade
}
