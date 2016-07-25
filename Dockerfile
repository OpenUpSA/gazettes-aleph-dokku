FROM pudo/aleph

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_INDEX aleph

COPY CHECKS /aleph
COPY Procfile /aleph

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
