FROM apache/hadoop:3.4.1

USER root

# -----------------------------
# Repositorios CentOS 7
# -----------------------------
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

RUN cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-7 - Base
baseurl=http://vault.centos.org/centos/7/os/x86_64/
enabled=1
gpgcheck=0

[updates]
name=CentOS-7 - Updates
baseurl=http://vault.centos.org/centos/7/updates/x86_64/
enabled=1
gpgcheck=0

[extras]
name=CentOS-7 - Extras
baseurl=http://vault.centos.org/centos/7/extras/x86_64/
enabled=1
gpgcheck=0
EOF

RUN yum clean all && yum makecache

# -----------------------------
# Java + Python + utilidades
# -----------------------------
RUN yum install -y \
      java-11-openjdk-devel \
      python3 \
      wget \
      curl \
    && yum clean all

# -----------------------------
# Variables de entorno básicas
# -----------------------------
# No sobreescribimos JAVA_HOME: la imagen base ya lo define correctamente.
ENV PYTHON=/usr/bin/python3

# -----------------------------
# Instalación de Apache Tez
# -----------------------------
ENV TEZ_VERSION=0.10.4
ENV TEZ_BASE_DIR=/opt/tez

RUN mkdir -p "${TEZ_BASE_DIR}" \
 && wget -q "https://archive.apache.org/dist/tez/${TEZ_VERSION}/apache-tez-${TEZ_VERSION}-bin.tar.gz" \
       -O /tmp/apache-tez-${TEZ_VERSION}-bin.tar.gz \
 # Guardamos un tar limpio para subirlo a HDFS luego (para tez.lib.uris)
 && cp /tmp/apache-tez-${TEZ_VERSION}-bin.tar.gz "${TEZ_BASE_DIR}/tez-${TEZ_VERSION}.tar.gz" \
 # Extraemos las librerías en /opt/tez/tez-0.10.4
 && tar -xzf /tmp/apache-tez-${TEZ_VERSION}-bin.tar.gz -C "${TEZ_BASE_DIR}" \
 && mv "${TEZ_BASE_DIR}/apache-tez-${TEZ_VERSION}-bin" "${TEZ_BASE_DIR}/tez-${TEZ_VERSION}" \
 && rm -f /tmp/apache-tez-${TEZ_VERSION}-bin.tar.gz

# TEZ_HOME apunta al directorio extraído
ENV TEZ_HOME=${TEZ_BASE_DIR}/tez-${TEZ_VERSION}

# -----------------------------
# Integrar Tez con YARN / Hadoop
# -----------------------------
# Copiamos los JARs de Tez al classpath por defecto de YARN,
# para que los contenedores (incluido el DAGAppMaster) vean las clases de Tez.
RUN mkdir -p "${HADOOP_HOME}/share/hadoop/yarn" \
 && cp "${TEZ_HOME}"/*.jar           "${HADOOP_HOME}/share/hadoop/yarn/" \
 && cp "${TEZ_HOME}/lib"/*.jar       "${HADOOP_HOME}/share/hadoop/yarn/"

# Añadimos Tez también al HADOOP_CLASSPATH (para herramientas que tiran de este)
ENV HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*:/opt/hadoop/etc/hadoop"

CMD ["/bin/bash"]
