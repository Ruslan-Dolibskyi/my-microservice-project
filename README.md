# Фінальне завдання: Розгортання інфраструктури DevOps на AWS

## Основна мета фінального проєкту:

На основі виконаних домашніх завдань з цієї дисципліни, вам необхідно зібрати та розгорнути повну інфраструктуру DevOps на AWS з використанням Terraform, що включає наступні компоненти:

- Розгортання Kubernetes кластера (EKS) з підтримкою CI/CD
- Інтеграція Jenkins для автоматизації збірки та деплою
- Інсталяція Argo CD для управління застосунками
- Налаштування бази даних (RDS або Aurora)
- Організація контейнерного реєстру (ECR)
- Моніторинг з Prometheus та Grafana

## Завдання передбачає наступне:

- Перевірити готовність всіх компонентів на основі створеної інфраструктури.
- Зібрати всі модулі Terraform та перевірити коректність їх налаштування.
- Запустити розгортання за допомогою команди:

```
terraform apply
```

- Переконатися в доступності основних сервісів через порт-форвардинг.
- Продемонструвати роботу CI/CD за допомогою Jenkins та Argo CD.
- Перевірити моніторинг за допомогою Grafana та Prometheus.
---

## 📋 Передумови

- Встановлені:
  - [Terraform ≥ 1.6](https://terraform.io/downloads)
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/)
  - [Helm 3](https://helm.sh/docs/intro/install/)
- Налаштований AWS профіль із правами:
  - S3, DynamoDB (для бекенду Terraform)
  - VPC, EC2, IAM, ECR, EKS
- У консолі:
  ```bash
  aws configure
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, default region → ap-southeast-1

## 🗂️ Структура проєкту

```
my-microservice-project/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   ├── jenkins/
│   ├── monitoring/
│   └── argo_cd/
└── charts/
    └── django-app/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            ├── configmap.yaml
            └── hpa.yaml
```

Кожен модуль виконує:
- `s3-backend` — налаштування S3-бакету та DynamoDB для зберігання стану Terraform.
- `vpc` — створення VPC, підмереж, маршрутизації та Internet Gateway.
- `ecr` — створення ECR-репозиторію для Docker-образів.
- `eks` — розгортання EKS-кластера та CSI-драйверів.
- `rds` — модуль для створення Amazon RDS або Aurora (PostgreSQL/MySQL).
- `monitoring` — модуль для моніторингу з Prometheus та Grafana.  
- `jenkins` — модуль для встановлення Jenkins через Helm з JCasC та IRSA.
- `argo_cd` — модуль для встановлення Argo CD через Helm та створення Application-карт.
- `charts/django-app` — Helm-чарт для деплою Django-додатку (Deployment, Service, ConfigMap, HPA).

## 🚀 Крок 1. Ініціалізація Terraform

1.	Ініціалізуйте бекенд і модулі:

⚠️ Щоб уникнути помилок типу `NoSuchBucket` або `AccessDenied`, дотримуйтесь цієї послідовності:

**Перед першим запуском** — `закоментуйте` або `перейменуйте` файл `backend.tf`.
```
terraform init
```

2.	Перевірте план:
```
terraform plan
```
3.	Застосуйте зміни:
```
terraform apply
```
`# введіть "yes" для підтвердження`

## 🐳 Крок 2. Збірка і завантаження Docker-образу
1.	Авторизуйтесь в ECR:
```
aws ecr get-login-password \
  --region ap-southeast-1 \
| docker login --username AWS --password-stdin $(terraform output -raw ecr_repo_url)
```

2.	Зберіть образ:
```
docker build -t django-app ./django
```

3.	Присвойте тег і запуште:
```
docker tag django-app:latest \
  $(terraform output -raw ecr_repo_url):latest

docker push $(terraform output -raw ecr_repo_url):latest
```

## 🔐 Авторизація до ECR (imagePullSecrets)

Якщо ваш ECR-репозиторій приватний, створіть Kubernetes Secret для доступу:

```bash
kubectl create secret docker-registry ecr-registry \
  --docker-server=$(terraform output -raw ecr_repo_url) \
  --docker-username AWS \
  --docker-password=$(aws ecr get-login-password --region ap-southeast-1) \
  --docker-email=you@example.com
```

Переконайтеся, що в `charts/django-app/templates/deployment.yaml` є блок:

```yaml
    spec:
      imagePullSecrets:
        - name: ecr-registry
```

## 🔧 Крок 3. Підключення до EKS

Отримайте kubeconfig і перевірте ноди:
```
aws eks update-kubeconfig \
  --region ap-southeast-1 \
  --name $(terraform output -raw eks_cluster_name)

kubectl get nodes
```

## 🏗️ Крок 4. Розгортання Helm-чарту
1.	Перейдіть у каталог чарта:
```
cd charts/django-app
```

2.	Встановіть чарт:
```
helm install django-app .
```

3.	(Після змін) Оновіть чарт:
```
helm upgrade django-app .
```

## 🔎 Перевірка
-	Ноди
``` 
kubectl get nodes
```

- Deployment & Pods
```
kubectl get deployments
kubectl get pods
```

- Service
```
kubectl get svc
```
`# знайдіть EXTERNAL-IP для доступу`

- HPA
```
kubectl get hpa
```

- ConfigMap
```
kubectl describe configmap django-app-config
```



## 🚀 Етапи виконання

1. Підготовка середовища:
   - Ініціалізувати Terraform.
   - Перевірити всі необхідні змінні та параметри.
2. Розгортання інфраструктури:
   - Виконати команду розгортання:
     ```
     terraform apply
     ```
   - Перевірити стан ресурсів через:
     ```
     kubectl get all -n jenkins
     kubectl get all -n argocd
     kubectl get all -n monitoring
     ```
3. Перевірка доступності:
   - Jenkins:
     ```
     kubectl port-forward svc/jenkins 8080:8080 -n jenkins
     ```
   - Argo CD:
     ```
     kubectl port-forward svc/argocd-server 8081:443 -n argocd
     ```
4. Моніторинг та перевірка метрик:
   - Grafana:
     ```
     kubectl port-forward svc/grafana 3000:80 -n monitoring
     ```
   - Перевірити стан метрик в Grafana Dashboard.


- **Metrics-server**  
  Якщо HPA показує `<unknown>/70%`, встановіть metrics-server:

  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```
  Або через Helm:
  ```bash
  helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
  helm install metrics-server metrics-server/metrics-server \
    --namespace kube-system \
    --set args={--kubelet-insecure-tls}
  ```
  Почекайте ~1 хв, потім перевірте `kubectl get hpa django-app-hpa`.
