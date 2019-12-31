FROM debian:buster
COPY srcs/default /usr/bin/default
COPY srcs/config.inc.php /usr/bin/config.inc.php
COPY srcs/wp-config.php /usr/bin/wp-config.php
COPY srcs/script.sh /usr/bin/script.sh
RUN chmod +x /usr/bin/script.sh
CMD bash script.sh && bash