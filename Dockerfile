FROM pudo/aleph:latest

ENV ELASTICSEARCH_INDEX aleph
ENV ALEPH_SETTINGS /aleph/code4sa_aleph_config.py
ENV ZA_GAZETTE_ARCHIVE_URI: http://s3-eu-west-1.amazonaws.com/code4sa-gazettes/archive/

COPY code4sa_aleph_config.py /aleph/code4sa_aleph_config.py
COPY css /aleph/code4sa_css
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN mkdir /app
COPY CHECKS /app/CHECKS

WORKDIR /aleph

CMD newrelic-admin run-program gunicorn -w 5 -b 0.0.0.0:5000 --log-level info --log-file - aleph.manage:app
