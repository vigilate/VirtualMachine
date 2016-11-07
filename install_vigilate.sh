#!/bin/bash

clone_project(){

    #BACKEND
    git clone https://github.com/vigilate/backend || cd ./backend && git pull origin master && cd ..

    #FRONTEND
    git clone https://github.com/vigilate/frontend || cd ./frontend && git pull origin master && cd ..

    #GIVE SUDO RIGHTS TO DEFAULT USER
    chmod +w /etc/sudoers
    echo -e "vigilate\tALL=(ALL:ALL) ALL" >> /etc/sudoers
    chmod -w /etc/sudoers
    
    #REQUIREMENTS
    cd ./backend
    pip3 install -r requirements.txt
    ./install-pyargon2.sh
    cd ..
}

required_services(){

    apt-get update

    apt-get install sudo
    apt-get install expect

    apt-get --yes install mysql-server mysql-client libmysqlclient15-dev mysql-common postgresql
    ./automated_mysql_installation.sh
}

run_project() {
    echo "RUN PROJECT ..."
    cd backend

    python3 manage.py makemigrations
    python3 manage.py migrate
    python manage.py runserver 0.0.0.0:1337 &
}

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi


required_services
clone_project

