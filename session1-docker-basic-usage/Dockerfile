# Use the nginx:latest image from Dockerhub
FROM mynginxrepo:current

# Runs an apt-get update command to update packages
RUN apt-get update \
    && apt-get upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    unzip \
    jq \
    libpq-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev

# Copies nginx.conf from the local directory into /etc/nginx/conf.d/default.conf inside the container image
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copies index.html from the local directory into /www/data/index.html inside the container image
#COPY index.html /www/data/index.html

# Uncomment this when doing the layer-cache example
#COPY /layer-cache-example/cowbell.html /www/data/index.html

# Uncomment this when doing the entrypoint example
COPY index.html /www/data/index.html
COPY ./entrypoint-example/ /usr/bin/entrypoint/
RUN chmod +x /usr/bin/entrypoint/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]