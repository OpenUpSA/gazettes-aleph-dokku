FROM pudo/aleph:latest

ENV ELASTICSEARCH_INDEX aleph
ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py

RUN pip install newrelic==2.46.0.37

RUN mkdir /app

WORKDIR /aleph

CMD newrelic-admin run-program gunicorn -w 5 -b 0.0.0.0:5000 --log-level info --log-file - aleph.manage:app
