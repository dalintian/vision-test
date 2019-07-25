FROM node:8-slim
RUN apt-get update  && apt-get install -y nginx
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org && cnpm install
COPY . .
RUN cnpm run build
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
RUN cp -r dist/* /var/www/html \
    && rm -rf /user/src/app
CMD ["nginx","-g","daemon off;"]
