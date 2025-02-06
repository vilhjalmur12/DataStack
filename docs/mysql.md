# **MySQL Service Documentation**

## **📌 General Information**
This document provides an overview of the **MySQL service** setup within the **Big Data Stack**. It includes details on **environment variables, system requirements, and deployment methods** using both **Docker Compose (for development)** and **Helm (for Kubernetes in production).**

MySQL is used as the **core relational database** for metadata storage and structured data processing. The setup is optimized for security, performance, and scalability across **development** and **production** environments.

---

## **⚙️ Environment Variables**
The MySQL service is configured using **`.env` files** to manage database credentials and storage locations securely.

### **Global Environment Variables (Defined in `DataStack/.env`)**
```ini
GLOBAL_NETWORK=bigdata_network
MYSQL_MOUNT_LOCATION=/mnt/bigdata/mysql
```

### **MySQL-Specific Environment Variables (Defined in `services/mysql/.env`)**
```ini
MYSQL_ROOT_PASSWORD_FILE=secrets/mysql_root_password.txt
MYSQL_PASSWORD_FILE=secrets/mysql_user_password.txt
MYSQL_READONLY_PASSWORD_FILE=secrets/mysql_readonly_password.txt
MYSQL_DATABASE=mydatabase
MYSQL_USER=myuser
MYSQL_READONLY_USER=myreadonlyuser
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

### **1️⃣ Start the MySQL Service Locally**
```sh
docker-compose -f services/mysql/docker-compose.yml up -d
```

### **2️⃣ Stop the MySQL Service**
```sh
docker-compose -f services/mysql/docker-compose.yml down
```

### **3️⃣ Verify MySQL is Running**
```sh
docker ps | grep mysql
```

### **4️⃣ Connect to MySQL Using CLI**
```sh
docker exec -it mysql mysql -u myuser -p
```

✅ **Benefit:** The Docker Compose setup provides a **quick local MySQL instance** for development and testing.

---

## **☸️ Using the Helm Chart for Kubernetes Deployment**

### **1️⃣ Deploy MySQL in the Development Cluster (Minikube or Local K8s)**
```sh
helm install mysql helm-charts/mysql/ --namespace bigdata-core --values environments/dev.yaml
```

### **2️⃣ Deploy MySQL in the Production Cluster (Hetzner Kubernetes)**
```sh
helm install mysql helm-charts/mysql/ --namespace bigdata-core --values environments/prod.yaml
```

### **3️⃣ Verify MySQL Pod is Running**
```sh
kubectl get pods -n bigdata-core
```

### **4️⃣ Retrieve MySQL Service Details**
```sh
kubectl get svc -n bigdata-core mysql
```

### **5️⃣ Uninstall MySQL from Kubernetes**
```sh
helm uninstall mysql -n bigdata-core
```

✅ **Benefit:** The **Helm deployment** ensures **scalability, persistent storage, and secure access** in a Kubernetes environment.

---

## **🔄 Backup & Restore**

### **1️⃣ Manually Trigger a Backup (Docker Compose)**
```sh
docker exec mysql mysqldump -u root -p$(cat ./secrets/mysql_root_password.txt) mydatabase > backup.sql
```

### **2️⃣ Restore MySQL from a Backup**
```sh
docker exec -i mysql mysql -u root -p$(cat ./secrets/mysql_root_password.txt) mydatabase < backup.sql
```

### **3️⃣ Kubernetes: Restore from a Backup**
```sh
kubectl cp backup.sql mysql-pod:/backup.sql -n bigdata-core
kubectl exec -it mysql-pod -n bigdata-core -- mysql -u root -p$(kubectl get secret mysql-secret -o jsonpath='{.data.root-password}' | base64 --decode) mydatabase < /backup.sql
```

✅ **Benefit:** Ensures **data recovery in case of failures**.

---

## **☁️ Terraform Deployment**

### **1️⃣ Provision MySQL Infrastructure on Hetzner**
```sh
cd terraform/hetzner
terraform init
terraform apply
```

### **2️⃣ Retrieve MySQL Server IP**
```sh
echo "MySQL Server IP: $(terraform output mysql_ip)"
```

### **3️⃣ Destroy Infrastructure if Needed**
```sh
terraform destroy
```
✅ **Benefit:** Automates **cloud-based MySQL provisioning**.

---

## **💾 Storage Scaling & Performance**

### **Expand PVC Storage in Kubernetes**
```sh
kubectl patch pvc mysql-pvc -n bigdata-core --patch '{"spec":{"resources":{"requests":{"storage":"100Gi"}}}}'
```
✅ **Benefit:** Ensures **MySQL has enough disk space**.

---

## **🔒 Security Best Practices**

### **Rotate MySQL Passwords Securely**
```sh
echo "newpassword" | kubectl create secret generic mysql-secret --from-file=root-password=/dev/stdin -n bigdata-core --dry-run=client -o yaml | kubectl apply -f -
```
✅ **Benefit:** Secure **password updates without service downtime**.

### **Firewall Rules for Secure MySQL Access**
- **Docker:** Use `MYSQL_ALLOW_REMOTE=false`
- **Kubernetes:** Apply `NetworkPolicies` to limit access.

---

## **📊 Monitoring & Logging**

### **Monitor MySQL with Prometheus**
```sh
helm install mysql-exporter prometheus-community/mysqld-exporter -n bigdata-monitoring
```
✅ **Benefit:** Collects **MySQL metrics for performance analysis**.

### **Enable Slow Query Logging & Send Logs to ELK**
```sql
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;
```
✅ **Benefit:** Helps in **identifying slow queries & optimizing performance**.

---

## **📜 Conclusion**
This documentation provides the complete setup and deployment guide for **MySQL** within the Big Data Stack. The **Docker Compose** method is optimized for **local development**, while the **Helm setup** is designed for **Kubernetes-based production environments**. Secure **secrets management, resource optimization, backup automation, and monitoring** ensure **high availability and reliability**.

For further inquiries or troubleshooting, refer to the **main project documentation** or contact the **infrastructure team**. 🚀

