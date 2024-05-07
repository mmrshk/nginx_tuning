# Use an official Nginx base image
FROM nginx:latest

# Install dependencies required for compilation
RUN apt-get update \
    && apt-get install -y wget build-essential \
    && rm -rf /var/lib/apt/lists/*

# Download Nginx source code
RUN wget http://nginx.org/download/nginx-1.20.2.tar.gz \
    && tar -zxvf nginx-1.20.2.tar.gz

# Download ngx_cache_purge module
RUN wget https://github.com/FRiCKLE/ngx_cache_purge/archive/refs/tags/2.5.tar.gz \
    && tar -zxvf 2.5.tar.gz

# Download MD5 Lua library
RUN wget https://github.com/kikito/md5.lua/archive/master.zip \
    && unzip master.zip \
    && mv md5.lua-master/md5.lua /usr/local/lib/

# Compile Nginx with ngx_cache_purge module
RUN cd nginx-1.20.2 \
    && ./configure --add-module=../ngx_cache_purge-2.5 \
    && make \
    && make install

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
