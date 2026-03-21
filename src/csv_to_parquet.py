import pandas as pd

df = pd.read_csv("data/daily_dataset.csv")
df.to_parquet("data/daily_dataset.parquet", index=False)

print("Archivo Parquet creado correctamente: data/daily_dataset.parquet")
print(df.head())
print(df.dtypes)