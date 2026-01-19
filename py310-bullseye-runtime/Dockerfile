FROM edoburu/django-base-images:py310-bullseye-build AS build-image

FROM python:3.10-slim-bullseye
# Make sure `pip` doesn't cache, and `uv` installs into the system dir
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    UV_PYTHON=python3.12 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PROJECT_ENVIRONMENT=/usr/local/ \
    UV_COMPILE_BYTECODE=1 \
    UV_LOCKED=1 \
    UV_NO_BINARY_PACKAGE=Pillow \
    UV_NO_CACHE=1 \
    UV_NO_DEV=1 \
    UV_NO_EDITABLE=1 \
    UV_NO_MANAGED_PYTHON=1

# Install runtime dependencies.
# - curl for healthchecks
# - gettext for `manage.py compilemessages` (run here to avoid busting build-container cache layers)
# - postgresql-client for `manage.py dbshell`
# - mime-support for `uwsgi --http`
# - libxml for lxml
# - libpng, freetype, libtiff and jpeg2000 support for Pillow
# - skipped libjpeg62-turbo, as mozjpeg is used instead.
# Performing dist-upgrade in case base image is outdated.
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && mkdir -p /usr/share/man/man1 /usr/share/man/man7 \
 && apt-get install --no-install-recommends -y \
        libxml2 \
        libpng16-16 \
        libopenjp2-7 \
        libfreetype6 \
        libtiff5 \
        libwebp6 \
        libwebpmux3 \
        libwebpdemux2 \
        curl \
        gettext \
        mime-support \
        postgresql-client \
 && rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old \
 && echo "font/woff2    woff2" >> /etc/mime.types \
 && echo "image/webp    webp"  >> /etc/mime.types \
 && useradd --system --user-group app

COPY --from=build-image /opt/mozjpeg /opt/mozjpeg
