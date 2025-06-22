## Homework 4

### Опис завдання

1. Створіть власний проєкт, що включає:

Django — для вебзастосунку.
PostgreSQL — для збереження даних.
Nginx — для обробки запитів.

2. Використайте Docker і Docker Compose для контейнеризації всіх сервісів.

3. Запуште проєкт у свій репозиторій на GitHub для перевірки.

### Кроки виконання завдання:

1. Створіть структуру проєкту Django в Docker

Ініціалізуйте новий Django-проєкт (назва проєкту на ваш вибір).
Налаштуйте PostgreSQL як базу даних.
Додайте Nginx для проксирування трафіку.

2. Створіть Dockerfile для Django

Ваш Dockerfile повинен:

Використовувати образ Python 3.9 або новіший.
Встановлювати всі необхідні залежності з requirements.txt.
Запускати Django-сервер у контейнері.

3. Створіть docker-compose.yml

У docker-compose.yml опишіть усі три сервіси:

web — Django-застосунок.
db — PostgreSQL для збереження даних.
nginx — вебсервер для обробки запитів.
Налаштуйте Nginx

Створіть файл nginx.conf у папці nginx з таким вмістом:

```
server {
listen 80;

    location / {
        proxy_pass <http://django:8000>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

}
```

4. Протестуйте проєкт локально

Запустіть проєкт за допомогою команди:

docker-compose up -d

Переконайтеся, що:

◦ Вебзастосунок доступний за адресою http://localhost.

◦ Підключення до бази даних PostgreSQL працює.

5. Запуште проєкт у GitHub

Створіть нову гілку lesson-4 у вашому репозиторії.
Завантажте всі файли вашого проєкту в репозиторій.
Використовуйте такі команди для завантаження змін:
git checkout -b lesson-4
git add .
git commit -m "Add Dockerized Django project with PostgreSQL and Nginx"
git push origin lesson-4

## Критерії прийняття домашнього завдання:

1. Створено проєкт Django+PostgreSQL+Nginx у Docker.

2. Усі сервіси описані в docker-compose.yml.

3. Dockerfile для Django налаштований згідно зі вказаними вище вимогами.

4. Nginx працює як вебсервер для проксирування запитів.

5. Проєкт успішно запускається локально командою docker-compose up.

6. Код проєкту завантажено в репозиторій GitHub у гілку lesson-4.
