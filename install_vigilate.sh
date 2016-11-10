
1;2802;0c#!/bin/bash

give_sudo_rights(){
    #GIVE SUDO RIGHTS TO DEFAULT USER
    chmod +w /etc/sudoers
    echo -e "vigilate\tALL=(ALL:ALL) ALL" >> /etc/sudoers
    chmod -w /etc/sudoers
}

clone_project(){
    #BACKEND
    git clone https://github.com/vigilate/backend || cd ./backend && git pull origin master && cd ..

    #FRONTEND
    git clone https://github.com/vigilate/frontend || cd ./frontend && git pull origin master && cd ..
    
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

    echo "INSTALL MYSQL"
    apt-get --yes install mysql-server mysql-client libmysqlclient15-dev mysql-common
    echo "INSTALL POSTGRESQL"
    apt-get --yes install postgresql postgresql-server-dev-9.4 postgresql-server-dev-all
    echo "INSTALL BULLSHIT"
    apt-get --yes install uwsgi uwsgi-plugin-python3

    cd backend && ./clear_db.sh && cd ..

    echo H4sIAAqxglcAAzWPQW7CMBBF93BETOxrbUN8eC9rtn683758OgfIE75ic0JopBl2OZjd2w7KiRIHtJaPoVBNHv8lWPGaAk0G5kcMJhl90psVZq5JEcXSW1ZmCKvfkqet7CtSpn7igupEnthnV2borhvlV2bQCfGN6MizfbU3wQcyGfLCszbj7Oox72NcVdYiZLhXavzBbmQdpgn9q8Pm8bZ3DlBqHm+QYGpV5gqMNGee3qpfCmfqSUP6nPABolsVqAAEAAA== | base64 -d | gzip -d | sudo tee /lib/systemd/system/uwsgi.service

    #give_sudo_rights
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

#required_services
clone_project
required_services
