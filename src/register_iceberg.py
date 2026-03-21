import pyarrow.parquet as pq
from pyiceberg.catalog.rest import RestCatalog

# conectar al REST catalog
catalog = RestCatalog(
    name="iceberg",
    uri="http://localhost:8181",
    warehouse="s3://smart-meter/",
    **{
        "s3.endpoint": "http://localhost:9000",
        "s3.access-key-id": "minio",
        "s3.secret-access-key": "minio123",
        "s3.path-style-access": "true",
        "py-io-impl": "pyiceberg.io.pyarrow.PyArrowFileIO",
    }
)

# leer el esquema del parquet local
schema = pq.read_schema("data/daily_dataset.parquet")
print("Esquema detectado:", schema)

# crear el namespace y la tabla Iceberg
catalog.create_namespace("default")
table = catalog.create_table(
    "default.daily_dataset",
    schema=schema,
    location="s3://smart-meter/",
)

# registrar el parquet existente como fichero de datos
table.add_files(file_paths=["s3://smart-meter/daily_dataset.parquet"])
print("Tabla Iceberg registrada correctamente")