FROM pudo/aleph:latest

ENV ELASTICSEARCH_INDEX aleph
ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py

RUN pip install newrelic==2.46.0.37

RUN mkdir /app

COPY CHECKS /app/CHECKS
COPY Procfile /app/Procfile

WORKDIR /aleph
