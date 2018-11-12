docker rmi aiminick/jumpserver-base:1.4.4
docker rmi aiminick/jumpserver-base:latest
docker build --no-cache -f Dockerfile -t aiminick/jumpserver-base:1.4.4 .
docker tag aiminick/jumpserver-base:1.4.4 aiminick/jumpserver-base:latest
