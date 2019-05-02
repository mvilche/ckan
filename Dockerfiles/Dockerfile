FROM alpine:3.9
ENV PYTHON_VERSION=python2 CKAN_VERSION=ckan-2.8.2 CKAN_REPO=git+https://github.com/ckan/ckan.git@$CKAN_VERSION#egg=ckan
RUN apk add --no-cache --update $PYTHON_VERSION postgresql libmagic musl-dev py2-psycopg2 shadow su-exec tzdata postgresql-dev py2-pip git gcc libxml2 libxml2-dev python2-dev tiff-dev && \
pip install --upgrade pip && pip install setuptools==36.1 && cd /tmp && pip install -e $CKAN_REPO && pip uninstall python-magic && pip install python-magic && cd /tmp/src/ckan && pip install -r requirements.txt && \
addgroup -S ckan && adduser -h /opt/app -S -G ckan ckan && \
rm -rf /tmp/src/ckan /var/cache/apk/*
WORKDIR /opt/app
EXPOSE 5000
COPY run.sh /usr/bin/run.sh
ENTRYPOINT ["/usr/bin/run.sh"]
CMD ["/opt/app/ckan/config/production.ini"]
