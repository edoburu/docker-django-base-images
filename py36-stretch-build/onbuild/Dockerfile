# Build environment has gcc and develop header files.
# The installed files are copied to the smaller runtime container.
FROM edoburu/django-base-images:py36-stretch-build

# Install (and compile) all dependencies
ONBUILD RUN mkdir -p /app/src/requirements
ONBUILD COPY src/requirements/*.txt /app/src/requirements/
ONBUILD ARG PIP_REQUIREMENTS=/app/src/requirements/docker.txt

ONBUILD RUN pip install --no-binary=Pillow -r $PIP_REQUIREMENTS

# Remove unneeded locale files
ONBUILD RUN find /usr/local/lib/python3.6/site-packages/ -name '*.po' -delete
#    find /usr/local/lib/python3.6/site-packages/babel/locale-data/ -not -name 'en*' -not -name 'nl*' -name '*.dat' -delete && \
#    find /usr/local/lib/python3.6/site-packages/tinymce/ -regextype posix-egrep -not -regex '.*/langs/(en|nl).*\.js' -wholename '*/langs/*.js' -delete
