# Aleph in Dokku

This is one of three primary mechanisms for Code for SA to run Aleph inside Dokku. There are three aspects:

1. aleph-dokku - web interface
2. [aleph-dokku-worker](https://github.com/Code4SA/aleph-dokku-worker) - runs background tasks
3. [aleph-dokku-beat](https://github.com/Code4SA/aleph-dokku-beat) - scheludes background tasks using Celery Beat

This repo uses Dokku's Dockerfile support to build an image based on our [customised version of Aleph](https://github.com/Code4SA/aleph) which
is built using [Docker Hub](hub.docker.com/r/code4sa/aleph/).

Here's a spiffy diagram:

               +-------------+   +-------------+
               | Dockerfile  |   | aleph repo  |
               | aleph-base  |   |             |
               +------+------+   +------+------+                 upstream
                      |                 |            --------------------
                      |                 |                         code4sa
                      |          +------+------+
                      |          | aleph repo  |
                      |   +------+             |
                      |   |      +-------------+
               +------+---|--+
               | Dockerfile  +--------------------------------+
           +---+ aleph       +---------+                      |
           |   +-------------+         |                      |
           |                           |                      |
    +------+---------+  +--------------+--------------+  +----+----------------------+
    | Dokku          |  | Dokku                       |  | Dokku                     |
    | gazettes-aleph |  | gazettes-aleph-dokku-worker |  | gazettes-aleph-dokku-beat |
    +----------------+  +-----------------------------+  +---------------------------+

## Development

Developing against the prod cluster isn't very practical because of the need to tunnel connections to ElasticSearch.

The aleph repo has an example docker-compose file which sets up all the dependencies to run a full cluster locally. It's super convenient. You can modify it (it even supports relative paths) to map the assets in this repo into the container for local development.

You can for example configure it like this from the aleph repo clone directory

Add this volume to the worker service
```
        - "./filestore:/aleph/filestore"
```

Modify the web service like this
```
  web:
      build: ../aleph-dokku
      ports:
        - "13376:8000"
      links:
        - postgres
        - elasticsearch
        - rabbitmq
      volumes:
        - "/:/host"
        - "./logs:/var/log"
        - "../aleph-dokku/code4sa_aleph_config.py:/aleph/code4sa_aleph_config.py"
        - "../aleph-dokku/css:/aleph/code4sa_css"
        - "../aleph-dokku/templates:/aleph/code4sa_templates"
        - "./filestore:/aleph/filestore"
      environment:
        ALEPH_ELASTICSEARCH_URI: http://elasticsearch:9200/
        ALEPH_DATABASE_URI: postgresql://aleph:aleph@postgres/aleph
        ALEPH_BROKER_URI: amqp://guest:guest@rabbitmq:5672
        ALEPH_SETTINGS: /aleph/code4sa_aleph_config.py
      env_file:
        - aleph.env
```

aleph.env
```
# Name needs to be a slug, as it is used e.g. for the ES index, SQS queue name:
ALEPH_APP_NAME=aleph
ALEPH_FAVICON=https://investigativedashboard.org/static/favicon.ico
ALEPH_APP_URL=http://localhost:13376
ALEPH_LOGO=http://assets.pudo.org/img/logo_bigger.png

# Random string:
ALEPH_SECRET_KEY=oru239cn293uner923unc130nc
ALEPH_URL_SCHEME=http

# Expects Google OAuth credentials to be set up:
# https://console.developers.google.com/apis/credentials?
# Source host would be http://localhost:13376
# and the redirect URL would be http://localhost:13376/api/1/sessions/callback

ALEPH_OAUTH_KEY=...
ALEPH_OAUTH_SECRET=...

# Where and how to store the underlying files:
ALEPH_ARCHIVE_TYPE=file
ALEPH_ARCHIVE_BUCKET=code4sa-aleph

# Or, if 'ALEPH_ARCHIVE_TYPE' configuration is 'file':
ALEPH_ARCHIVE_PATH=/aleph/filestore
```

## Deployment

```
dokku config:set gazettes-aleph \
    ALEPH_APP_TITLE="Aleph Code4SA" \
    ALEPH_APP_NAME=aleph \
    ALEPH_FAVICON=http://code4sa.org/favicon.ico \
    ALEPH_APP_URL=https://search.opengazettes.org.za \
    ALEPH_LOGO=http://code4sa.org/images/logo.png \
    ALEPH_SECRET_KEY=... \
    ALEPH_URL_SCHEME=https \
    ALEPH_OAUTH_KEY=... \
    ALEPH_OAUTH_SECRET=... \
    ALEPH_ARCHIVE_TYPE=s3 \
    ALEPH_ARCHIVE_BUCKET=code4sa-aleph \
    AWS_ACCESS_KEY_ID=... \
    AWS_SECRET_ACCESS_KEY=... \
    ALEPH_BROKER_URI=sqs://sqs.eu-west-1.amazonaws.com/.../
    ALEPH_DATABASE_URI=postgresql://aleph:aleph@postgres/aleph \
    ALEPH_ELASTICSEARCH_URI=http://elasticsearch:9200/
    C_FORCE_ROOT='true' \
    POLYGLOT_DATA_PATH=/opt/aleph/data \
    TESSDATA_PREFIX=/usr/share/tesseract-ocr \
    ALEPH_PDF_OCR_IMAGE_PAGES=false

dokku docker-options:add gazettes-aleph run,deploy  "-v /var/log/aleph:/var/log"
dokku docker-options:add gazettes-aleph run,deploy  "-v /var/lib/aleph:/opt/aleph/data"
```

Then push this repo to your dokku remote:

    git push dokku

**Note:** You MUST re-push this repo to ensure dokku picks up changes to the underlying code4sa/aleph docker image. Using ``dokku ps:rebuild aleph`` doesn't seem to pick up changes in the docker image.
