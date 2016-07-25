FROM pudo/aleph

ENV ELASTICSEARCH_INDEX aleph

WORKDIR /aleph

RUN pip install newrelic==2.46.0.37

RUN mkdir /app
COPY CHECKS /app/CHECKS
COPY Procfile /app/Procfile

ENV ALEPH_SETTINGS /aleph/contrib/docker_settings.py
