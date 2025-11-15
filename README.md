# Big Data – Sesión 2 Motores de SQL para Big Data

Este repositorio contiene el entorno de desarrollo para la **Sesión 2: Motores de SQL para Big Data**.

## 🚀 Características

- 🔍 **Hive**: Ejecución de consultas SQL sobre datos almacenados en HDFS.  
- ⚡ **Trino**: Motor de consultas distribuido ultrarrápido para análisis interactivo.  
- 📁 Integración completa con **HDFS** y configuración sobre Docker.  
- 🗄️ Ejemplos prácticos y scripts para cargar datos y ejecutar queries.  
- 🔄 Entorno modular y fácil de extender para prácticas avanzadas.

## 📂 Estructura del Repositorio

```
📂 S2-Hive-Trino/
├── 📄 docker-compose.yml
├── 📄 dockerfile
├── 📂 hadoop_config/
├── 📂 hive/
├── 📂 trino-config/
├── 📂 scripts/
└── 📂 src/MapReduce/
```

## 🛠️ Requisitos

- **Docker** y **Docker Compose** instalados.  
- **RAM** recomendada: 8GB+  
- **Espacio en disco**: ~5GB

## ⚡ Instalación y Uso

1️⃣ Clona este repositorio:  
```sh
git clone https://github.com/<tu-org>/S2-Hive-Trino.git
cd S2-Hive-Trino
```

2️⃣ Inicia el entorno Hive/Trino:  
```sh
docker-compose up -d
```

3️⃣ Comprueba los contenedores:  
```sh
docker ps
```

4️⃣ Accede al contenedor de Hive:  
```sh
docker exec -it hive-server bash
```

5️⃣ Accede al CLI de Trino:  
```sh
docker exec -it trino bash
trino
```

## 📌 Comandos Útiles

### 🔹 Hive
```sh
beeline -u jdbc:hive2://localhost:10000
SHOW DATABASES;
```

### 🔹 Trino
```sql
SHOW CATALOGS;
SHOW SCHEMAS FROM hive;
SELECT * FROM hive.default.tabla LIMIT 10;
```

## 📝 Notas

- Hive y Trino pueden tardar unos segundos en inicializarse.  
- Si modificas los catálogos o configuraciones, reinicia los servicios:  
```sh
docker-compose down
docker-compose up -d
```

## 🐞 FAQ

**Hive no conecta con HDFS**  
Verifica que el Namenode está funcionando:  
```sh
docker ps | grep namenode
```

**El namenode me da un error de unexpected end of file**
Verifica caracteres ocultos en el fichero. Ejecuta:
```sh
cat -A start-hdfs.sh
```
Si ves ^M al final de las líneas, el archivo tiene formato Windows y debes convertirlo.
```sh
sed -i 's/\r$//' start-hdfs.sh
```

**Trino no muestra el catálogo Hive**  
Revisa la configuración del conector en `trino-config/catalog/hive.properties`.

## 📖 Referencias

- [Documentación oficial de Hive](https://cwiki.apache.org/confluence/display/Hive/Home)  
- [Documentación oficial de Trino](https://trino.io/docs/current/)  
- [Docker Hub – Hive/Trino Images](https://hub.docker.com/)
