# syntax = docker/dockerfile:latest

FROM python:3.13.3-alpine3.21 

RUN apk add --no-cache -U   \
        bash                \
        bash-completion     \
        bash-doc            \
        btrfs-progs         \
        ca-certificates     \
        curl                \
        findmnt             \
        fuse                \
        acl-libs            \
        libxxhash           \
        logrotate           \
        lz4-libs            \
        mariadb-client      \
        mariadb-connector-c \
        mongodb-tools       \
        openssl             \
        postgresql-client   \
        sshfs               \
        sqlite              \
        tzdata              \
        xxhash              \
        msmtp               \
    && apk upgrade --no-cache

COPY --chmod=755 entry.sh /entry.sh
COPY requirements.txt /

RUN python3 -m pip install -U pip \
    && python3 -m pip install -Ur requirements.txt \
    && apk add --no-cache -U borgmatic-bash-completion

RUN mkdir /root/.ssh \
    && touch /root/.ssh/config \
    && echo "StrictHostKeyChecking=accept-new" | tee /root/.ssh/config \
    && ln -sf /usr/bin/msmtp /usr/sbin/sendmail \
    && update-ca-certificates

ENTRYPOINT [ "/entry.sh" ]