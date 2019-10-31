#!/bin/bash

# start SSH

/usr/sbin/sshd

# start php process in background

/usr/sbin/php-fpm -c /etc/php/fpm

# start nginx daemon

nginx -g 'daemon off;'
