FROM node:7.2.0-wheezy
MAINTAINER kazu69

# install libsass
RUN git clone https://github.com/sass/sassc && cd sassc && \
    git clone https://github.com/sass/libsass && \
    SASS_LIBSASS_PATH=/sassc/libsass make && \
    mv bin/sassc /usr/bin/sassc && \
    cd ../ && rm -rf /sassc

# created node-sass binary
ENV SASS_BINARY_PATH=/usr/lib/node_modules/node-sass/build/Release/binding.node'
RUN git clone --recursive https://github.com/sass/node-sass.git && \
    cd node-sass && \
    git submodule update --init --recursive && \
    npm install && \
    node scripts/build -f && \
    cd ../ && rm -rf node-sass

# add binary path of node-sass to .npmrc
RUN touch $HOME/.npmrc && echo "sass_binary_cache=${SASS_BINARY_PATH}" >> $HOME/.npmrc

# npm@3 install bug for Docker aufs
RUN cd $(npm root -g)/npm && \
    npm install fs-extra && \
    sed -i -e s/graceful-fs/fs-extra/ -e s/fs\.rename/fs.move/ ./lib/utils/rename.js

RUN npm i -g npm
RUN npm cache clean && \
    rm -rf /root/src /tmp/*

RUN mkdir -p /tmp && \
    cd /tmp && \
    wget https://yarnpkg.com/latest.tar.gz && \
    tar zvxf latest.tar.gz && \
    mkdir -p /opt && \
    mv /tmp/dist /opt/yarn

# phantomjs install
ENV PHANTOMJS_VERSION=2.11
RUN mkdir -p /tmp && \
    cd /tmp && \
    curl -L https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/${PHANTOMJS_VERSION}/phantomjs-alpine-x86_64.tar.bz2 | tar xj && \
    ln -s /tmp/phantomjs/phantomjs /usr/bin/phantomjs

# casperjs install
RUN mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/rdpanek/casperjs && \
    cd casperjs && \
    ln -sf bin/casperjs /usr/bin/casperjs

ENV PATH "$PATH:/opt/yarn/bin"
