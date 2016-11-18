# Telegram-Warning-Bot [![](https://img.shields.io/badge/Docker%20Hub-BirkhoffLee%2Ftelegram--warning--bot-blue.svg)](https://hub.docker.com/r/birkhofflee/telegram-warning-bot/) [![](https://images.microbadger.com/badges/image/birkhofflee/telegram-warning-bot.svg)](https://microbadger.com/images/birkhofflee/telegram-warning-bot) ![Docker Stars](https://img.shields.io/docker/stars/birkhofflee/telegram-warning-bot.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/birkhofflee/telegram-warning-bot.svg)
A Telegram bot for pushing real-time emergency alerts to subscribers.

# Deployment
Simply run this to make the bot running:
```
$ docker run -v /path/to/config.json:/var/www/Telegram-Warning-Bot-master/src/config.json:ro -itd birkhofflee/telegram-warning-bot
```

# Configuration
Rename [src/config.sample.json](src/config.sample.json) to `src/config.json` and modify any settings you want to change.  
In addition, `telegram_token` can be gained from [@BotFather](https://telegram.me/BotFather) on Telegram.

# Contributing
Only one rule: **Test before submitting a pull request**.

# Security Reports
Please contact [admin@birkhoff.me](mailto:admin@birkhoff.me), thank you very much.

# License
See [LICENSE](LICENSE).
