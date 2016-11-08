FROM mcristinagrosu/bigstepinc_java_8

RUN apk add --update alpine-sdk
RUN apk add unzip

ENV SBT_VERSION 0.13.11
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

# Install sbt
RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

RUN cd /tmp && \
    curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built &&\
    git clone https://github.com/yahoo/kafka-manager.git && \
    cd kafka-manager && \
    sbt clean dist && \
    mv ./target/universal/kafka-manager*.zip /opt && \
    cd /opt && \
    unzip kafka-manager*.zip && \
    ln -s $(find kafka-manager* -type d -prune) kafka-manager
    
    
  #  make dist SHELL=/bin/bash && \
  #  mv /tmp/incubator-toree/dist/toree /opt/toree-kernel && \
  #  chmod +x /opt/toree-kernel && \
  #  rm -rf /tmp/incubator-toree 

# Install some basic utils
#RUN           echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
#RUN           sudo apt-get update
#RUN           sudo apt-get upgrade -y
#RUN           sudo apt-get install -y software-properties-common unzip

# For Kafka-manager
#RUN           sudo apt-get install -y --allow-unauthenticated sbt
#RUN           cd /tmp && git clone https://github.com/yahoo/kafka-manager.git
#RUN           cd /tmp/kafka-manager && sbt clean dist && mv ./target/universal/kafka-manager*.zip /opt
#RUN           cd /opt && unzip kafka-manager*.zip && ln -s $(find kafka-manager* -type d -prune) kafka-manager

ENV           KAFKA_MANAGER_HOME /opt/kafka-manager

ADD           ./image-files/start-kafka-manager.sh /usr/bin/

EXPOSE 9000

ENTRYPOINT     ["/usr/bin/start-kafka-manager.sh"]
 
# vim: set nospell:
