FROM nginx:1.26.0
RUN rm -rf /usr/share/nginx/html/*
COPY src/ /usr/share/nginx/html/
EXPOSE 80
