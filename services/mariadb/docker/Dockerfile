ARG MARIADB_VERSION

FROM mariadb:${MARIADB_VERSION}

# Note, base image assumes that "mariadb" user have UID/GID=1001
ARG MARIADB_UNAME=mysql
ARG MARIADB_UID=1001
ARG MARIADB_GID=1001

ENV MARIADB_HOME /home/$MARIADB_UNAME

USER root

# Create iguazio user/group
RUN set -ex \
    && mkdir -p /home/$MARIADB_UNAME \
    && usermod \
      -u $MARIADB_UID \
      --shell /bin/bash $MARIADB_UNAME \
    && groupmod -g $MARIADB_GID $MARIADB_UNAME \
    && apt-get update -q \
    && apt-get install -yq --no-install-recommends curl \
    && mkdir -p /var/lib/mysql/mysql /docker-entrypoint-initdb.d \
    && chown -R $MARIADB_UID:$MARIADB_GID /home/$MARIADB_UNAME \
      /var/lib/mysql \
      /etc/mysql \
      /usr/lib/mysql/plugin/auth_pam_tool_dir

USER $MARIADB_UID
