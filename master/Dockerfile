# Build:
#  docker build -t gbevan/meanio .
#
# Run:
#

FROM ubuntu:14.04
MAINTAINER Graham Bevan "graham.bevan@ntlworld.com"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG=C
ENV LC_ALL=C

# Dependencies
RUN \
    apt-get -yq update && \
    apt-get dist-upgrade -yq && \
    apt-get install -yqq wget aptitude htop vim vim-puppet git traceroute dnsutils \
      curl ssh sudo psmisc gcc make build-essential libfreetype6 libfontconfig \
      augeas-tools tree tcpdump && \
    mkdir /var/run/sshd && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    useradd --create-home -s /bin/bash mean && \
    su - mean -c "mkdir -p .ssh; chmod 700 .ssh" && \
    echo -n "mean:`openssl rand -base64 15`" | chpasswd && \
    su - mean -c "touch .hushlogin" && \
    mkdir -p /etc/sudoers.d && \
    echo "mean ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mean && \
    chmod 0440 /etc/sudoers.d/mean && \
    echo "set modeline" > /etc/vim/vimrc.local && \
    echo "export TERM=vt100\nexport LANG=C\nexport LC_ALL=C" > /etc/profile.d/dockenv.sh && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Mongodb & mean-cli
RUN \
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
    apt-get -yq update && \
    apt-get install -yqq mongodb-org && \
    curl -sL https://deb.nodesource.com/setup | sudo bash - && \
    apt-get -yq update && \
    apt-get install -yqq nodejs && \
    apt-get clean && \
    npm install -g gulp-cli && \
    npm install -g gulp && \
    npm install -g karma-cli && \
    npm install -g mocha && \
    npm install -g bower && \
    npm install -g mean-cli && \
    npm install -g forever && \
    npm cache clean && \
    rm -rf /var/lib/mongodb/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

# App init
RUN \
    /usr/bin/mongod --config /etc/mongod.conf --fork --smallfiles && \
    echo "export MONGOOSE_DISABLE_STABILITY_WARNING=1" >> ~/.bashrc && \
    export MONGOOSE_DISABLE_STABILITY_WARNING=1 && \
    su - mean -c'mkdir -p .npm; echo -e "\n\n \n" | mean init appserver && cd appserver && npm install && bower --config.interactive=false install && mean install mean-admin && npm cache clean; bower cache clean' && \
    su - mean -c'cd appserver && gulp test' && \
    (/usr/bin/mongod --shutdown --config /etc/mongod.conf &) && \
    sleep 5 && \
    (killall mongod 2>/dev/null || true) && sleep 10 && (killall -9 mongod 2>/dev/null || true) && sleep 5 && \
    rm -rf /var/lib/mongodb/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD start-image.sh /

#CMD ["/usr/sbin/sshd", "-D", "-e"]
ENTRYPOINT ["/bin/bash", "/start-image.sh"]

EXPOSE 3000
