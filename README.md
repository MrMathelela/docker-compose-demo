# 📦 Docker Compose Demo

A demo project showcasing **containerized application deployment** with **Docker Compose**, **Kubernetes manifests**, and **CI/CD pipelines**.
The core application is a lightweight **Go HTTP service (`mukuru-http.go`)**, built to demonstrate local development, containerization, and production deployment strategies.

---

## 🚀 Features

* **Go HTTP Service** (`src/mukuru-http.go`)
* **Dockerized Setup**

    * `Dockerfile` for building the service
    * `.dockerignore` to optimize build context
* **Environment Management** with `.env`
* **Local Orchestration** using `docker-compose.yml`
* **Kubernetes Deployment**

    * Complete manifests (`deployment`, `service`, `ingress`, `namespace`, `secret`)
    * TLS certificates (`k8s/certs/`)
    * Scripts for applying/removing resources
* **CI/CD Workflows** (GitHub Actions)

    * `docker-publish.yml` → Build & push Docker images
    * `trivy.yml` → Security scanning with Trivy
    * `codeql.yml` → Static analysis with CodeQL

---

## 📂 Project Structure

```plaintext
docker-compose-demo/
├── .dockerignore              # Ignore files for Docker builds
├── .env                       # Environment variables
├── .gitignore                 # Git ignore rules
├── Dockerfile                 # Application container build
├── docker-compose.yml          # Local service orchestration
├── src/mukuru-http.go         # Go web service
├── k8s/                       # Kubernetes manifests
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── namespace.yaml
│   ├── secret.yaml
│   ├── service.yaml
│   ├── certs/
│   │   ├── tls.crt
│   │   └── tls.key
│   └── scripts/
│       ├── apply_services.sh
│       └── delete_services.sh
└── .github/workflows/         # CI/CD pipelines
    ├── codeql.yml
    ├── docker-publish.yml
    └── trivy.yml
```

---

## 🛠️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/docker-compose-demo.git
cd docker-compose-demo
```

### 2. Run Locally with Docker Compose

```bash
docker-compose up --build
```

Application will be available at:
👉 [http://localhost:3000](http://localhost:3000)

### 3. Deploy to Kubernetes

#### Apply All Services

Use the provided script to apply namespace, deployment, service, ingress, and secrets:

```bash
bash k8s/scripts/apply_services.sh
```
Application will be available at:
👉[https://mukurur.go.local](https://mukurur.go.local)

#### Delete All Services

To clean up the cluster:

```bash
bash k8s/scripts/delete_services.sh
```

---

## 🔒 Security

* TLS enabled via `k8s/certs/tls.crt` and `k8s/certs/tls.key`
* Secrets defined in `k8s/secret.yaml`
* Vulnerability scanning with **Trivy** (`.github/workflows/trivy.yml`)
* Static analysis with **CodeQL**

---

## ⚡ CI/CD Pipelines

* **Docker Publish** → Builds and pushes Docker images
* **CodeQL Analysis** → Detects vulnerabilities in code
* **Trivy Security Scan** → Scans images for CVEs
