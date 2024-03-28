FROM        --platform=$TARGETOS/$TARGETARCH debian:bullseye-slim

LABEL       author="Leonardo Juarez" maintainer="leonardo010693@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/LeoJR93/yolk"
LABEL       org.opencontainers.image.licenses=MIT
LABEL       org.opencontainers.image.description="Docker image para compilar AzerothCore"

## Update base packages
RUN         apt update \
            && apt full-upgrade -y

## Install dependencies
RUN         apt install -y gcc g++ libgcc1 libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 
RUN         apt install -y libfontconfig libicu67 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libduktape205 locales gnupg2 apt-transport-https software-properties-common ca-certificates 
RUN         apt install -y liblua5.3-0 libz-dev rapidjson-dev tzdata libevent-dev libzip4 libprotobuf23 libfluidsynth2 procps libstdc++6 tini jq
RUN         apt install -y git cmake make gcc g++ clang libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev build-essential p7zip-full screen fail2ban -y

## Configure locale
RUN         update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales\
            && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100\
            && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
RUN         useradd -m -d /home/container -s /bin/bash container

##Environmet
USER        container
ENV         USER=container HOME=/home/container
ENV         DIR_REPOSITORIO=/home/container/AzerothCore
ENV         DIR_BUILD=/home/container/AzerothCore/build
ENV         DIR_SERVER=/home/container/server
ENV         DIR_CONF=/home/container/etc
ENV         DIR_ASSETS=/home/container/server/data

ENV         DEBIAN_FRONTEND noninteractive

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]