#!/bin/bash

#################################
# Security                      #
#################################

function set_basic_security {
  log "set_basic_security: Setting up basic security..."
  apt-get -y install aptitude
  # install_ufw
  # basic_ufw_setup
  basic_iptables_setup
  sshd_permit_root_login no
  sshd_password_authentication no
  sshd_pub_key_authentication yes
  /etc/init.d/ssh restart
}

function install_ufw {
  log "install_ufw: installing firewall"
  aptitude -y install ufw
}

function basic_ufw_setup {
  log "basic_ufw_setup:"
  # see https://help.ubuntu.com/community/UFW
  ufw logging on
  ufw default deny
  ufw allow ssh
  ufw allow http
  ufw allow https
  ufw allow ntp
  ufw enable
}

function basic_iptables_setup {
  cat > /etc/iptables.firewall.rules << EOF
*filter

#  Allow all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
-A INPUT -i lo -j ACCEPT
-A INPUT ! -i lo -d 127.0.0.0/8 -j REJECT

#  Accept all established inbound connections
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#  Allow all outbound traffic - you can modify this to only allow certain traffic
-A OUTPUT -j ACCEPT

#  Allow HTTP and HTTPS connections from anywhere (the normal ports for websites and SSL).
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT

#  Allow ports for testing
# -A INPUT -p tcp --dport 8080:8090 -j ACCEPT

#  Allow SSH connections
#  The -dport number should be the same port number you set in sshd_config
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

#  Allow ping
-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

#  Log iptables denied calls
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

#  Reject all other inbound - default deny unless explicitly allowed policy
-A INPUT -j REJECT
-A FORWARD -j REJECT

COMMIT

EOF

  iptables-restore < /etc/iptables.firewall.rules

  cat > /etc/network/if-pre-up.d/firewall << EOF
#!/bin/sh
/sbin/iptables-restore < /etc/iptables.firewall.rules

EOF

  chmod +x /etc/network/if-pre-up.d/firewall

}

function security_logcheck {
  log "security_logcheck:"
  aptitude -y install logcheck logcheck-database
}

function sshd_edit_value {
    # $1 - param name
    # $2 - Yes/No
    VALUE=$2
    if [ "$VALUE" == "yes" ] || [ "$VALUE" == "no" ]; then
        sed -i "s/^#*\($1\).*/\1 $VALUE/" /etc/ssh/sshd_config
    fi
}

function sshd_permit_root_login {
    sshd_edit_value "PermitRootLogin" "$1"
}

function sshd_password_authentication {
    sshd_edit_value "PasswordAuthentication" "$1"
}

function sshd_pub_key_authentication {
    sshd_edit_value "PubkeyAuthentication" "$1"
}

function sshd_password_authentication {
    sshd_edit_value "PasswordAuthentication" "$1"
}
