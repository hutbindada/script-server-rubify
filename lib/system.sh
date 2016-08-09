function upgrade_system {
  log "upgrade_system: Upgrading System..."
  apt-get update
  apt-get upgrade
  apt-get install aptitude
  aptitude -y update
  aptitude -y safe-upgrade
  aptitude -y full-upgrade
}
