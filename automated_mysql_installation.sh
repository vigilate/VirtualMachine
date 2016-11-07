#!/bin/bash

MYSQL="toto"
MYSQL_ROOT_PASSWORD="toto" #$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo)
echo $MYSQL_ROOT_PASSWORD >> mysql_passwd

echo "[!] RUN INSTALLATION"
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"

expect \"Change the root password?\"
send \"Y\r\"

expect \"New password: \"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Re-enter new password: \"
send \"$MYSQL_ROOT_PASSWORD\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "[!] GO"
echo "$SECURE_MYSQL"

echo "[!] INSTALLED"
