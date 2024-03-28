#!/bin/bash
# Compilar Trinity core
#
# Server Files: /server

#TAG_TRINITYCORE : master, 3.3.5, wotlk ramas del nucleo trinicore
#URL_CONFIG : master, 3.3.5
#
#

#Fnciones Escenciales

#newDB
#Crea una base de datos en el Database host del panel pterodactyl se requiere un token con permisos minimos de lectua y escritura para Database Hosts y Server Databases
#orden de los argumento
#nombredb,permisos
#retorna la infomacion de para la conexion a la base de datos en formato JSON

conf_world_master="https://github.com/TrinityCore/TrinityCore/blob/master/src/server/worldserver/worldserver.conf.dist"
conf_bnet_master="https://github.com/TrinityCore/TrinityCore/blob/master/src/server/bnetserver/bnetserver.conf.dist"

conf_world_335="https://github.com/TrinityCore/TrinityCore/blob/3.3.5/src/server/worldserver/worldserver.conf.dist"
conf_auth_335="https://github.com/TrinityCore/TrinityCore/blob/3.3.5/src/server/authserver/authserver.conf.dist"


##Compilar servidor
chmod -x compilar.sh
./compilar.sh

cd ${DIR_CONF}
##Agregar archivos de configuracion
if [ "${TAG_TRINITYCORE}" == "master"]:
then
    wget -o "worldserver.conf" $conf_world_master
    wget -o "bnetserver.conf" $conf_bnet_master
elif [ "${TAG_TRINITYCORE}" == "3.3.5"]:
then
    wget -o "worldserver.conf" $conf_world_335
    wget -o "authserver.conf" $conf_auth_335
else
    echo -e "Error encotnrando rama"
fi

##Crear Bases
chmod -x crearbases.sh
./create_db.sh 

cd ${DIR_CONF}
buscar='"."' 
reemplazar='"'$(DIR_ASSETS)'"'
sed -i '/DataDir =/s/' $buscar '/' '"' $(DIR_ASSETS) '"/g' worldserver.conf



cd ${HOME}
wget -P ${HOME} -tries=100 -A zip -nd -nH -np -r ${URL_ASSETS} 
if [ -f "cameras.zip" && -f "dbc.zip" && -f "maps.zip" ]
then
    echo "Archivos CAMERAS,DBC,MAPS encontradors procede a descomprimir"
    unzip cameras.zip -d ${DIR_ASSETS}
    unzip dbc.zip -d ${DIR_ASSETS}
    unzip maps.zip -d ${DIR_ASSETS}
    rm cameras.zip
    rm dbc.zip
    rm maps.zip

else
    echo "Archivos incompletos"
    exit (1)
fi
if [ "${TAG_TRINITYCORE}" == "master"]:
then
    if [ -f "gt.zip" ]
    then
        echo "Archivos GT encontradors procede a descomprimir"
        unzip gt.zip -d ${DIR_ASSETS}
        rm gt.zip
    else
        echo "Archivos incompletos"
        exit (1)
    fi
fi
if [ -f "vmaps.zip" ]
then
    echo "Archivos VMAPS encontradors procede a descomprimir"
    unzip vmaps.zip -d ${DIR_ASSETS}
    rm vmaps.zip
else
if [ -f "mmaps.zip" ]
then
    echo "Archivos MMAPS encontradors procede a descomprimir"
    unzip mmaps.zip -d ${DIR_ASSETS}
    rm mmaps.zip
else

cd ${DIR_SERVER}/bin/
##Descargar bases de datos para importar a las bases de datos creadas
wget -P ${DIR_SERVER}/bin/ -o TDB.7z -tries=100 ${URL_TDB}
if [ -f TDB.7z ];
then
    7z e TDB.7z
    rm TDB.7z
else
    echo "URL incorrecto, no se encontro archivo"
    exit (1)
fi
##Primer arranque de worldserver para importar archivos
cd ${DIR_SERVER}/bin/
echo -ne '\n' | worldserver