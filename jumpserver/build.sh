docker rmi openfans/jumpserver:latest
docker rmi openfans/jumpserver:v1.4.4
docker build --no-cache -f Dockerfile -t openfans/jumpserver:v1.4.4 .
docker tag openfans/jumpserver:v1.4.4 openfans/jumpserver:latest
