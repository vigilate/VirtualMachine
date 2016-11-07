#!/bin/bash

clone_project(){

    #BACKEND
    git clone https://github.com/vigilate/backend || cd ./backend && git pull origin master && cd
    cd ./backend && pip3 install -r requirements.txt

    #FRONTEND
    git clone https://github.com/vigilate/frontend || cd ./frontend && git pull origin master && cd
    
}

required_services(){

    apt-get update
    apt-get install expect
    apt-get --yes install mysql-server mysql-client libmysqlclient15-dev mysql-common postgresql
    ./automated_mysql_installation.sh
}


if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi


required_services
#clone_project

