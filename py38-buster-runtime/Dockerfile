FROM edoburu/django-base-images:py38-buster-build AS build-image

FROM python:3.8-slim-buster
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

# Install runtime dependencies.
# - curl for healthchecks
# - gettext for `manage.py compilemessages` (run here to avoid busting build-container cache layers)
# - postgresql-client for `manage.py dbshell`
# - mime-support for `uwsgi --http`
# - libxml for lxml
# - libpng, freetype, libtiff and jpeg2000 support for Pillow
# - skipped libjpeg62-turbo, as mozjpeg is used instead.
# Performing dist-upgrade in case base image is outdated.
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apt-get install --no-install-recommends -y \
        libxml2 \
        libpng16-16 \
        libopenjp2-7 \
        libfreetype6 \
        libtiff5 \
        libwebp6 \
        libwebpmux3 \
        curl \
        gettext \
        mime-support \
        postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old && \
    echo "font/woff2  woff2" >> /etc/mime.types && \
    useradd --system --user-group app

COPY --from=build-image /opt/mozjpeg /opt/mozjpeg
