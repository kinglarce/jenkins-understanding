# This is the container "remote-host" and is use as a base image 
# That means that all of the config in the "remote-host" Dockerfile will
# be in this container as well
FROM remote-host 

# here, we're enable nginx repo so that we can download the package from there
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo

# here, we're install the ngix from the nginx.repo and php packages
RUN                                                                          \
  yum -y install nginx-1.12.2 openssl --enablerepo=nginx                  && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm         && \
  yum -y install                                                             \
    php71u-fpm                                                               \
    php71u-cli                                                               \
    php71u-mysqlnd                                                           \
    php71u-soap                                                              \
    php71u-xml                                                               \
    php71u-zip                                                               \
    php71u-json                                                              \
    php71u-mcrypt                                                            \
    php71u-mbstring                                                          \
    php71u-zip                                                               \
    php71u-gd                                                                \
     --enablerepo=ius && yum clean all

# here is the port we're exposing
EXPOSE 80 443

# here we're creating the volumn for the html and logs so if container dies then we can
# secure the data
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm

# here we're copying the nginx php virtual host to our container and this will be the
# web server configuration
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# this will copy the "start.sh" from "./bin" in the web folder to the container
COPY ./bin/start.sh /start.sh

# change the mode to be executable
RUN chmod +x /start.sh

# and then RUN
# this will start the ssh, start php, and start nginx
CMD /start.sh

