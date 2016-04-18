FROM alpine:edge
MAINTAINER ZZROT LLC <docker@zzrot.com>


ENV BUILD_PACKAGES nodejs bash curl-dev ruby-dev build-base git python tar
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler

RUN apk --no-cache add $BUILD_PACKAGES \
		&& apk --no-cache add $RUBY_PACKAGES

#Copy over the default Package.json
COPY ./gulp/package.json /usr/src/

#Copy over the default Gulpfile
COPY ./gulp/Gulpfile.js /usr/src/

WORKDIR /usr/src/

RUN npm update \
		&& npm install \
		&& npm cache clean \
		&& gem install --no-rdoc --no-ri scss_lint

#Copy over, and grant executable permission to the startup script
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

#Run Startup script
ENTRYPOINT [ "/entrypoint.sh" ]
