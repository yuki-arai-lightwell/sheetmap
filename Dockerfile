FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


# YUM requires root 
USER 0

RUN yum -y install yum-utils && \
    yum -y install gettext  && \
    yum -y install hostname && \
#    yum -y install nss_wrapper && \
    yum -y install bind-utils &&\
#    yum -y install httpd24 &&\ 
#    yum -y install httpd24-mod_ssl &&\ 
#    yum -y install httpd24-mod_auth_mellon &&\ 
    yum -y install httpd &&\ 
    yum -y install perl && \
    yum -y install which && \
    yum -y install unzip && \
    yum -y install net-tools && \
    yum -y install perl-DBI && \
    rm -rf /var/cache/yum
#    /usr/libexec/httpd-prepare && rpm-file-permissions

RUN chmod 777 /run/httpd
RUN chmod 777 /var/log/httpd
ADD httpd.conf /etc/httpd/conf/httpd.conf
ADD index.html /var/www/html/index.html
ADD index.cgi /var/www/cgi-bin/index.cgi
RUN chmod 766 /var/www/html/index.html
RUN chmod 755 /var/www/cgi-bin/index.cgi

RUN useradd lw

# Back to unprivileged user
USER lw


# CGI scripts go to /opt/rh/httpd24/root/var/www/cgi-bin/
#ADD share/cgi-bin ${HTTPD_DATA_ORIG_PATH}/cgi-bin/

# Static files go to /opt/rh/httpd24/root/var/www/html
#ADD share/html ${HTTPD_DATA_ORIG_PATH}/html

CMD /usr/sbin/httpd -k start && tail -f /dev/null
