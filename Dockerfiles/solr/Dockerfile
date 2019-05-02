FROM solr:6.6.5-alpine
USER root
RUN apk add --no-cache --update tzdata su-exec shadow && mkdir -p /opt/solr/server/solr/ckan/conf /opt/solr/server/solr/ckan/data
COPY solrconfig.xml \
schema.xml \
elevate.xml \
protwords.txt \
stopwords.txt \
synonyms.txt \
core.properties \
/opt/configuraciones/
COPY run.sh /usr/bin/run.sh
ENTRYPOINT ["/usr/bin/run.sh"]
VOLUME ["/opt/solr/server/solr/ckan"]
CMD ["solr-foreground"]
