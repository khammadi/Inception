FROM debian:11

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

COPY ./tools/word_press.sh  .

ENTRYPOINT ["./word_press.sh"]