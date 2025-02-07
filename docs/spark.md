# **Apache Spark - Big Data Processing Service**

## **📌 Overview**
Apache Spark is a fast and distributed data processing framework used for **big data processing, querying, and analytics**. It integrates with **Delta Lake, Presto, Trino**, and other query engines.

This document provides instructions on how to deploy and manage Spark using:
- **Docker Compose** (for local development)
- **Helm Charts** (for Kubernetes production deployments)
- **Terraform** (for Hetzner Cloud infrastructure provisioning)

---

## **📂 Directory Structure**
```
big-data-stack/
│── services/
│   ├── spark/
│   │   ├── docker-compose.yml   # Spark standalone setup
│   │   ├── .env                 # Spark environment variables
│   │   ├── config/
│   │   │   ├── spark-defaults.conf  # Spark configuration
│   │   ├── scripts/
│   │   │   ├── entrypoint.sh    # Startup script (if needed)
│
│── helm-charts/
│   ├── spark/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   │   ├── deployment.yaml
│   │   │   ├── service.yaml
│   │   │   ├── pvc.yaml
│
│── terraform/
│   ├── hetzner/
│   │   ├── spark.tf   # Spark infrastructure setup
│
│── helmfile.yaml  # Multi-service Helmfile deployment
│── environments/
│   ├── dev.yaml   # Helmfile values for development
│   ├── prod.yaml  # Helmfile values for production
```

---

## **🌍 Environment Variables**
Environment variables are stored in `.env` for Docker and `values.yaml` for Helm. Below is a brief explanation of each variable:

- `SPARK_MASTER_HOST`: The hostname of the Spark master node.
- `SPARK_WORKER_MEMORY`: Amount of memory allocated for Spark worker nodes.
- `SPARK_WORKER_CORES`: Number of CPU cores assigned to Spark worker nodes.
- `SPARK_DRIVER_MEMORY`: Memory allocated for the Spark driver process.
- `SPARK_EXECUTOR_MEMORY`: Memory allocated for each Spark executor.
- `SPARK_EXECUTOR_CORES`: Number of CPU cores assigned to each executor.

This section provides essential configurations to optimize Spark performance.
Environment variables are stored in `.env` for Docker and `values.yaml` for Helm.

### **🔹 `.env` (Docker Compose)**
```ini
SPARK_MASTER_HOST=spark-master
SPARK_WORKER_MEMORY=4G
SPARK_WORKER_CORES=2
SPARK_DRIVER_MEMORY=2G
SPARK_EXECUTOR_MEMORY=4G
SPARK_EXECUTOR_CORES=2
```

### **🔹 `values.yaml` (Helm)**
```yaml
spark:
  master:
    serviceType: ClusterIP
    port: 7077
    webUIPort: 8080
  worker:
    replicas: 2
    memory: "4G"
    cores: 2
  eventLog:
    enabled: true
    directory: "file:///opt/spark/logs"
nodeSelector:
  pool: np-query
```

---

## **💻 System Requirements**

### **🔹 Development Setup (Docker Compose)**
| Resource  | Minimum |
|-----------|---------|
| CPU       | 4 vCPUs |
| RAM       | 8GB     |
| Disk      | 10GB SSD |

### **🔹 Production Setup (Kubernetes & Hetzner)**
| Resource  | Minimum |
|-----------|---------|
| CPU       | 8 vCPUs |
| RAM       | 16GB    |
| Disk      | 50GB SSD (logs) + 100GB SSD (data) |

---

## **🚀 Deployment Instructions**

### **1️⃣ Local Development (Docker Compose)**
```sh
docker-compose up -d
```
📌 **Verify running services:**
```sh
docker ps
```
📌 **Access Spark UI:**
```sh
http://localhost:8080
```

### **2️⃣ Kubernetes Deployment (Helm Charts)**
**1️⃣ Deploy for Development**
```sh
helmfile -e dev apply
```

**2️⃣ Deploy for Production**
```sh
helmfile -e prod apply
```

**3️⃣ Verify Deployment**
```sh
kubectl get pods -n bigdata-query
kubectl get svc -n bigdata-query
```

