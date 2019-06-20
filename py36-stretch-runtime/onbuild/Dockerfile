# Start runtime container
# Default DATABASE_URL is useful for local testing, and avoids connect timeouts for `manage.py`.
FROM edoburu/django-base-images:py36-stretch-runtime
ENV UWSGI_PROCESSES=1 \
    UWSGI_THREADS=10 \
    UWSGI_OFFLOAD_THREADS=%k \
    DATABASE_URL=sqlite:////tmp/demo.db

# System config (done early, avoid running on every code change)
EXPOSE 8080 1717
CMD ["/usr/local/bin/uwsgi", "--ini", "/usr/local/etc/uwsgi.ini"]
WORKDIR /app/src
ONBUILD VOLUME /app/web/media

RUN mkdir -p /app/web/media /app/web/static/CACHE && \
    chown -R app:app /app/web/media/ /app/web/static/CACHE && \
    chmod -R go+rw /app/web/media/ /app/web/static/CACHE && \
    echo -e "[uwsgi]\nfoo = 1" > /usr/local/etc/uwsgi-local.ini

# Install dependencies
COPY manage.py /usr/local/bin/
COPY uwsgi.ini /usr/local/etc/uwsgi.ini
COPY django-init /django-init
ENTRYPOINT ["/django-init"]
ONBUILD COPY --from=build-image /usr/local/bin/ /usr/local/bin/
ONBUILD COPY --from=build-image /usr/local/lib/python3.6/site-packages/ /usr/local/lib/python3.6/site-packages/

# Insert application code.
# - Set a default database URL for accidental DB requests
# - Prepare gzipped versions of static files for uWSGI to use
# - Create a default database inside the container (as demo),
#   when caller doesn't define DATABASE_URL
# - Give full permissions, so Kubernetes can run the image as different user
ONBUILD COPY web /app/web
ONBUILD COPY src /app/src

ONBUILD RUN rm /app/src/*/settings/local.py* && \
    find . -name '*.pyc' -delete && \
    python -mcompileall -q */
