FROM pudo/aleph:latest

ENV ELASTICSEARCH_INDEX aleph
ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
ENV ZA_GAZETTE_ARCHIVE_URI: http://s3-eu-west-1.amazonaws.com/code4sa-gazettes/archive/

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN mkdir /app

WORKDIR /aleph

CMD newrelic-admin run-program gunicorn -w 5 -b 0.0.0.0:5000 --log-level info --log-file - aleph.manage:app
