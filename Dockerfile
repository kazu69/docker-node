FROM kazu69/alpine-base
MAINTAINER kazu69

ENV NODE_VERSION v8.7.0
ENV YARN_VERSION 0.22.0
ENV YARN_DIR /opt/yarn

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
                    python-dev \
                    py-pip \
                    build-base \
                    openssl-dev \
                    zlib-dev \
                    fontconfig && \
                    pip install virtualenv && \
                    rm -rf /var/cache/apk/*

RUN mkdir -p /root/src && \
    cd /root/src && \
    curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz && \
    cd /root/src/node-${NODE_VERSION} && \
    ./configure --prefix=/usr --without-snapshot && \
    make install


ADD https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v${YARN_VERSION}.tar.gz /opt/yarn.tar.gz

# npm install with yarn
RUN mkdir -p $YARN_DIR && \
    tar -xzf /opt/yarn.tar.gz -C $YARN_DIR && \
    rm /opt/yarn.tar.gz && \
    ln -s /opt/yarn/dist/bin/yarn /usr/local/bin

RUN yarn global add npm@5.4.2

RUN npm cache verify && \
    apk del make gcc g++ linux-headers && \
    rm -rf /root/src /tmp/* && \
    apk search --update
