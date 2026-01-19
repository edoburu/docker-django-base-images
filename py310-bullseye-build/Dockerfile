FROM python:3.10-bullseye
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

# Make sure optimized libjpeg is used for smaller thumbnail images
# Based on https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html
# and https://github.com/danbooru/danbooru/blob/master/Dockerfile
ARG MOZJPEG_VERSION=4.1.5
RUN apt-get update \
 && apt-get install --yes cmake nasm libpng-dev zlib1g-dev libwebp-dev \
 && rm /usr/lib/x86_64-linux-gnu/pkgconfig/xcb.pc \
       /usr/lib/x86_64-linux-gnu/libxcb.* \
       /usr/lib/x86_64-linux-gnu/pkgconfig/libjpeg.pc \
       /usr/lib/x86_64-linux-gnu/libjpeg.* \
       /usr/include/xcb/*.h \
       /usr/include/jpegint.h \
 && mkdir /root/build \
 && curl -L -s https://github.com/mozilla/mozjpeg/archive/v$MOZJPEG_VERSION.tar.gz \
        | tar --directory=/root/build -zxf - \
 && cd /root/build/mozjpeg-$MOZJPEG_VERSION \
 && cmake -DCMAKE_INSTALL_PREFIX=/opt/mozjpeg -DENABLE_STATIC=0 -DWITH_ARITH_ENC=1 -DWITH_ARITH_DEC=1 . \
 && make -j install/strip \
 && rm -rf * /opt/mozjpeg/share /opt/mozjpeg/man \
 && /opt/mozjpeg/bin/cjpeg -version

ENV LIBDIR=/opt/mozjpeg/lib64 \
    LD_RUN_PATH=/opt/mozjpeg/lib64:/usr/lib/x86_64-linux-gnu

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Add caching layer for latest pillow
RUN pip install -U pip wheel \
 && pip install --no-binary=Pillow -C xcb=disable Pillow \
 && pip install uwsgi
