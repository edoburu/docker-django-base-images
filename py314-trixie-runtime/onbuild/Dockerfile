# Start runtime container
# Default DATABASE_URL is useful for local testing, and avoids connect timeouts for `manage.py`.
FROM edoburu/django-base-images:py314-trixie-runtime
ENV GRANIAN_BACKPRESSURE=10 \
    GRANIAN_WORKERS=1 \
    DATABASE_URL=sqlite:////tmp/demo.db

# System config (done early, avoid running on every code change)
EXPOSE 8080 1717
WORKDIR /app/src
ONBUILD VOLUME /app/web/media

RUN mkdir -p /app/web/media /app/web/static/CACHE \
 && chown -R app:app /app/web/media/ /app/web/static/CACHE \
 && chmod -R go+rw /app/web/media/ /app/web/static/CACHE

# Install dependencies
COPY manage.py /usr/local/bin/
COPY django-init /django-init
ENTRYPOINT ["/django-init"]
ONBUILD COPY --from=build-image /usr/local/bin/ /usr/local/bin/
ONBUILD COPY --from=build-image /usr/local/lib/python3.14/site-packages/ /usr/local/lib/python3.12/site-packages/

ONBUILD COPY web /app/web
ONBUILD COPY src /app/src

ONBUILD RUN rm /app/src/*/settings/local.py* \
 && find . -name '*.pyc' -delete \
 && python -mcompileall -q */
