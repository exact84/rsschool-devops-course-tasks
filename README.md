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
- `repo_fullname` — репозиторий

---

## MFA

В IAM-консоли создан пользователь с включённой многофакторной аутентификацией (MFA).

---

## Структура проекта

terraform-proj/  
├── backend.tf  
├── iam-role.tf  
├── variables.tf  
└── .github/  
    └── workflows/  
        └── deploy.yml  