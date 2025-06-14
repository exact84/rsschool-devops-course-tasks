# Terraform GitHub Actions Infrastructure

## Описание

Инфраструктура создаёт:
- IAM роль (`GithubActionsRole`) для GitHub Actions с OIDC
- S3 bucket для хранения Terraform состояния
- CI/CD pipeline через GitHub Actions

---

## Переменные

- `backend_bucket` — имя S3 бакета
- `backend_key` — путь к `.tfstate`
- `aws_account_id` — ID твоего AWS аккаунта
- `repo_fullname` — `owner/repo`

---

## MFA

В IAM-консоли создан пользователь с включённой многофакторной аутентификацией (MFA).

---

## Структура проекта

terraform-proj/  
├── main.tf  
├── backend.tf  
├── iam-role.tf  
├── variables.tf  
└── .github/  
    └── workflows/  
        └── deploy.yml  