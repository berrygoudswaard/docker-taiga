#!/bin/bash
set -e

function config {
    DEBUG=${DEBUG:-False}
    MEDIA_ROOT=${MEDIA_ROOT:-/home/taiga/media}
    STATIC_ROOT=${STATIC_ROOT:-/home/taiga/static}
    TEMPLATE_DEBUG=${TEMPLATE_DEBUG:-False}
    PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-False}
    HOSTNAME=${HOSTNAME:-localhost}
    SECRET_KEY=${SECRET_KEY:-theveryultratopsecretkey}
    DEFAULT_FROM_EMAIL=${DEFAULT_FROM_EMAIL:-no-reply@example.com}
    SERVER_EMAIL=${SERVER_EMAIL:-no-reply@example.com}
    DB_NAME=${DB_NAME:-taiga}
    DB_USER=${DB_USER:-taiga}
    DB_PASS=${DB_PASS:-changeme}
    DB_HOST=${DB_HOST}

    echo "from .development import *

DEBUG = ${DEBUG}
TEMPLATE_DEBUG = ${TEMPLATE_DEBUG}
PUBLIC_REGISTER_ENABLED = ${PUBLIC_REGISTER_ENABLED}
SECRET_KEY = '${SECRET_KEY}'

MEDIA_ROOT = '${MEDIA_ROOT}'
STATIC_ROOT = '${STATIC_ROOT}'

MEDIA_URL = 'http://${HOSTNAME}/media/'
STATIC_URL = 'http://${HOSTNAME}/static/'
ADMIN_MEDIA_PREFIX = 'http://${HOSTNAME}/static/admin/'
SITES['front']['scheme'] = 'http'
SITES['front']['domain'] = '${HOSTNAME}'

DEFAULT_FROM_EMAIL = '${DEFAULT_FROM_EMAIL}'
SERVER_EMAIL = '{SERVER_EMAIL}'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '${DB_NAME}',
        'USER': '${DB_USER}',
        'PASSWORD': '${DB_PASS}',
        'HOST': '${DB_HOST}',
        'PORT': '',
    }
}
" > settings/local.py
}

if [ "$1" = 'taiga' ]; then
    config
    sudo python manage.py collectstatic --noinput
    sudo python manage.py migrate --noinput
    python manage.py runserver 0.0.0.0:8000
    exit
fi

exec "$@"
