Yes! You can quickly check if **Delta Lake** is available inside the **Spark Master** container using Spark SQL.

### **✅ Quick Check Using Spark Shell**
Run this command inside the **Spark Master** container:
```sh
docker exec -it spark-master /opt/bitnami/spark/bin/spark-shell
```
Then, in the Spark shell, run:
```scala
spark.conf.get("spark.sql.extensions")
```
✅ **Expected Output:**
```
res0: String = io.delta.sql.DeltaSparkSessionExtension
```
If **Delta Lake is correctly configured**, this confirms that Spark recognizes the Delta Lake extensions.

---

### **✅ Alternative: Check Delta Table Availability**
To list all Delta tables in the Spark session:
```scala
spark.sql("SHOW TABLES").show()
```
or check if Delta Lake is available:
```scala
import io.delta.tables._
println("✅ Delta Lake is available!")
```

---

### **✅ If Delta Lake is NOT Running**
If the **first command fails or returns nothing**, ensure:
1. **Delta JARs are mounted** inside Spark containers:
   ```sh
   docker exec -it spark-master ls /opt/spark/jars | grep delta
   ```
   ✅ **Expected Output:**
   ```
   delta-core_2.12-2.4.0.jar
   delta-storage-2.4.0.jar
   ```

2. **Delta configuration exists in `spark-defaults.conf`**
   ```sh
   docker exec -it spark-master cat /opt/bitnami/spark/conf/spark-defaults.conf | grep delta
   ```

3. **Restart Spark services:**
   ```sh
   docker-compose down && docker-compose up -d
   ```

🚀 Let me know if Delta Lake is detected, or if you need troubleshooting help! 🎯