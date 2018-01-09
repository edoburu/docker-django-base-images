Base docker images for Django
=============================

These Docker images build base images for running Django projects.

Available tags
--------------

Base images:

- `py36-stretch-build` ([Dockerfile](https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-build/Dockerfile)) - Build-time container with [mozjpeg](https://github.com/mozilla/mozjpeg) included, and [Pillow](https://python-pillow.org/) 5.0 linked to mozjpeg.
- `py36-stretch-runtime` ([Dockerfile](https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-runtime/Dockerfile)) - Run-time container with [mozjpeg](https://github.com/mozilla/mozjpeg) included, and default run-time libraries.

Onbuild images:

- `py36-stretch-build-onbuild` ([Dockerfile](https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-build/onbuild/Dockerfile)) - Pre-scripted build container that assumes `src/requirements/docker.txt` is available. Supports `PIP_REQUIREMENTS` build arg.
- `py36-stretch-runtime-onbuild` ([Dockerfile](https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-runtime/onbuild/Dockerfile)) - Pre-scripted runtime container that assumes `src/`, `web/media` and `web/static` are available. Supports `GIT_VERSION` build arg.


Onbuild Usage
-------------

The "onbuild" images contain pre-scripted and opinionated assumptions over the application layout.
Using these images result in a small ``Dockerfile``:

```dockerfile
FROM edoburu/django-base-images:py36-stretch-build-onbuild AS build-image

# Remove more unneeded files
RUN find /usr/local/lib/python3.6/site-packages/babel/locale-data/ -not -name 'en*' -not -name 'nl*' -name '*.dat' -delete && \
    find /usr/local/lib/python3.6/site-packages/tinymce/ -regextype posix-egrep -not -regex '.*/langs/(en|nl).*\.js' -wholename '*/langs/*.js' -delete

# Start runtime container
FROM edoburu/django-base-images:py36-stretch-runtime-onbuild
ENV DJANGO_SETTINGS_MODULE=mysite.settings.docker \
    UWSGI_MODULE=mysite.wsgi.docker:application

# Collect static files as root, with gzipped files for uwsgi to serve
RUN manage.py compilemessages && \
    manage.py collectstatic --settings=$DJANGO_SETTINGS_MODULE --noinput && \
    gzip --keep --best --force --recursive /app/web/static/

# Reduce default permissions
USER app
```


Base image usage
----------------

The base images only contain what is absolutely needed. When using these images, your custom `Dockerfile` can break with all assumptions that the onbuild images make. This example is equivalent to the onbuild example above:

```dockerfile
# Build environment has gcc and develop header files.
# The installed files are copied to the smaller runtime container.
FROM edoburu/django-base-images:py36-stretch-build AS build-image

# Install (and compile) all dependencies
RUN mkdir -p /app/src/requirements
COPY src/requirements/*.txt /app/src/requirements/
ARG PIP_REQUIREMENTS=/app/src/requirements/docker.txt
RUN pip install --no-binary=Pillow -r $PIP_REQUIREMENTS

# Remove unneeded files
RUN find /usr/local/lib/python3.6/site-packages/ -name '*.po' -delete && \
    find /usr/local/lib/python3.6/site-packages/babel/locale-data/ -not -name 'en*' -not -name 'nl*' -name '*.dat' -delete && \
    find /usr/local/lib/python3.6/site-packages/tinymce/ -regextype posix-egrep -not -regex '.*/langs/(en|nl).*\.js' -wholename '*/langs/*.js' -delete

# Start runtime container
# Default DATABASE_URL is useful for local testing, and avoids connect timeouts for `manage.py`.
FROM edoburu/django-base-images:py36-stretch-runtime
ENV UWSGI_PROCESSES=1 \
    UWSGI_THREADS=20 \
    UWSGI_OFFLOAD_THREADS=20 \
    UWSGI_MODULE=mysite.wsgi.docker:application \
    DJANGO_SETTINGS_MODULE=mysite.settings.docker \
    DATABASE_URL=sqlite:////tmp/demo.db

# System config (done early, avoid running on every code change)
EXPOSE 8080 1717
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:8080/api/healthcheck/ || exit 1
CMD ["/usr/local/bin/uwsgi", "--ini", "/usr/local/etc/uwsgi.ini"]
WORKDIR /app/src
VOLUME /app/web/media

# Install dependencies
COPY deployment/docker/manage.py /usr/local/bin/
COPY deployment/docker/uwsgi.ini /usr/local/etc/uwsgi.ini
COPY --from=build-image /usr/local/bin/ /usr/local/bin/
COPY --from=build-image /usr/local/lib/python3.6/site-packages/ /usr/local/lib/python3.6/site-packages/

# Insert application code.
# - Set a default database URL for accidental DB requests
# - Prepare gzipped versions of static files for uWSGI to use
# - Create a default database inside the container (as demo),
#   when caller doesn't define DATABASE_URL
# - Give full permissions, so Kubernetes can run the image as different user
COPY web /app/web
COPY src /app/src
RUN rm /app/src/*/settings/local.py* && \
    find . -name '*.pyc' -delete && \
    python -mcompileall -q */ && \
    manage.py compilemessages && \
    manage.py collectstatic --noinput && \
    gzip --keep --best --force --recursive /app/web/static/ && \
    chown -R app:app /app/web/media/ /app/web/static/CACHE && \
    chmod -R go+rw /app/web/media/ /app/web/static/CACHE

# Tag the docker image
ARG GIT_VERSION
LABEL git-version=$GIT_VERSION
RUN echo $GIT_VERSION > .docker-git-version

# Reduce default permissions
USER app
```