**4️⃣ Expose Spark UI (if needed)**
```sh
kubectl port-forward service/spark-master 8080:8080 -n bigdata-query
```
📌 **View UI at:** [http://localhost:8080](http://localhost:8080)

### **3️⃣ Infrastructure Deployment (Terraform - Hetzner Cloud)**

Before applying the Terraform plan, ensure that `variables.tf` is properly configured to match your infrastructure needs. You can customize the following variables:

- `hcloud_token`: Hetzner Cloud API token.
- `region`: The region where your Hetzner instances will be deployed.
- `spark_node_count`: Number of Spark worker nodes.
- `spark_instance_type`: Instance type for Spark nodes.
- `ssh_key_name`: SSH key for secure access.

These variables can be modified in `terraform/hetzner/variables.tf` before running `terraform apply` to ensure correct resource allocation.
**1️⃣ Initialize Terraform**
```sh
terraform init
```

**2️⃣ Preview Changes**
```sh
terraform plan
```

**3️⃣ Deploy Infrastructure**
```sh
terraform apply -auto-approve
```

**4️⃣ Verify Hetzner Deployment**
```sh
hcloud server list
hcloud volume list
```

**5️⃣ SSH into Spark Master to Verify Setup**
```sh
ssh root@$(hcloud server ip spark-master)
```
Then run:
```sh
env | grep SPARK
```
✅ You should see:
```
SPARK_MASTER_HOST=spark-master
SPARK_MASTER_URL=spark://spark-master:7077
```

---

## **🔍 Troubleshooting**

### **Common Issues & Solutions**

#### **1️⃣ Spark Master or Worker Failing to Start**
**Error:** `Failed to connect to master at spark://spark-master:7077`
- Ensure that the **Spark master service is running**.
- Verify that the **network settings allow communication** between Spark master and workers.
- Check logs using:
  ```sh
  docker logs spark-master
  kubectl logs -n bigdata-query <spark-master-pod>
  ```

#### **2️⃣ No Applications Showing in Spark UI**
**Possible Causes & Fixes:**
- Check if **event logging is enabled**:
  ```sh
  kubectl exec -it <spark-master-pod> -n bigdata-query -- cat /opt/spark/conf/spark-defaults.conf | grep eventLog
  ```
- Ensure the **log directory is writable** and accessible to the Spark user.

#### **3️⃣ High Memory Usage or Worker Crashes**
- Verify that **worker memory and core limits** match available resources.
- Check logs for `OutOfMemoryError` or resource exhaustion.
- Adjust Spark memory settings in `values.yaml` or `.env`:
  ```yaml
  SPARK_WORKER_MEMORY=8G
  SPARK_EXECUTOR_MEMORY=6G
  ```

#### **4️⃣ Connection Issues Between Spark and External Query Engines**
- Ensure that **Presto, Trino, or Delta Lake are reachable** from Spark.
- Validate network settings and make sure all required services are in the same **Kubernetes namespace**.

### **General Debugging Steps**

### **1️⃣ Check Logs**
```sh
docker logs spark-master
kubectl logs -n bigdata-query <spark-master-pod>
```

### **2️⃣ Check Cluster Status**
```sh
kubectl get pods -n bigdata-query -o wide
```

### **3️⃣ Restart Services**
```sh
docker-compose restart spark-master
kubectl rollout restart deployment spark-master -n bigdata-query
```

### **1️⃣ Check Logs**
```sh
docker logs spark-master
kubectl logs -n bigdata-query <spark-master-pod>
```

### **2️⃣ Check Cluster Status**
```sh
kubectl get pods -n bigdata-query -o wide
```

### **3️⃣ Restart Services**
```sh
docker-compose restart spark-master
kubectl rollout restart deployment spark-master -n bigdata-query
```

---

## **📌 Summary**
| **Deployment Type** | **Command** |
|------------------|------------|
| **Docker Compose (local)** | `docker-compose up -d` |
| **Helm (Kubernetes - Dev)** | `helmfile -e dev apply` |
| **Helm (Kubernetes - Prod)** | `helmfile -e prod apply` |
| **Terraform (Hetzner)** | `terraform apply -auto-approve` |

✅ **Spark is now fully documented and ready for deployment!** 🚀


