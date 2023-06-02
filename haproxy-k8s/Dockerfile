FROM haproxy:2.3

# Create a system group and add user to be used by HAProxy
#RUN groupadd haproxy && useradd -g haproxy haproxy

#RUN mkdir /var/lib/haproxy

COPY haproxy.cfg /usr/local/etc/haproxy/

EXPOSE 443 80