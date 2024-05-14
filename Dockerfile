FROM centos:centos7

# update yum
RUN yum -y update
RUN yum -y install yum-utils
RUN yum clean all

# httpd, vim, firewalld
RUN yum -y install httpd 
# RUN yum -y install vim 
RUN yum -y install firewalld 

RUN yum -y install epel-release
# RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget git vim curl
RUN yum -y install crontabs zip unzip
# install remi repo
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
RUN yum-config-manager --enable remi-php81

# install php7
RUN \
	yum -y install \
	php php-common \
	php-mbstring \
	php-mcrypt \
	php-devel \
	php-xml \
	php-mysqlnd \
	php-pdo \
	php-dom \
	php-opcache --nogpgcheck \
	php-bcmath

# PHP GD拡張とその依存パッケージをインストール 
RUN yum -y install php-gd --nogpgcheck

# Imagickの依存関係とImagick自体のインストール
RUN yum -y install ImageMagick ImageMagick-devel
RUN yum -y install php-pecl-imagick --nogpgcheck
RUN echo "extension=imagick.so" > /etc/php.d/20-imagick.ini


# Node.js setup
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -

# Node.js install
RUN yum -y install nodejs

# yarn install
RUN npm install -g yarn


WORKDIR /var/www/html

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer

# timezone setting
RUN cp /etc/localtime /etc/localtime.org
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
