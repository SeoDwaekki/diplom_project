FROM nginx:1.27.0
RUN apt-get update && apt-get install -y libexpat1=2.5.0-1+deb12u1
RUN rm -rf /usr/share/nginx/html/*
COPY src/ /usr/share/nginx/html/
EXPOSE 80
