from pyspark.sql import SparkSession
from pyspark.sql.functions import current_timestamp
import time

# Initialize Spark Session
DELTA_JARS_PATH = "/opt/spark/jars/delta-core_2.12-2.4.0.jar,/opt/spark/jars/delta-storage-2.4.0.jar"

spark = ((((((SparkSession.builder.appName("RemoteDeltaLakeTest")
         .master("spark://localhost:7077"))
         )
         .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension"))
         .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog"))
         .config("spark.sql.warehouse.dir", "file:///mnt/delta-storage"))
         .getOrCreate())

# Define Delta table path
delta_table_path = "file:///mnt/delta-storage/sensor_readings"

# Generate streaming sensor data
def generate_data():
    return [
        ("sensor_1", 22.5, 50.1, current_timestamp()),
        ("sensor_2", 23.0, 48.2, current_timestamp()),
        ("sensor_3", 21.8, 52.3, current_timestamp()),
    ]

# Append new sensor data every 5 seconds
for i in range(5):
    df = spark.createDataFrame(generate_data(), ["sensor_id", "temperature", "humidity", "timestamp"])
    df.write.format("delta").mode("append").save(delta_table_path)
    print(f"✅ Appended batch {i + 1} to Delta table")
    time.sleep(5)

# Read the latest snapshot from Delta Lake
print("✅ Reading latest sensor data...")
df_read = spark.read.format("delta").load(delta_table_path)
df_read.show()

spark.stop()
print("✅ Delta Streaming Test Completed!")



