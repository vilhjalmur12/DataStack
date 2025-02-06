# **PostgreSQL Service Documentation**

## **📌 General Information**
This document provides an overview of the **PostgreSQL service** setup within the **Big Data Stack**. It includes details on **environment variables, system requirements, and deployment methods** using both **Docker Compose (for development)** and **Helm (for Kubernetes in production).**

PostgreSQL is used as the **core relational database** for structured data processing and metadata storage. The setup is optimized for **security, performance, and scalability** across both **development** and **production** environments.

---

## **⚙️ Environment Variables**
The PostgreSQL service is configured using **`.env` files** to manage database credentials and storage locations securely.

### **Global Environment Variables (Defined in `DataStack/.env`)**
```ini
GLOBAL_NETWORK=bigdata_network
POSTGRES_MOUNT_LOCATION=/mnt/bigdata/postgres
```

### **PostgreSQL-Specific Environment Variables (Defined in `services/postgres/.env`)**
```ini
POSTGRES_ROOT_PASSWORD_FILE=secrets/postgres_root_password.txt
POSTGRES_PASSWORD_FILE=secrets/postgres_user_password.txt
POSTGRES_READONLY_PASSWORD_FILE=secrets/postgres_readonly_password.txt
POSTGRES_DATABASE=mydatabase
POSTGRES_USER=myuser
POSTGRES_READONLY_USER=myreadonlyuser
```
---

## **💻 System Requirements**

### **Development (Docker Compose Setup)**
| Component  | Recommended |
|------------|------------|
| CPU        | 4+ cores |
| RAM        | 16GB+ |
| Storage    | 100GB+ SSD |
| OS         | Linux/macOS/Windows (WSL2 recommended for Windows) |
| Network    | Stable internet connection |

### **Production (Kubernetes Setup - Hetzner Cloud)**
| Component  | Recommended |
|------------|------------|
| CPU        | 8+ cores |
| RAM        | 32GB+ |
| Storage    | 500GB+ SSD (scalable) |
| OS         | Linux (Ubuntu/Debian/RHEL) |
| Kubernetes Cluster | 3+ nodes |
| Network    | High-speed internal network |

---

## **🚀 Using the Docker Compose Setup**

### **1️⃣ Start the PostgreSQL Service Locally**
```sh
docker-compose -f services/postgres/docker-compose.yml up -d
```

### **2️⃣ Stop the PostgreSQL Service**
```sh
docker-compose -f services/postgres/docker-compose.yml down
```

### **3️⃣ Verify PostgreSQL is Running**
```sh
docker ps | grep postgres
```

### **4️⃣ Connect to PostgreSQL Using CLI**
```sh
docker exec -it postgres psql -U myuser -d mydatabase
```

✅ **Benefit:** The Docker Compose setup provides a **quick local PostgreSQL instance** for development and testing.

---

## **☸️ Using the Helm Chart for Kubernetes Deployment**

### **1️⃣ Deploy PostgreSQL in the Development Cluster (Minikube or Local K8s)**
```sh
helm install postgres helm-charts/postgres/ --namespace bigdata-core --values environments/dev.yaml
```

### **2️⃣ Deploy PostgreSQL in the Production Cluster (Hetzner Kubernetes)**
```sh
helm install postgres helm-charts/postgres/ --namespace bigdata-core --values environments/prod.yaml
```

### **3️⃣ Verify PostgreSQL Pod is Running**
```sh
kubectl get pods -n bigdata-core
```

### **4️⃣ Retrieve PostgreSQL Service Details**
```sh
kubectl get svc -n bigdata-core postgres
```

### **5️⃣ Uninstall PostgreSQL from Kubernetes**
```sh
helm uninstall postgres -n bigdata-core
```

✅ **Benefit:** The **Helm deployment** ensures **scalability, persistent storage, and secure access** in a Kubernetes environment.

---

## **🔄 Backup & Restore**

### **1️⃣ Manually Trigger a Backup (Docker Compose)**
```sh
docker exec postgres pg_dump -U myuser -d mydatabase > backup.sql
```

### **2️⃣ Restore PostgreSQL from a Backup**
```sh
docker exec -i postgres psql -U myuser -d mydatabase < backup.sql
```

### **3️⃣ Kubernetes: Restore from a Backup**
```sh
kubectl cp backup.sql postgres-pod:/backup.sql -n bigdata-core
kubectl exec -it postgres-pod -n bigdata-core -- psql -U myuser -d mydatabase < /backup.sql
```

✅ **Benefit:** Ensures **data recovery in case of failures**.

---

## **☁️ Terraform Deployment**

### **1️⃣ Provision PostgreSQL Infrastructure on Hetzner**
```sh
cd terraform/hetzner
terraform init
terraform apply
```

### **2️⃣ Retrieve PostgreSQL Server IP**
```sh
echo "PostgreSQL Server IP: $(terraform output postgres_ip)"
```

### **3️⃣ Destroy Infrastructure if Needed**
```sh
terraform destroy
```
✅ **Benefit:** Automates **cloud-based PostgreSQL provisioning**.

---

## **💾 Storage Scaling & Performance**

### **Expand PVC Storage in Kubernetes**
```sh
kubectl patch pvc postgres-pvc -n bigdata-core --patch '{"spec":{"resources":{"requests":{"storage":"100Gi"}}}}'
```
✅ **Benefit:** Ensures **PostgreSQL has enough disk space**.

---

## **🔒 Security Best Practices**

### **Rotate PostgreSQL Passwords Securely**
```sh
echo "newpassword" | kubectl create secret generic postgres-secret --from-file=postgres-password=/dev/stdin -n bigdata-core --dry-run=client -o yaml | kubectl apply -f -
```
✅ **Benefit:** Secure **password updates without service downtime**.

### **Firewall Rules for Secure PostgreSQL Access**
- **Docker:** Restrict external access using `pg_hba.conf`
- **Kubernetes:** Apply `NetworkPolicies` to limit access.

---

## **📊 Monitoring & Logging**

### **Monitor PostgreSQL with Prometheus**
```sh
helm install postgres-exporter prometheus-community/postgres-exporter -n bigdata-monitoring
```
✅ **Benefit:** Collects **PostgreSQL metrics for performance analysis**.

### **Enable Slow Query Logging & Send Logs to ELK**
```sql
ALTER SYSTEM SET log_min_duration_statement = 1000;
SELECT pg_reload_conf();
```
✅ **Benefit:** Helps in **identifying slow queries & optimizing performance**.

---

## **📜 Conclusion**
This documentation provides the complete setup and deployment guide for **PostgreSQL** within the Big Data Stack. The **Docker Compose** method is optimized for **local development**, while the **Helm setup** is designed for **Kubernetes-based production environments**. Secure **secrets management, resource optimization, backup automation, and monitoring** ensure **high availability and reliability**.

For further inquiries or troubleshooting, refer to the **main project documentation** or contact the **infrastructure team**. 🚀

