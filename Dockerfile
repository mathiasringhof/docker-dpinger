# disposable build image
# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest AS build

RUN apk --no-cache add clang gcc git libc-dev make &&\
  cd tmp &&\
  git clone --depth 1 https://github.com/dennypage/dpinger.git &&\
  cd dpinger &&\
  make all

# end result
# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Mathias Ringhof <mathias@ringhof.eu>"

# Environment variables to configure dpinger
ENV DPINGER_IP=127.0.0.1
ENV DPINGER_LOSS=20
ENV DPINGER_REPORT_INTERVAL=0

COPY --from=build /tmp/dpinger/dpinger /usr/local/bin/dpinger

ENTRYPOINT /usr/local/bin/dpinger -f -r $DPINGER_REPORT_INTERVAL -L $DPINGER_LOSS -i $DPINGER_IP $DPINGER_IP
