#/bin/bash

if [ -f "./logs/nginx.pid" ]; then
    echo "stop nginx.."
    nginx -p ./ -c conf/nginx.conf -s stop
fi

echo "start nginx..."
nginx -p ./ -c conf/nginx.conf
