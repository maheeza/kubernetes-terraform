FROM amazonlinux:latest
ARG package
RUN echo $package
RUN if [ $package = "corretto11" ]; then yum -y update && yum install -y "https://d3pxv6yz143wms.cloudfront.net/11.0.2.9.3/java-11-amazon-corretto-devel-11.0.2.9-3.x86_64.rpm" \
; fi
RUN if [ $package = "corretto11latest" ]; then yum -y update && yum install -y java-11-amazon-corretto \
; fi
RUN if [ $package = "java8" ]; then yum -y update && yum -y install java-1.8.0-openjdk ; fi
RUN if [ $package = "Nodejs8" ]; then yum -y update && yum install -y gcc gcc-c++ make openssl-devel tar* xz && \
curl -O https://nodejs.org/dist/v8.16.1/node-v8.16.1.tar.gz && \
tar -xzvf node-v8.16.1.tar.gz && rm node-v8.16.1.tar.gz && \
cd node-v8.16.1 && ./configure && \
make && \
make install && \
npm i npm@5.6.0 -g \
; fi
RUN if [ $package = "Nodejs10" ]; then yum -y update && yum install -y gcc gcc-c++ make openssl-devel tar* xz && \
curl -O https://nodejs.org/dist/v10.1.0/node-v10.1.0.tar.gz && \  
tar -xvf node-v10.1.0.tar.gz && rm node-v10.1.0.tar.gz && \
cd node-v10.1.0 && ./configure && \
make && \
make install && \
npm i npm@5.6.0 -g \
; fi
RUN if [ $package = "Nodejs12" ]; then yum -y update && yum install -y gcc gcc-c++ make openssl-devel tar* xz && \
curl -O https://nodejs.org/dist/v12.22.0/node-v12.22.0.tar.gz && \  
tar -xvf node-v12.22.0.tar.gz && rm node-v12.22.0.tar.gz && \
cd node-v12.22.0 && ./configure && \
make && \
make install && \
npm i npm@latest -g \
; fi
RUN if [ $package = "Nodejs14" ]; then yum -y update && yum install -y gcc gcc-c++ make openssl-devel tar* xz && \
curl -O https://nodejs.org/dist/v14.17.3/node-v14.17.3.tar.gz && \  
tar -xvf node-v14.17.3.tar.gz && rm node-v14.17.3.tar.gz && \
cd node-v14.17.3 && ./configure && \
make && \
make install && \
npm i npm@latest -g \
; fi
RUN if [ $package = "corretto11Ext" ]; then yum -y update && yum install -y "https://d3pxv6yz143wms.cloudfront.net/11.0.2.9.3/java-11-amazon-corretto-devel-11.0.2.9-3.x86_64.rpm" && \
yum install -y fontconfig freetype libX11 libXext libXrender libjpeg libpng openssl xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 wget && \
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum install -y wkhtmltopdf wkhtmltopdf-devel \
; fi
RUN yum install unzip shadow-utils -y
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle-1.16.312.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
#Install AWS CLI
RUN ./awscli-bundle/install -b ~/bin/aws
RUN yum install jq -y
RUN jq --version
RUN groupadd --gid 5000 microapp
RUN useradd --uid 5000 --gid 5000 --shell /bin/bash microapp
#RUN docker run -d --cap-drop=all --cap-add=setuid --cap-add=setgid\cyc-aws-corretto-11-base
#RUN pwd
#RUN rpm -ql jq
#Varifiy version
RUN /root/bin/aws --version
#Copy newrelic.zip to /opt
RUN mkdir -p /newrelic_bin
COPY newrelic-java-5.8.0.zip /newrelic_bin
RUN cd /newrelic_bin && unzip newrelic-java-5.8.0.zip && rm newrelic-java-5.8.0.zip
RUN mkdir -p /newrelic_bin/newrelic/extensions
RUN chown -R microapp:microapp /newrelic_bin
#NewRelic 7.2 version
RUN mkdir -p /newrelic
COPY newrelic-7.2.zip /newrelic
#Extract newrelic.zip file and remove .zip
RUN cd /newrelic && unzip newrelic-7.2.zip && rm newrelic-7.2.zip
RUN mkdir -p /newrelic/newrelic/extensions
RUN chown -R microapp:microapp /newrelic
#NewRelic 7.5.0 version
RUN mkdir -p /newrelic-java-7.5.0
COPY newrelic-java-7.5.0.zip /newrelic-java-7.5.0
#Extract newrelic-java-7.5.0.zip file and remove newrelic-java-7.5.0.zip
RUN cd /newrelic-java-7.5.0 && unzip newrelic-java-7.5.0.zip && rm newrelic-java-7.5.0.zip
RUN mkdir -p /newrelic-java-7.5.0/newrelic/extensions
RUN chown -R microapp:microapp /newrelic-java-7.5.0
RUN aws --version
