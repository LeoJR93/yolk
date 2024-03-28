#!/bin/bash
# Compilar Trinity core
#
# Server Files: /server

#Funcion que verifica la existencia de la carpeta, si existe no realiza ningun cambio, de caso contrario crea el directorio
#argumento, direccion con carpeta a crear
crear_directorio(){
    if [ ! -d $1 ]
    then
        mkdir $1
    fi
}

##Creando carpetas fundamentales 
###repositorio para triniti core, 
###buld para la compilacion del proyecto,
###server para los binarios
crear_directorio(${DIR_REPOSITORIO})
crear_directorio(${DIR_SERVER})
crear_directorio(${DIR_CONF})
crear_directorio(${DIR_ASSETS})

##Comprobar si existe repositorio activo en la carpeta de repositorio de existir mandara un pull para actualizarlo si no llamara un pool para bajarlo
cd ${DIR_REPOSITORIO}
statusResult=$(git status -u --porcelain)
substring="not a git repository"
if [[ "$statusResult" == *"$substring"* ]]
then
    ##Clonar repositorio
    cd ${HOME}
    if [ ["${TAG_TRINITYCORE}" == "master"] || [ "${TAG_TRINITYCORE}" == "3.3.5"] || [ "${TAG_TRINITYCORE}" == "wotlk_classic"]]; then
        echo -e "${TAG_TRINITYCORE}"
        git clone -b ${TAG_TRINITYCORE} ${URL_REPO}
    else
        echo -e "Error encotrando rama"
        exit
    fi
else
    if [ -z statusResult ]
    then
        echo 'No hay actualizaciones:'
        exit
    else
        echo 'Actualizando repositorio local:'
        git pull origin ${TAG_TRINITYCORE}
    fi
fi

##Directorio de compilacion
crear_directorio(${DIR_BUILD})
cd ${DIR_BUILD}

##Compilar
cmake ../ -DCMAKE_INSTALL_PREFIX=${DIR_SERVER} -DTOOLS=0
make -j $(nproc) install


##Depurar borrar archivos del proceso de compilacion
rm -r ${DIR_BUILD}
