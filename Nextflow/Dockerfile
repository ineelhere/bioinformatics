FROM debian:stretch-slim
MAINTAINER indraneel
RUN apt-get update && apt-get install -y curl cowsay
ENV PATH=$PATH:/usr/games/
RUN curl -sSL https://github.com/COMBINE-lab/salmon/releases/download/v1.0.0/salmon-1.0.0_linux_x86_64.tar.gz | tar xz \
 && mv /salmon-*/bin/* /usr/bin/ \
 && mv /salmon-*/lib/* /usr/lib/
