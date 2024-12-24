# Stage 1: Build zlib 1.3.1 from source
FROM debian:bookworm-slim AS builder
WORKDIR /tmp
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget 
RUN wget --no-check-certificate https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz -O zlib-1.3.1.tar.gz && \
    tar -xzf zlib-1.3.1.tar.gz && \
    cd zlib-1.3.1 && \
    ./configure && \
    make && \
    make install

# Stage 2: Final image with nginx
FROM nginx:1.27.0
# Copy zlib from the builder stage
COPY --from=builder /usr/local/lib/libz.so* /usr/local/lib/
COPY --from=builder /usr/local/include/zlib.h /usr/local/include/
COPY --from=builder /usr/local/include/zconf.h /usr/local/include/
RUN ldconfig
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libaom3=3.6.0-1+deb12u1 \
        libexpat1=2.5.0-1+deb12u1
RUN rm -rf /usr/share/nginx/html/*
COPY src/ /usr/share/nginx/html/
EXPOSE 80
