### **📌 Delta Lake - ACID Transactions for Big Data**  

## **📖 Overview**  
Delta Lake is an **open-source storage layer** that brings **ACID transactions, scalable metadata handling, and schema enforcement** to Apache Spark. It is designed to solve issues with **data quality, reliability, and performance** when working with large-scale distributed datasets.  

In this project, **Delta Lake is integrated into Apache Spark** to provide:  
✅ **ACID Transactions** – Ensures **data consistency** even when multiple queries modify the same dataset.  
✅ **Schema Evolution & Enforcement** – Prevents bad data from corrupting datasets.  
✅ **Time Travel & Versioning** – Enables rollbacks and historical queries.  
✅ **Efficient Data Compaction** – Optimizes **Parquet** storage through Delta Lake’s **OPTIMIZE** command.  

---

## **📍 Where is Delta Lake in this Stack?**  
Delta Lake is deployed as part of the **Spark service** and is stored in:  

- **Docker Compose**
  - Delta Lake runs inside **Spark Master and Spark Workers**.
  - **Storage:** Mounted at `/opt/spark/storage/delta`
  - **JARs:** Stored in `/opt/spark/jars/`
  
- **Kubernetes (Helm)**
  - Spark and Delta Lake are in the **`bigdata-query` namespace**.
  - Storage is backed by a **PersistentVolumeClaim (PVC)** for durability.
  - Runs in the **`np-query` node pool** for optimized query performance.

---

## **🛠️ Deployment & Configuration**  

### **1️⃣ Docker Compose Setup**
Delta Lake is built into Spark via a **custom image** with pre-installed JARs.  

- Delta storage location: `${DELTA_LAKE_STORAGE_LOCATION}`
- Delta JARs location: `${JAR_PATH}` (preloaded during build)

📌 **Start Delta Lake with Spark:**
```sh
docker-compose up -d
```

📌 **Verify Delta Lake is Running in Spark:**
```sh
docker exec -it spark-master /opt/bitnami/spark/bin/spark-shell
```
Then run:
```scala
import io.delta.tables._
val df = spark.range(5)
df.write.format("delta").save("/opt/spark/storage/delta/sample-data")
val deltaTable = DeltaTable.forPath(spark, "/opt/spark/storage/delta/sample-data")
deltaTable.toDF.show()
```
✅ If the table displays correctly, **Delta Lake is working**.

---

### **2️⃣ Kubernetes (Helm) Setup**
In production, Delta Lake is deployed via **Helm** inside the Spark environment.

📌 **Deploy Spark & Delta Lake to Kubernetes:**
```sh
helmfile -e prod apply
```

📌 **Verify Storage in Kubernetes:**
```sh
kubectl get pvc -n bigdata-query
```

---

## **🔍 Use Cases in this Stack**  
Delta Lake serves as the **optimized data storage layer** for this project.  

💡 **Potential Use Cases:**  
1. **Unifying MySQL, PostgreSQL, and Neo4j Data**  
   - Convert relational data into **Delta format** for **fast querying**.  
2. **Data Warehousing & Analytics**  
   - Store large datasets **efficiently**, allowing **Presto** and **Trino** to query it quickly.  
3. **ETL Pipelines**  
   - Use **Apache NiFi** or **Airflow** to **ingest raw data**, store it in Delta format, and **transform it with Spark**.  
4. **Machine Learning & AI**  
   - Delta Lake allows for **version-controlled datasets**, useful for **ML model training**.  

---

## **🔧 Maintenance & Troubleshooting**  
📌 **Check Delta Table Versions**  
```scala
import io.delta.tables._
val deltaTable = DeltaTable.forPath(spark, "/opt/spark/storage/delta/sample-data")
deltaTable.history().show()
```

📌 **Roll Back to an Earlier Version**  
```scala
deltaTable.restoreToVersion(2)
```

📌 **Optimize Storage by Removing Old Data**  
```scala
deltaTable.vacuum()
```

---

## **📌 Summary**
- **Delta Lake is integrated into Spark** for **ACID transactions** and **high-performance analytics**.
- **Docker Compose stores Delta data** in `/opt/spark/storage/delta`.
- **Kubernetes mounts storage dynamically** for scalability.
- **Presto, Trino, and BI tools can query Delta tables** for **faster analytics**.
- **ETL pipelines use Delta Lake as an optimized storage layer** for **transformations**.

✅ **Delta Lake is now fully operational!** 🚀