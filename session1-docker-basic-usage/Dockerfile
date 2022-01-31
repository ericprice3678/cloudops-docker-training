# Use the nginx:latest image from Dockerhub
FROM nginx:latest

# Runs an apt-get update command to update packages
RUN apt-get update

# Copies nginx.conf from the local directory into /etc/nginx/conf.d/default.conf inside the container image
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copies index.html from the local directory into /www/data/index.html inside the container image
COPY index.html /www/data/index.html

# Uncomment this when doing the layer-cache example
#COPY /layer-cache-example/cowbell.html /www/data/index.html

# Uncomment this when doing the entrypoint example
# COPY ./entrypoint-example/ /usr/bin/entryoint/
# RUN chmod +x /usr/bin/entryoint/entrypoint.sh
# ENTRYPOINT ["/usr/bin/entryoint/entrypoint.sh"]


CMD ["nginx", "-g", "daemon off;"]