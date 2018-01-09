FROM python:3.6-stretch
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off

# Make sure optimized libjpeg is used for smaller thumbnail images
# Based on https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html
ARG MOZJPEG_VERSION=3.2
RUN apt-get update && \
    apt-get install --yes nasm && \
    rm /usr/lib/x86_64-linux-gnu/pkgconfig/libjpeg.pc \
       /usr/lib/x86_64-linux-gnu/libjpeg.* \
       /usr/include/jpegint.h && \
    mkdir /root/build && \
    curl -L -s https://github.com/mozilla/mozjpeg/archive/v$MOZJPEG_VERSION.tar.gz \
        | tar --directory=/root/build -zxf - && \
    cd /root/build/mozjpeg-$MOZJPEG_VERSION && \
    autoreconf -fiv && \
    #./configure --with-jpeg8 && \
    ./configure && \
    make && \
    make install

ENV LIBDIR=/opt/mozjpeg/lib64 \
    LD_RUN_PATH=/opt/mozjpeg/lib64:/usr/lib/x86_64-linux-gnu

# Add caching layer for latest pillow
RUN pip install --no-binary=Pillow Pillow==5.0.0
