FROM ubuntu:14.04

MAINTAINER Birkhoff Lee <birkhoff.lee.cn@gmail.com>

# Set the environment up
WORKDIR ~
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install nodejs-legacy npm git ca-certificates -y -q --no-install-recommends; \
    apt-get clean; \
    apt-get autoclean; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install forever and coffeeScript library
RUN npm i -g forever coffee-script

# Download Telegram-Warning-Bot
WORKDIR ~
RUN mkdir /var/www; \
    chmod 755 /var/www; \
    cd /var/www; \
    git clone https://github.com/BirkhoffLee/Telegram-Warning-Bot

# Prepare Telegram-Warning-Bot
WORKDIR /var/www/Telegram-Warning-Bot
RUN npm i

# Ports
EXPOSE 1828

# Run
WORKDIR /var/www/Telegram-Warning-Bot/src
CMD /bin/bash -c "export PORT=1828; export IP=0.0.0.0; forever start -c coffee index.coffee &> /dev/null && forever logs -f 0"
