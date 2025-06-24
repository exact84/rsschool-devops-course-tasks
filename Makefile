.PHONY: bootstrap destroy-bootstrap

# создаёт S3 и DynamoDB
bootstrap:
	cd bootstrap && terraform init && terraform apply -auto-approve

# удаляет backend (S3 + DynamoDB)
destroy-bootstrap:
	cd bootstrap && terraform destroy -auto-approve
