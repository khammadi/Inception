FROM debian:12

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server

COPY ./tools/script.sh .

ENTRYPOINT ["./script.sh"]
