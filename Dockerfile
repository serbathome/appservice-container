FROM nginx:latest
LABEL maintainer="Sergey Biryukov"
LABEL version="1.0"
LABEL description="This is custom Docker Image for Nginx"
COPY index.html /usr/share/nginx/html
EXPOSE 80
