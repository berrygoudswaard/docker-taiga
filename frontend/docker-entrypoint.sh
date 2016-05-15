#!/bin/bash
set -e

function config {
    API_HOST=${API_HOST:-localhost}
    sed -i -- s/localhost:8000/${API_HOST}/g /home/taiga/taiga-front-dist/dist/conf.json
}

if [ "$1" = 'nginx' ]; then
    config
    nginx -g "daemon off;"
    exit;
fi

exec "$@"
