from pyspark.sql import SparkSession

# Create a Spark session with a connection to your cluster
spark = (((SparkSession.builder.appName("PyCharmSparkTest")
         .master("spark://localhost:7077"))
         .config("spark.driver.memory", "2g"))
         .getOrCreate())

# Test the connection by creating a DataFrame
data = [("Alice", 29), ("Bob", 35), ("Charlie", 23)]
columns = ["Name", "Age"]
df = spark.createDataFrame(data, columns)

# Show the DataFrame
df.show()

# Stop the Spark session
spark.stop()