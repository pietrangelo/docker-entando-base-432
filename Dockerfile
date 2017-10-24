FROM centos:7
LABEL mainteiner="Pietrangelo Masala <p.masala@entando.com>"

#Environment Variables
ENV JAVA_HOME=/opt/jdk1.8.0_141
ENV JRE_HOME=/opt/jdk1.8.0_141/jre
ENV MAVEN_HOME=/usr/share/maven

#Create an untrusted user entando and install all prerequisites
USER root
RUN useradd -ms /bin/bash entando \
&& yum install -y curl maven imagemagick wget git \
&& cd /opt \
&& wget --no-cookies --no-check-certificate --header \
"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz" \
&& tar xzf jdk-8u141-linux-x64.tar.gz \
&& rm -f jdk-8u141-linux-x64.tar.gz \
&& rm -f /usr/bin/java /usr/bin/jar /usr/bin/javac \
&& cd jdk1.8.0_141/ \
&& ln -s /opt/jdk1.8.0_141/bin/java /usr/bin/java \
&& ln -s /opt/jdk1.8.0_141/bin/jar /usr/bin/jar \
&& ln -s /opt/jdk1.8.0_141/bin/javac /usr/bin/javac \
&& yum clean all -y

USER entando
# Install entando dependencies (core, components, archetypes)
RUN cd /home/entando \
&& git clone https://github.com/entando/entando-core.git \
&& git clone https://github.com/entando/entando-components.git \
&& git clone https://github.com/entando/entando-archetypes.git \
&& cd entando-core && mvn install -DskipTests && mvn clean && cd .. \
&& cd entando-components && mvn install -DskipTests && mvn clean && cd .. \
&& cd entando-archetypes && mvn install -DskipTests && mvn clean && cd .. 

