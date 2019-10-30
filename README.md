# site-availability
site availability check

При необходимости нужно установить gem mail:
gem install mail

Запуск:
ruby start.rb mail_from@ukr.net psw(from_mail.ukr.net) mail_to@example.com

где
ruby start.rb [ящик почтового сервиса ukr.net, с которого будет отправляться сообщение] [пароль на ящик с которого отправляется сообщение] [ящик получателя сообщений,любой]

Остановка запущенного процесса:
ruby stop.rb
