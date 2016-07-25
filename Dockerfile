FROM pudo/aleph:bdg7cdbp8bwm8djkpbzbv5
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /aleph
ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py

CMD gunicorn -w 5 -b 0.0.0.0:5000 --log-level info --log-file /var/log/gunicorn.log aleph.manage:app
