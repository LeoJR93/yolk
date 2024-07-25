FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="Leonardo Juarez" maintainer="leonardo010693@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/LeoJR93/yolk/cores/debian"
LABEL       org.opencontainers.image.licenses=MIT
LABEL       org.opencontainers.image.description="Docker image debian 12 for pterodactyl panel"

## Update base packages
RUN         apt update \
            && apt upgrade -y

## Install dependencies
RUN         apt install -y tar wget sed

## Configure locale
##RUN         update-locale lang=en_US.UTF-8
##            && dpkg-reconfigure --frontend noninteractive locales
            
RUN         useradd -m -d /home/container -s /bin/bash container

##Environmet
USER        container
ENV         USER=container HOME=/home/container
ENV         DEBIAN_FRONTEND noninteractive

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
