FROM edoburu/django-base-images:py36-stretch-build AS build-image

FROM python:3.6-slim-stretch
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

# Install runtime dependencies.
# - gettext for `manage.py compilemessages` (run here to avoid busting build-container cache layers)
# - postgresql-client for `manage.py dbshell`
# - mime-support for `uwsgi --http`
# - libxml for lxml
# - libpng and jpeg2000 support for Pillow
# - skipped libjpeg62-turbo, as mozjpeg is used instead.
RUN apt-get update && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apt-get install --no-install-recommends -y \
        libxml2 \
        libpng16-16 \
        libopenjp2-7 \
        gettext \
        mime-support \
        postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old && \
    echo "font/woff2  woff2" >> /etc/mime.types && \
    useradd --system --user-group app

COPY --from=build-image /opt/mozjpeg /opt/mozjpeg
