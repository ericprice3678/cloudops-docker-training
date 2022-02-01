#!/usr/bin/env bash

echo "Running entrypoint"

mv /usr/bin/entrypoint/youdidit.html /www/data/index.html

# This needs to be the last command. https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts#:~:text=exec%20%22%24%40%22%20is%20typically%20used,to%20the%20command%20line%20arguments.
exec "$@"