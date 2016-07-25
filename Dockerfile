FROM pudo/aleph

ENV ELASTICSEARCH_INDEX aleph

RUN mkdir /app

RUN pip install newrelic==2.46.0.37

COPY CHECKS /aleph/CHECKS
COPY Procfile /app/Procfile

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
