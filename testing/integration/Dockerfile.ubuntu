FROM ubuntu:16.04

LABEL maintainer "ivan.ilves@gmail.com"

RUN apt-get update && apt-get --yes install openssh-server openssh-client sudo iproute2 iputils-ping iptables \
  && mkdir /var/run/sshd \
  && mkdir -p /lib/systemd/system && touch /lib/systemd/system/ssh.service \
  && ln -s /bin/true /sbin/modprobe \
  && apt-get clean

ADD ./ssh-keys /root/.ssh
ADD ./systemctl.mock /bin/systemctl

CMD ["/usr/sbin/sshd", "-De"]
