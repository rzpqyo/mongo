FROM ubuntu:14.04

MAINTAINER rzpqyo

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN apt-get install -y mongodb-org
RUN apt-get clean

RUN useradd -m rzpqyo
RUN mkdir -p /home/rzpqyo/.ssh; chown rzpqyo /home/rzpqyo/.ssh; chmod 700 /home/rzpqyo/.ssh
ADD ./authorized_keys /home/rzpqyo/.ssh/authorized_keys
RUN chown rzpqyo /home/rzpqyo/.ssh/authorized_keys; chmod 600 /home/rzpqyo/.ssh/authorized_keys
RUN usermod -G sudo rzpqyo
RUN echo 'rzpqyo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/rzpqyo/work/mongodb
ADD ./test.json /home/rzpqyo/work/mongodb/test.json
RUN chown -R rzpqyo:rzpqyo /home/rzpqyo/work/mongodb

CMD ["/usr/sbin/sshd","-D"]
