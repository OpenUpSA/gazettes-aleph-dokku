FROM pudo/aleph@sha256:b314372071e8cb86d1fab6fa9bc480b48b5b01afa67cc63c50e80466863921ae

ENV ELASTICSEARCH_INDEX aleph
ENV ALEPH_SETTINGS /aleph/code4sa_aleph_config.py
ENV ZA_GAZETTE_ARCHIVE_URI: http://s3-eu-west-1.amazonaws.com/code4sa-gazettes/archive/

COPY code4sa_aleph_config.py /aleph/code4sa_aleph_config.py
COPY css /aleph/code4sa_css
COPY templates /aleph/code4sa_templates
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN mkdir /app
COPY CHECKS /app/CHECKS

WORKDIR /aleph

CMD newrelic-admin run-program gunicorn --workers 1 -b 0.0.0.0:8000 --worker-class gevent --timeout 600 --max-requests 3000 --max-requests-jitter 100 --log-file - --access-logfile - aleph.manage:app
