FROM almalinux:8
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"

RUN dnf -y install gcc make bison flex git dnf-utils spectool rpm-build dnf-plugins-core wget
RUN dnf -y clean all
RUN git clone https://github.com/bnied/kernel-rc-aufs.git /opt/kernel-rc-aufs

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
