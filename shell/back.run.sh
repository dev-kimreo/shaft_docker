#!/bin/bash

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &

cd /home/shaft/shaft-be
cp .env.development .env
composer install

php artisan passport:keys
php artisan storage:link

#php artisan migrate:refresh --seed
#php artisan db:seed --class=UserAndManagerSeeder

nginx -g "daemon off;"