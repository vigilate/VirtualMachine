FROM ubuntu:latest

MAINTAINER fr0g "fr0g.security@gmail.com"

# Base
RUN apt-get update
RUN apt-get -y install git python3 python3-pip python-dev

RUN apt-get -y install libmysqlclient-dev postgresql-server-dev-9.5 postgresql

# Project directory
RUN mkdir /vigilate

# Clone backend
RUN mkdir /vigilate/backend/ && git clone https://github.com/vigilate/backend.git /vigilate/backend/.

# Install backend dependancies
RUN pip3 install -r /vigilate/backend/requirements.txt
