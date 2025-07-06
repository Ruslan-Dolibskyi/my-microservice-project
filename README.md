# Практичне завдання: Terraform + EKS (Лекція 6)

Цей проєкт демонструє, як з допомогою Terraform створити:
- S3-бакет та DynamoDB для збереження стану (State Backend)
- VPC з публічними та приватними підмережами
- ECR репозиторій для зберігання Docker-образів
- EKS (Elastic Kubernetes Service) кластер разом із групою воркер-нодів

---

## 📂 Структура проєкту

```
lesson-6/
├── main.tf
├── backend.tf
├── outputs.tf
├── variables.tf        # (опціонально для region, якщо використовуєте var.region)
├── README.md
└── modules/
├── s3-backend/
│   ├── s3.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   └── outputs.tf
├── vpc/
│   ├── vpc.tf
│   ├── routes.tf
│   ├── variables.tf
│   └── outputs.tf
├── ecr/
│   ├── ecr.tf
│   ├── variables.tf
│   └── outputs.tf
└── eks/
├── eks.tf
├── node.tf
├── variables.tf
└── outputs.tf

```