#!/bin/bash

id_server=-1

api_app="${DIR_PANEL}'/api/application/servers'"
api_arg="-H 'Accept: application/json' -H 'Content-Type: application/json' -H 'Authorization: Bearer' ${API_KEY}"

#Regresa json con las bases de datos asosiadas al servidor
get_list_db(){
    return "curl "$api_app/$id_server/databases?include=password,host" $api_arg -X GET "
}
search_db(){
    local aux_json=$2
    if [ $(echo "$aux_json" | jq 'keys_unsorted' | jq '.[0]') == "errors" ];
    then
        echo $aux_json
        exit(1)
    else
        return "$(echo "$2" | jq '.data' | jq '.[] | select(.attributes.database=='"$1"')')"
    if
}
#Crea base de datos y la asocia a un servidor
#Argumentos, 
#   -Nombre parcial para la base de datos al nombre enviado a la funcion se le agregara el ID del servidor donde sera asignado
#   -Remote, argumentos de conexion por defecto %, si no conoces los parametros dejarlo por defecto
crear_base(){
    local aux_db=$(search_db "'s'$id_server'_'$1" $(get_list_db) )
    if [ $aux_db == "" ];
    then
        local new_base="curl "$api_app'/'$id_server'/databases?include=password,host'" $api_arg -X POST \
                        -d '{ 
                            "database":' "$1"',
                            "remote": '"$2"',
                            "host": '"${ID_DB_HOST}"'
                        }'"
        if [ $(echo "$new_base" | jq 'keys_unsorted' | jq '.[0]') == "errors" ];
        then
            echo $new_base
            exit(1)
        else
            return $new_base
        fi
    else
        return $aux_db
    fi
}

get_string_db(){
    return $(echo $1 | jq '(.attributes.relationships.host.attributes.host + ";" \
                        + (.attributes.relationships.host.attributes.port | tostring) + ";" \
                        + .attributes.username + ";" \
                        + .attributes.relationships.password.attributes.password + ";" \
                        + .attributes.database)')
}

js_server="curl $api_app $api_arg -X GET | jq '.data' | jq '.[] | select(.attributes.uuid=='"${P_SERVER_UUID}"')'"
id_server="echo $js_server | jq '.attributes.id' "

js_db_auth=$(crear_base 'auth')
js_db_world=$(crear_base 'world')
js_db_characters=$(crear_base 'characters')
if ["${TAG_TRINITYCORE}" == "master"];
then
    js_db_hotfixes=$(crear_base 'hotfixes')
fi

cd ${DIR_CONF}
buscar='"127.0.0.1;3306;trinity;trinity;' 

sed -i '/LoginDatabaseInfo     =/s/' $buscar ';auth/' '"' $(get_string_db $js_db_auth) '"/g' worldserver.conf
if ["${TAG_TRINITYCORE}" == "master"];
then
    sed -i '/LoginDatabaseInfo     =/s/' $buscar ';auth/' '"' $(get_string_db $js_db_auth) '"/g' bnetserver.conf
    sed -i '/HotfixDatabaseInfo    =/s/' $buscar ';hotfixes/' '"' $(get_string_db $js_db_hotfixes) '"/g' worldserver.conf
else
    sed -i '/LoginDatabaseInfo     =/s/' $buscar ';auth/' '"' $(get_string_db $js_db_auth) '"/g' authserver.conf
fi
sed -i '/WorldDatabaseInfo     =/s/' $buscar ';world/' '"' $(get_string_db $js_db_world) '"/g' worldserver.conf
sed -i '/CharacterDatabaseInfo     =/s/' $buscar ';caracteres/' '"' $(get_string_db $js_db_characters) '"/g' worldserver.conf



