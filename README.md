# Terraform GitHub Actions Infrastructure

## Описание

Инфраструктура создаёт:
- IAM роль (`GithubActionsRole`) для GitHub Actions с OIDC
- S3 bucket для хранения Terraform состояния
- CI/CD pipeline через GitHub Actions

---

## Переменные

- `role_name` — имя IAM роли для GitHub Actions
- `aws_account_id` — ID AWS аккаунта
- `repo_fullname` — репозиторий в формате `owner/repo`
- `aws_region` — регион AWS

---

## Использование

1. Склонируйте репозиторий
2. Инициализируйте Terraform:  
terraform init

3. Проверьте план:  
terraform plan

4. Примените инфраструктуру:  
terraform apply

## MFA

В IAM-консоли создан пользователь с включённой многофакторной аутентификацией (MFA).

---

## Структура проекта

terraform-proj/  
├─ backend.tf  
├─ iam-role.tf  
├─ variables.tf  
└─ .github/  
&nbsp;&nbsp;&nbsp;&nbsp;   └─ workflows/  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        └─ deploy.yml  