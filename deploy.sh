#!/bin/sh
# git ls-files .web | tar -czf - -T - | ssh ezup 'tar --no-same-permissions --strip-components=1 -C /var/www/html -xzvf -'
# --human-readable, -h
# --verbose, -v
find .web -type f -printf '%P\n' | rsync -hv --rsh=ssh --files-from=- .web ezup:/var/www/html/
