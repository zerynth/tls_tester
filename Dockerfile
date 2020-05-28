### TEMP IMAGE TO BUILD MBEDTLS

FROM alpine:3.11 as builder

# install gcc and create build folder
RUN apk add --update gcc musl-dev 
RUN apk add --update make
RUN  mkdir -p ./build

ADD ./mbedtls /build/
WORKDIR /build 

RUN make no_test

### COPY TO MAIN IMAGE

FROM alpine:3.11


RUN apk update && \
  apk add --no-cache openssl && \
  rm -rf /var/cache/apk/*

WORKDIR /

COPY --from=builder /build/programs/ssl/ssl_server2 /ssl_server2
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


