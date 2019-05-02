#!/bin/sh

    if [ -z $USER_ID ]; then
    echo "***************************************************"
    echo "NO SE ENCUENTRA LA VARIABLE USER_ID - INICIANDO POR DEFECTO"
    echo "*******************************************************"    
    USER_ID=1000
    echo "USER_ID: 1000"
    else
    echo "***************************************************"
    echo "VARIABLE USER_ID ENCONTRADA SETEANADO VALORES: $USER_ID"
    usermod -u $USER_ID solr
    echo "*******************************************************"
    fi
   

     if [ -z $GROUP_ID ]; then
    echo "***************************************************"
    echo "NO SE ENCUENTRA LA VARIABLE GROUP_ID - INICIANDO POR DEFECTO"
    echo "******************************************************"
    GROUP_ID=1000
    echo "GROUP_ID: 1000"
    else
    echo "***************************************************"
    echo "VARIABLE GROUP_ID ENCONTRADA SETEANADO VALORES: $GROUP_ID"
    groupmod -g $GROUP_ID solr
    echo "*******************************************************"
    fi



if [ -z "$TIMEZONE" ]; then
echo "···································································································"
echo "VARIABLE TIMEZONE NO SETEADA - INICIANDO CON VALORES POR DEFECTO"
echo "POSIBLES VALORES: America/Montevideo | America/El_Salvador"
echo "···································································································"
else
echo "···································································································"
echo "TIMEZONE SETEADO ENCONTRADO: " $TIMEZONE
echo "···································································································"
echo "SETENADO TIMEZONE"
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime && \
echo $TIMEZONE > /etc/timezone
fi


if [ -d /opt/solr/server/solr/ckan/.init ]; then
	echo "**********************************************"
    echo "SOLR YA FUE INICIALIZADO - SE ENCONTRARON DATOS"
    echo "**********************************************"
else

    echo "***************************************************"
    echo "SOLR NO SE HA INICIALIZADO"
    echo "INICIALIZANDO..."
    echo "*******************************************************"
    mkdir -p /opt/solr/server/solr/ckan/ &> /dev/null ;\
    mkdir -p /opt/solr/server/solr/ckan/data &> /dev/null ;\
    mkdir -p /opt/solr/server/solr/ckan/conf &> /dev/null ;\
    mkdir -p /opt/solr/server/solr/ckan/.init && \
    cp -rf /opt/configuraciones/* /opt/solr/server/solr/ckan/ && \
    cp /opt/solr/server/solr/ckan/schema.xml /opt/solr/server/solr/ckan/conf/ && \
    chown solr:solr -R /opt/solr && rm -rf /opt/configuraciones && \
    echo "TAREAS COMPLETADAS CORRECTAMENTE."
fi

chown solr:solr -R /opt/solr && echo "FIX PERMISSION OK"
echo "INICIANDO SOLR...."
exec su-exec solr "$@"
