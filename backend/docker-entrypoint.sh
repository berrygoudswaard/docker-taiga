#!/bin/bash
set -e

function config {
    DEBUG=${DEBUG:-False}
    ADMIN_NAME=${ADMIN_NAME:-Admin}
    ADMIN_EMAIL=${ADMIN_EMAIL:-example@example.com}
    TEMPLATE_DEBUG=${TEMPLATE_DEBUG:-False}
    PUBLIC_REGISTER_ENABLED=${PUBLIC_REGISTER_ENABLED:-False}
    HOST_NAME=${HOST_NAME:-localhost}
    SECRET_KEY=${SECRET_KEY:-theveryultratopsecretkey}
    DEFAULT_FROM_EMAIL=${DEFAULT_FROM_EMAIL:-no-reply@example.com}
    SERVER_EMAIL=${SERVER_EMAIL:-no-reply@example.com}
    DB_NAME=${DB_NAME:-taiga}
    DB_USER=${DB_USER:-taiga}
    DB_PASS=${DB_PASS:-changeme}
    DB_HOST=${DB_HOST}

    echo "from .development import *

ADMINS = (
    ('${ADMIN_NAME}', '${ADMIN_EMAIL}'),
)

DEBUG = ${DEBUG}
TEMPLATE_DEBUG = ${TEMPLATE_DEBUG}
PUBLIC_REGISTER_ENABLED = ${PUBLIC_REGISTER_ENABLED}
SECRET_KEY = '${SECRET_KEY}'

MEDIA_ROOT = '/home/taiga/taiga-back/taiga/base/tic/media'
STATIC_ROOT = '/home/taiga/taiga-back/taiga/base/static'

MEDIA_URL = 'http://${HOST_NAME}/media/'
STATIC_URL = 'http://${HOST_NAME}/static/'
ADMIN_MEDIA_PREFIX = 'http://${HOST_NAME}/static/admin/'
SITES['front']['scheme'] = 'http'
SITES['front']['domain'] = '${HOST_NAME}'

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

if [ "$1" = 'init' ]; then
    config
    python manage.py migrate --noinput
    python manage.py loaddata initial_user
    python manage.py loaddata initial_project_templates
    python manage.py loaddata initial_role
    exit
fi

if [ "$1" = 'migrate' ]; then
    config
    python manage.py migrate --noinput
    exit
fi

if [ "$1" = 'taiga' ]; then
    config
    python manage.py runserver 0.0.0.0:8000
    exit
fi

exec "$@"


