=============================
cnBetter - Better cnBeta Feed
=============================

Install
-------

::

  $ bundle
  $ export PADRINO_ENV=production
  $ padrino rake -e production dm:create
  $ padrino rake -e production dm:auto:migrate
  $ whenever -w
  $ padrino start -h 0.0.0.0 -d -e production

