#!/bin/sh
git ls-files .web | tar -czf - -T - | ssh ezup 'tar --no-same-permissions --strip-components=1 -C /var/www/html -xzvf -'
