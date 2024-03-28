##FROM        --platform=$TARGETOS/$TARGETARCH debian:bullseye-slim
FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="Leonardo Juarez" maintainer="leonardo010693@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/LeoJR93/yolk"
LABEL       org.opencontainers.image.licenses=MIT
LABEL       org.opencontainers.image.description="Docker image para compilar Proyectos basados en TrinityCore"

## Update base packages
RUN         apt update \
            && apt full-upgrade -y

## Install dependencies
RUN         apt install -y gcc g++ libgcc1 libc++-dev gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat-traditional telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 
RUN         apt install -y libfontconfig libicu72 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libduktape207 locales gnupg2 apt-transport-https software-properties-common ca-certificates 
RUN         apt install -y liblua5.3-0 libz-dev rapidjson-dev tzdata libevent-dev libzip4 libprotobuf32 libfluidsynth3 procps libstdc++6 tini jq
RUN         apt install -y clang cmake make libbz2-dev libreadline-dev libncurses-dev libboost-all-dev 
RUN         apt install -y build-essential p7zip-full screen fail2ban libmariadbclient-dev-compat

## Configure locale
RUN         update-locale lang=en_US.UTF-8 \
            && dpkg-reconfigure --frontend noninteractive locales\
            && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100\
            && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
RUN         useradd -m -d /home/container -s /bin/bash container

##Environmet
USER        container
ENV         USER=container HOME=/home/container
ENV         DIR_GIT=/home/container/Proyect
ENV         DIR_BUILD=/home/container/Proyect/build
ENV         DIR_SERVER=/home/container/server
ENV         DIR_BIN=/home/container/server/bin
ENV         DIR_CONF=/home/container/server/etc
ENV         DIR_ASSETS=/home/container/server/data

ENV         DEBIAN_FRONTEND noninteractive

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]