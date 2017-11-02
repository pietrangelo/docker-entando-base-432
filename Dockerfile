FROM centos:7
LABEL mainteiner="Pietrangelo Masala <p.masala@entando.com>"

#Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java
ENV JRE_HOME=/usr/lib/jvm/jre
ENV MAVEN_HOME=/usr/share/maven

#Create an untrusted user entando and install all prerequisites
USER root
RUN useradd -ms /bin/bash entando \
&& yum update -y && yum install -y curl maven imagemagick wget git java-1.8.0-openjdk-devel \
&& yum clean all -y

USER entando
# Install entando dependencies (core, components, archetypes)
RUN cd /home/entando \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd entando-core && mvn install -DskipTests && mvn clean && cd .. \
&& cd entando-components && mvn install -DskipTests && mvn clean && cd .. \
&& cd entando-archetypes && mvn install -DskipTests && mvn clean && cd .. \
&& cp /home/entando/.m2/archetype-catalog.xml /home/entando/.m2/repository/ \
&& rm -rf entando-*
