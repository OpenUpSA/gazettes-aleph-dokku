FROM pudo/aleph

ENV ELASTICSEARCH_INDEX aleph

WORKDIR /aleph

RUN mkdir /app
COPY CHECKS /app/CHECKS

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py

CMD gunicorn -w 5 -b 0.0.0.0:5000 --log-level debug --log-file - aleph.manage:app
