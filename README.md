# Aleph in Dokku

## Deployment

```
dokku config:set aleph \
    ALEPH_APP_TITLE="Aleph Code4SA" \
    ALEPH_APP_NAME=aleph \
    ALEPH_FAVICON=http://code4sa.org/favicon.ico \
    ALEPH_APP_URL=http://aleph.code4sa.org \
    ALEPH_LOGO=http://code4sa.org/images/logo.png \
    ALEPH_SECRET_KEY=... \
    ALEPH_URL_SCHEME=http \
    ALEPH_OAUTH_KEY=... \
    ALEPH_OAUTH_SECRET=... \
    ALEPH_ARCHIVE_TYPE=s3 \
    ALEPH_ARCHIVE_BUCKET=code4sa-aleph \
    AWS_ACCESS_KEY_ID=... \
    AWS_SECRET_ACCESS_KEY=... \
    ALEPH_BROKER_URI=sqs://sqs.eu-west-1.amazonaws.com/.../
    ALEPH_DATABASE_URI=postgresql://aleph:aleph@postgres/aleph \
    ALEPH_ELASTICSEARCH_URI=http://elasticsearch:9200/
    NEW_RELIC_APP_NAME="Aleph" \
    NEW_RELIC_LICENSE_KEY=... \
    C_FORCE_ROOT='true' \
    POLYGLOT_DATA_PATH=/opt/aleph/data \
    TESSDATA_PREFIX=/usr/share/tesseract-ocr \
    ALEPH_PDF_OCR_IMAGE_PAGES=false

```
```
dokku docker-options:add aleph run,deploy  "-v /var/log/aleph:/var/log"
dokku docker-options:add aleph run,deploy  "-v /var/lib/aleph:/opt/aleph/data"
```