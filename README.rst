Base docker images for Django
=============================

These Docker images build base images for running Django projects.

Available tags
--------------

* ``py36-stretch-build``
  (`Dockerfile <https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-build/Dockerfile>`_) -
  Build-time container with mozjpeg_ included, and Pillow_ 5.0 linked to mozjpeg.
* ``py36-stretch-runtime``
  (`Dockerfile <https://github.com/edoburu/docker-django-base-image/blob/master/py36-stretch-runtime/Dockerfile>`_) -
  Run-time container with mozjpeg_ included, and default run-time libraries.



.. _mozjpeg: https://github.com/mozilla/mozjpeg
.. _Pillow: https://python-pillow.org/
