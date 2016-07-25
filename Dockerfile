FROM pudo/aleph

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_INDEX aleph

WORKDIR /aleph

COPY CHECKS /aleph/CHECKS
COPY Procfile /aleph/Procfile

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
