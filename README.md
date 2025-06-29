# Terraform AWS Infrastructure — Lesson 5

Цей проєкт створює базову інфраструктуру в AWS за допомогою Terraform. Він включає:

- 🔐 S3 + DynamoDB для зберігання стейтів
- 🌐 VPC з публічними та приватними підмережами
- 🐳 ECR для зберігання Docker-образів

---

## 📁 Структура проєкту
```
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── README.md
└── modules/
├── s3-backend/
│ ├── s3.tf
│ ├── dynamodb.tf
│ ├── variables.tf
│ └── outputs.tf
├── vpc/
│ ├── vpc.tf
│ ├── routes.tf
│ ├── variables.tf
│ └── outputs.tf
└── ecr/
├── ecr.tf
├── variables.tf
└── outputs.tf
```


---

## 🛠️ Команди для запуску

```bash
terraform init    # Ініціалізація бекенду та провайдерів
terraform plan    # Перевірка змін
terraform apply   # Створення ресурсів
terraform destroy # Видалення всіх ресурсів

```

## ⚠️ Важливо: Робота з Terraform backend (S3 + DynamoDB)

Terraform не може автоматично створити S3-бакет або DynamoDB-таблицю для бекенду, якщо вони вже вказані в `backend.tf`.

Щоб уникнути помилок типу `NoSuchBucket` або `AccessDenied`, дотримуйтесь цієї послідовності:

1. **Перед першим запуском** — закоментуйте або перейменуйте файл `backend.tf`.
2. Запустіть:
   ```bash
   terraform init
   terraform apply
Це створить усі ресурси, включаючи S3 і DynamoDB.
3. Після успішного apply, поверніть файл backend.tf назад (або розкоментуйте).
4. Запустіть:

bash
Копіювати
Редагувати
terraform init -reconfigure
Погодьтесь на перенесення локального стану до бекенду (yes).

📦 Після цього Terraform зберігатиме terraform.tfstate у S3 і використовуватиме DynamoDB для блокування змін.

при terraform destroy
s3 baket потрібно видаляти в ручну на AWS сайті.
