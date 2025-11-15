#!/bin/bash
set -e

# ===========================
# 1. Formatear NameNode (solo primera vez)
# ===========================
if [ ! -d "/opt/hadoop/data/nameNode/current" ]; then
    echo "Formatting NameNode..."
    echo 'Y' | hdfs namenode -format
fi

echo "Arrancando NameNode..."
# Lanzamos el NameNode en background
hdfs namenode &

# ===========================
# 2. Esperar a que HDFS responda
# ===========================
echo "Esperando a que HDFS esté disponible..."
until hdfs dfs -ls / >/dev/null 2>&1; do
  sleep 2
done

echo "HDFS disponible."

# ===========================
# 3. Directorios de Hive en HDFS
# ===========================
echo "Configurando directorios de Hive en HDFS..."

# Crear directorios si no existen
hdfs dfs -mkdir -p /user/hive/warehouse || true
hdfs dfs -mkdir -p /tmp/hive/scratch   || true
hdfs dfs -mkdir -p /.hive-staging      || true

# Permisos amplios (entorno de pruebas)
hdfs dfs -chmod -R 777 /user/hive       || true
hdfs dfs -chmod -R 777 /tmp/hive        || true
hdfs dfs -chmod -R 777 /.hive-staging   || true

echo "Directorios de Hive configurados."

# ===========================
# 4. Subir librerías de Tez a HDFS (para tez.lib.uris)
# ===========================
TEZ_VERSION=0.10.4
TEZ_LOCAL_TAR=/opt/tez/tez-${TEZ_VERSION}.tar.gz
TEZ_HDFS_DIR=/apps/tez-${TEZ_VERSION}
TEZ_HDFS_TAR=${TEZ_HDFS_DIR}/tez-${TEZ_VERSION}.tar.gz

echo "Configurando Tez en HDFS..."

if [ -f "${TEZ_LOCAL_TAR}" ]; then
  # Solo subir si aún no existe en HDFS
  if ! hdfs dfs -test -e "${TEZ_HDFS_TAR}"; then
    echo "Subiendo Tez ${TEZ_VERSION} a HDFS en ${TEZ_HDFS_TAR}..."
    hdfs dfs -mkdir -p "${TEZ_HDFS_DIR}" || true
    hdfs dfs -put -f "${TEZ_LOCAL_TAR}" "${TEZ_HDFS_TAR}"
  else
    echo "Tez ya existe en HDFS en ${TEZ_HDFS_TAR}, no se vuelve a subir."
  fi
else
  echo "ADVERTENCIA: No se ha encontrado ${TEZ_LOCAL_TAR}. Tez no podrá usarse hasta que exista ese tar en el contenedor."
fi

# Directorio de staging de Tez (coincide con tez.staging-dir en tez-site.xml)
hdfs dfs -mkdir -p /tmp/tez/staging || true
hdfs dfs -chmod -R 777 /tmp/tez     || true

echo "Tez configurado en HDFS."

# ===========================
# 5. Mantener el contenedor vivo
# ===========================
echo "HDFS listo con directorios de Hive y Tez."
tail -f /dev/null
