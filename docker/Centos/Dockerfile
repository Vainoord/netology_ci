FROM centos:7
RUN yum update -y; \
    yum clean all 
RUN yum install sudo -y; \
    yum clean all
RUN yum install python3 -y; \
    yum clean all
EXPOSE 8123/tcp
EXPOSE 9000/tcp
EXPOSE 9004/tcp
EXPOSE 9005/tcp
EXPOSE 9009/tcp
