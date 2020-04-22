#FROM nginx:alpine
#FROM openresty/openresty:alpine
#FROM openresty/openresty:1.15.8.2-4-alpine

FROM alpine:3.5 as build
ENV tenantuserid=1073
ENV USERID $tenantuserid
RUN addgroup -g $USERID -S dsh && adduser -u $USERID -S dsh -G dsh
# Add bashit

ENV HUGO_VERSION 0.68.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install Hugo
RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*
 



COPY ./ /site 

WORKDIR /site
#RUN /usr/bin/hugo -D


FROM nginx:alpine


COPY --from=build /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html