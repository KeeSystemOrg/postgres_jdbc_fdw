FROM postgres:15

LABEL org.opencontainers.image.source=https://github.com/KeeSystemOrg/postgres_jdbc_fdw

# Copy jdbc_fdw source files
USER root

# Install Java first and setup certificates
RUN apt-get update \
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y --no-install-recommends openjdk-17-jdk ca-certificates \
    && mkdir -p /etc/ssl/certs/java

# Install other build dependencies and build jdbc_fdw
RUN apt-get install -y --no-install-recommends \
        unzip wget make gcc cmake pkg-config postgresql-server-dev-15

COPY . /tmp/jdbc_fdw/

RUN cd /tmp/jdbc_fdw \
    && ln -s /usr/lib/jvm/java-17-openjdk-amd64/lib/server/libjvm.so /usr/lib/libjvm.so \
    && USE_PGXS=1 LIBDIR=/usr/lib make clean \
    && USE_PGXS=1 LIBDIR=/usr/lib make install


RUN wget -O /tmp/FilemakerJdbcDriver.zip https://dbschema.com/jdbc-drivers/FilemakerJdbcDriver.zip

# Unzip the JAR to the specified location and remove the ZIP afterwards
RUN unzip /tmp/FilemakerJdbcDriver.zip fmjdbc.jar -d /usr/share/java/ && \
    rm /tmp/FilemakerJdbcDriver.zip


USER postgres
