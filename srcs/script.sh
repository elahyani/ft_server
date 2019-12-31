#install nginx ***
apt update
apt upgrade
apt install -y nginx
service nginx start

#insatll mysql on debian ***
apt-get install -y wget vim lsb-release gnupg
apt update
apt upgrade
wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
printf "1\n1\n4\n" | dpkg -i mysql-apt-config_0.8.13-1_all.deb
apt update
apt install -y mysql-server
service mysql start

#install php7.3 ***
apt install -y php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cli php-cgi
apt install -y php-fpm php-mysql
nginx -t
service nginx restart
service php7.3-fpm start

#install phpMyAdmin ***
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz.asc
sha256sum phpMyAdmin-4.9.0.1-english.tar.gz
mkdir /var/www/html/phpmyadmin
tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
cp /var/www/html/phpmyadmin/config{.sample,}.inc.php
cp /usr/bin/config.inc.php /var/www/html/phpmyadmin/config.inc.php
chmod 660 /var/www/html/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/html/phpmyadmin
service nginx restart

#install wordpress ***
apt -y update
echo "create database dbwp;" | mysql -u root -p
echo "create user hel@localhost identified by 'hel123';" | mysql -u root -p
echo "grant all privileges on dbwp.* to hel@localhost;" | mysql -u root -p
echo "flush privileges;" | mysql -u root -p
echo "quit" | mysql -u root -p
apt install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
nginx -t
service nginx reload
wget https://wordpress.org/latest.tar.gz -P /tmp
mkdir /var/www/html/wordpress
tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/wordpress
cp /var/www/html/wordpress/wp-config{-sample,}.php
cp /usr/bin/wp-config.php /var/www/html/wordpress/wp-config.php
chown -R www-data:www-data /var/www/html/wordpress

#certif SSL ***
printf "MA\nKH\nKH\nORG_NM\nVERV_NM\n_\nftserver@projetc.com\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
cp /usr/bin/default /etc/nginx/sites-available/default
nginx -t
service nginx restart
