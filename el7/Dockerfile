FROM centos:7
LABEL AUTHOR "Ben Nied <spacewreckage@gmail.com>"

RUN yum -y install gcc make bison flex git yum-utils spectool rpmbuild yum-builddep centos-release-scl wget
RUN yum clean all
RUN git clone https://github.com/bnied/kernel-rc-aufs.git /opt/kernel-rc-aufs

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]
