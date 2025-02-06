### **Namespace Naming**
Now including BI tools and reorganizing monitoring:
- **`bigdata-core`** → Databases & storage (MySQL, PostgreSQL, Delta Lake)
- **`bigdata-warehouse`** → Data warehousing (ClickHouse, Apache Druid)
- **`bigdata-etl`** → Data ingestion & orchestration (NiFi, Airflow)
- **`bigdata-query`** → Query engines (Presto, Trino)
- **`bigdata-bi`** → **BI tools & visualization** (Grafana, Superset, Metabase, Redash)
- **`bigdata-monitoring`** → Pure monitoring/logging (Prometheus, ELK)

---

### **Nodepool Naming**
With BI tools in mind, we allocate resources accordingly:

| Node Pool Name   | Purpose | Node Type (Example) |
|-----------------|----------------------------------------|--------------------------|
| **`np-storage`** | Databases & storage (PostgreSQL, Delta Lake) | High-memory, SSD-backed |
| **`np-etl`** | Data ingestion & orchestration (NiFi, Airflow) | CPU-optimized nodes |
| **`np-query`** | Query engines (Presto, Trino) | High-memory, balanced |
| **`np-bi`** | **BI tools & dashboards (Grafana, Superset, Metabase, Redash)** | High-memory, GPU (if needed) |
| **`np-monitoring`** | Pure monitoring/logging (Prometheus, ELK) | Standard nodes |
| **`np-default`** | General-purpose workloads | Standard autoscaling |

