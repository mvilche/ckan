#!/bin/sh

CKAN_ROOT=/opt/app/ckan
CKAN_DATADIR=/opt/app/ckan/.init
CKAN_VERSION=ckan-2.8.2
CKAN_REPO=https://github.com/ckan/ckan.git

    if [ -z $USER_ID ]; then
    echo "***************************************************"
    echo "NO SE ENCUENTRA LA VARIABLE USER_ID - INICIANDO POR DEFECTO"
    echo "*******************************************************"    
    USER_ID=1000
    echo "USER_ID: 1000"
    else
    echo "***************************************************"
    echo "VARIABLE USER_ID ENCONTRADA SETEANADO VALORES: $USER_ID"
    usermod -u $USER_ID ckan
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
    groupmod -g $GROUP_ID ckan
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



    if [ -z $POSTGRES_HOST ] || [ -z $POSTGRES_USER ] || [ -z $POSTGRES_PASSWORD ] || [ -z $POSTGRES_PORT ] || [ -z $CKAN_URL ] || [ -z $REDIS_HOST ] || [ -z $REDIS_PORT ] || [ -z $REDIS_DATABASE ]; then
    echo "***************************************************"
    echo "SE DETECTARON VARIABLES REQUERIDAS NO SETEADAS, VERIFICAR POSTGRES_USER, POSTGRES_ PASSWORD, POSTGRES_HOST, POSTGRES_PORT, CKAN_URL, REDIS_HOST, REDIS_DATABASE, REDIS_PORT"
    echo "*******************************************************"
    exit 1
    fi


if [ -d $CKAN_DATADIR ]; then
	echo "**********************************************"
    echo "CKAN YA FUE INICIALIZADO - SE ENCONTRARON DATOS"
    echo "**********************************************"
else

    echo "***************************************************"
    echo "CKAN NO SE HA INICIALIZADO"
    echo "EL TIEMPO DE LA DESCARGA E INSTALACION DE LAS DEPENDENCIAS SERA DE UNOS MINUTOS" 
    echo "INICIALIZANDO..."
    echo "*******************************************************"
    cd /opt/app && git clone --depth=1 -b $CKAN_VERSION $CKAN_REPO &> /dev/null  && cd /opt/app/ckan && pip install -e . && \
    cd /opt/app/ckan && pip install -r requirements.txt  && mkdir /opt/app/ckan/.init /opt/app/ckan/config &&  \
    paster make-config ckan /opt/app/ckan/config/production.ini && \
    sed -i "/sqlalchemy.url/c\sqlalchemy.url = postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST/\ckan" /opt/app/ckan/config/production.ini && \
    sed -i "/ckan.site_url/c\ckan.site_url=$CKAN_URL" /opt/app/ckan/config/production.ini && \
    sed -i "/ckan.storage_path/c\ckan.storage_path=/opt/app/ckan/data" /opt/app/ckan/config/production.ini && \
    sed -i "/ckan.redis.url/c\ckan.redis.url=redis://$REDIS_HOST:$REDIS_PORT/$REDIS_DATABASE" /opt/app/ckan/config/production.ini && \ 
    sed -i "/solr_url/c\solr_url=http://$SOLR_HOST:$SOLR_PORT/solr" /opt/app/ckan/config/production.ini && \
    cp /opt/app/ckan/who.ini /opt/app/ckan/config/ && \
    echo "INICIALIZANDO BASE DE DATOS..." && \
    paster db init -c /opt/app/ckan/config/production.ini && \
    echo "FIX PERMISOS.." && chown $USER_ID:$USER_ID -R /opt/app/ckan && cd /opt/app
    echo "*******************************************************" && \
	echo "CKAN $ODOO_VERSION INICIALIZADO CORRECTAMENTE" && \
    echo "*******************************************************"
	echo "TAREAS COMPLETADAS CORRECTAMENTE." && \
    echo "*******************************************************"
fi



if [ $CHECK_REQUIREMENTS == true  ]; then
    echo "**********************************************"
    echo "CHECK_REQUIREMENTS ACTIVADO - INSTALANDO DEPENDENCIAS"
    cd /opt/app/odoo && pip3 install -r requirements.txt
    echo "**********************************************"
fi


if [ $PULL_NEW_CHANGES == true  ]; then
    echo "**********************************************"
    echo "PULL_NEW_CHANGES ACTIVADO - HACIENDO PULL A " $ODOO_REPO
    cd /opt/app/odoo && git pull origin $ODOO_VERSION && cd - > /dev/null && \
    echo "PULL REALIZADO CORRECTO!"
    echo "**********************************************"
fi



chown ckan:ckan -R /opt/app/ckan && echo "FIX PERMISSION OK"
echo "INICIANDO CKAN...."
sleep 2s
cd /opt/app/ckan && exec su-exec ckan paster serve "$@"
