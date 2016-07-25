FROM pudo/aleph

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_INDEX aleph

WORKDIR /aleph

RUN mkdir /app
COPY CHECKS /app/CHECKS
COPY Procfile /app/Procfile

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
