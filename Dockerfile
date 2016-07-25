FROM pudo/aleph
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /aleph
ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
