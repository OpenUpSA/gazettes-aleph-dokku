FROM pudo/aleph

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_INDEX aleph

COPY CHECKS /
COPY Procfile /

WORKDIR /

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
