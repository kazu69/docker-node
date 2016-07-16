FROM kazu69/alpine-base
MAINTAINER kazu69 'kazu.69.web+docker@gmail.com'

ENV NODE_VERSION v6.3.0

RUN apk add --update make \
                    gcc \
                    g++ \
                    linux-headers \
                    paxctl \
                    musl-dev \
                    libgcc \
                    libstdc++ \
                    binutils-gold \
                    python \
                    openssl-dev \
                    zlib-dev && \
                    rm -rf /var/cache/apk/*

RUN mkdir -p /root/src && \
    cd /root/src && \
    curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz && \
    cd /root/src/node-${NODE_VERSION} && \
    ./configure --prefix=/usr --without-snapshot && \
    make install

# npm@3 install bug for Docker aufs
RUN cd $(npm root -g)/npm && \
    npm install fs-extra && \
    sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js

RUN npm i -g npm
RUN npm cache clean && \
    apk del make gcc g++ python linux-headers && \
    rm -rf /root/src /tmp/* && \
    apk search --update
