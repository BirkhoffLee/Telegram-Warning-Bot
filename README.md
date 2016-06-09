# Telegram-Warning-Bot [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)]()
A Telegram bot for pushing real-time emergency alerts to subscribers.

# Docker Image
Deploy & run our official Docker image with the following commands:

```
$ docker run -v /path/to/index.coffee:/var/www/Telegram-Warning-Bot/src/index.coffee:ro -itd -p 80:1827 birkhofflee/telegram-warning-bot
```

Use this command to view the logs:

```
$ docker logs [CONTAINER ID]
```

Docker Hub repository URL: https://hub.docker.com/r/birkhofflee/telegram-warning-bot/