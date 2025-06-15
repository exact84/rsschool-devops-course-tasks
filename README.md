# Terraform GitHub Actions Infrastructure

## Описание

Инфраструктура создаёт:
- IAM роль (`GithubActionsRole`) для GitHub Actions с OIDC
- CI/CD pipeline через GitHub Actions

---

## Переменные
описаны в variables.tf и храняться в Github Actions secrets

- `role_name` — имя IAM роли для GitHub Actions
- `aws_account_id` — ID AWS аккаунта
- `repo_fullname` — репозиторий в формате `owner/repo`
- `aws_region` — регион AWS

---

## Использование

Инфраструктура разворачивается автоматически через GitHub Actions.
Файл workflow: `.github/workflows/deploy.yml`.

Для локальной проверки и отладки вы можете использовать Terraform вручную:
1. Склонируйте репозиторий

2. Установите переменные окружения

3. Инициализируйте Terraform:  
terraform init

4. Проверьте план:  
terraform plan

5. Примените инфраструктуру:  
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