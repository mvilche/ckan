FROM alpine:3.9
ENV PYTHON_VERSION=python2 CKAN_DATAPUSHER_VERSION=0.0.15 CKAN_DATAPUSHER_REPO=https://github.com/ckan/datapusher.git
RUN apk add --no-cache --update $PYTHON_VERSION openssl-dev shadow libxml2 libxml2-dev musl-dev libxslt-dev libffi-dev su-exec gcc tzdata py2-pip git python2-dev tiff-dev && \
pip install --upgrade pip && git clone -b $CKAN_DATAPUSHER_VERSION $CKAN_DATAPUSHER_REPO /opt/datapusher && cd /opt/datapusher && pip install -r requirements.txt && \
addgroup -S datapusher && adduser -h /opt/app -S -G datapusher datapusher && \
rm -rf /var/cache/apk/*
WORKDIR /opt/datapusher
EXPOSE 8800
CMD [ "python", "/opt/datapusher/datapusher/main.py", "/opt/datapusher/deployment/datapusher_settings.py"]
