FROM ubuntu:20.04

RUN apt-get update \
    && apt-get -y install openssh-server sudo \
    && apt-get clean \
    && groupadd -g 71000 ansible \
    && useradd -m -d "/home/ansible" -s "/bin/bash" -c "Ansible User" -g ansible -u 71000 ansible \
    && echo "ansible:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd \
    && echo "ansible ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/ansible \
    && mkdir /home/ansible/.ssh \
    && chmod 700 /home/ansible/.ssh \
    && chown ansible:ansible /home/ansible/.ssh

COPY ./ansible_id_rsa.pub /home/ansible/.ssh/authorized_keys

RUN chmod 644 /home/ansible/.ssh/authorized_keys \
    && chown ansible:ansible /home/ansible/.ssh/authorized_keys \
    && service ssh start \
    && echo "/usr/sbin/sshd -D" > /entrypoint.sh \
    && chmod 755 /entrypoint.sh

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

#ENTRYPOINT ["/entrypoint.sh"]
