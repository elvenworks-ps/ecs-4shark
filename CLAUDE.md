# 4Shark Terraform Infrastructure

## Visão Geral

Infraestrutura AWS para 4Shark usando Terraform. Cluster ECS com EC2, ALB interno, Blue/Green deployments.

## Estrutura

```
terraform/
├── modules/           # vpc, vpc_data, ecs_cluster, ecs_service, internal_alb, ecr
├── poc/               # Ambiente POC (tfstateecs4shark-poc)
├── beta/              # Ambiente Beta (tfstateecs4shark-beta)
├── demo/              # Ambiente Demo (tfstateecs4shark-demo)
├── shared/            # Ambiente Shared (tfstateecs4shark-shared)
└── atento/            # Ambiente Atento (tfstateecs4shark-atento)
```

## Serviços ECS (por ambiente)

| Serviço | Porta | CPU/Mem |
|---------|-------|---------|
| `{env}-001-web` | 3000 | 2048/2048 |
| `{env}-001-worker-commission` | - | 2048/2048 |
| `{env}-001-worker-system` | 3000 | 2048/2048 |
| `{env}-001-worker-user` | - | 2048/2048 |
| `{env}-001-worker-migration` | - | 2048/2048 |
| `{env}-001-worker-cleansing` | - | 2048/2048 |
| `{env}-001-worker-commission-tiger-shark` | - | 2048/2048 |
| `{env}-001-worker-commission-white-shark` | - | 2048/2048 |

## Comandos

```bash
cd {ambiente}
terraform init
terraform plan -var-file="{ambiente}.tfvars"
terraform apply -var-file="{ambiente}.tfvars"
```

---

## IAM - app-staging (GitHub Actions)

O usuário `app-staging` é usado pelo GitHub Actions para deploy. As permissões são gerenciadas via Terraform em `{ambiente}/iam.tf`.

### Permissões Necessárias

```hcl
# ECR - Push de imagens
ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:GetDownloadUrlForLayer,
ecr:BatchGetImage, ecr:InitiateLayerUpload, ecr:UploadLayerPart, ecr:CompleteLayerUpload, ecr:PutImage

# ECS Task Definitions
ecs:RegisterTaskDefinition, ecs:DescribeTaskDefinition, ecs:ListTaskDefinitions

# ECS Cluster/Services/Tasks
ecs:DescribeClusters, ecs:DescribeServices, ecs:UpdateService, ecs:ListServices,
ecs:ListTasks, ecs:DescribeTasks, ecs:DescribeContainerInstances

# ALB (para health checks)
elasticloadbalancing:Describe*

# CloudWatch Logs
logs:CreateLogStream, logs:PutLogEvents

# IAM PassRole (para ECS assumir roles)
iam:PassRole (para ecsTaskExecutionRole)

# CodeDeploy (Blue/Green)
codedeploy:CreateDeployment, codedeploy:GetDeployment, codedeploy:GetDeploymentConfig,
codedeploy:GetDeploymentGroup, codedeploy:RegisterApplicationRevision, codedeploy:StopDeployment,
codedeploy:ContinueDeployment, codedeploy:GetApplication
```

### Recursos Permitidos (POC)

- `arn:aws:ecs:us-east-1:405749097490:cluster/poc-001-cluster`
- `arn:aws:ecs:us-east-1:405749097490:service/poc-001-cluster/*`
- `arn:aws:ecs:us-east-1:405749097490:task/poc-001-cluster/*`
- `arn:aws:ecs:us-east-1:405749097490:container-instance/poc-001-cluster/*`
- `arn:aws:ecr:us-east-1:405749097490:repository/poc-*`

---

## Circuit Breaker e Rollback Automático

### Configuração

Todos os serviços ECS têm circuit breaker habilitado para rollback automático em caso de falha no deployment.

```hcl
# Em main.tf do ambiente
enable_deployment_circuit_breaker = true
deployment_rollback               = true
```

### Como Funciona

1. ECS monitora o deployment
2. Se tasks falharem repetidamente → deployment marcado como FAILED
3. Circuit breaker ativa rollback automático para versão anterior
4. Serviço volta a funcionar com a última versão estável

### Verificar Status

```bash
aws ecs describe-services --cluster {env}-001-cluster --services {service} \
  --query 'services[0].deploymentConfiguration.deploymentCircuitBreaker'
```

---

## Deploy Blue/Green com CodeDeploy (POC)

### Arquitetura

O serviço web (`poc-001-web-service`) usa **CodeDeploy** para Blue/Green deployment com rollback automático.

### Componentes

| Recurso | Nome | Descrição |
|---------|------|-----------|
| CodeDeploy App | `poc-001-web-app` | Aplicação CodeDeploy |
| Deployment Group | `poc-001-web-dg` | Grupo de deployment |
| IAM Role | `poc-001-codedeploy-role` | Role para CodeDeploy |
| Target Groups | `poc-001-app-tg` / `poc-001-app-alt-tg` | Blue/Green TGs |

### Fluxo do Deploy

```
1. Pipeline cria nova Task Definition
2. Pipeline chama CodeDeploy CreateDeployment com AppSpec
3. CodeDeploy registra tasks no Green TG (alternate)
4. ALB health check valida novas tasks
5. CodeDeploy faz traffic shift (Blue → Green)
6. Após 5min (termination_wait), tasks antigas são terminadas
```

### Rollback Automático

CodeDeploy faz rollback automático se:
- `DEPLOYMENT_FAILURE` - Tasks não ficam healthy
- `DEPLOYMENT_STOP_ON_REQUEST` - Deploy cancelado manualmente

### Configuração Terraform

```hcl
# Em poc/codedeploy.tf
deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

auto_rollback_configuration {
  enabled = true
  events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_REQUEST"]
}

terminate_blue_instances_on_deployment_success {
  action                           = "TERMINATE"
  termination_wait_time_in_minutes = 5
}
```

### AppSpec para Pipeline

```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "arn:aws:ecs:us-east-1:405749097490:task-definition/poc-001-web:TASK_DEF_VERSION"
        LoadBalancerInfo:
          ContainerName: "poc-001-web"
          ContainerPort: 3000
```

### Outputs para Pipeline

```bash
# Após terraform apply
terraform output codedeploy_app_name        # poc-001-web-app
terraform output codedeploy_deployment_group # poc-001-web-dg
```

---

## Workers (sem ALB)

Workers usam **ECS Circuit Breaker** para rollback (não CodeDeploy).

### Serviços

1. `{env}-001-worker-commission-service`
2. `{env}-001-worker-system-service`
3. `{env}-001-worker-user-service`
4. `{env}-001-worker-migration-service`
5. `{env}-001-worker-cleansing-service`
6. `{env}-001-worker-commission-tiger-shark-service`
7. `{env}-001-worker-commission-white-shark-service`

### Configuração

```hcl
enable_deployment_circuit_breaker = true
deployment_rollback               = true
```

---

## Troubleshooting

### Deployment Travado

```bash
# Ver status dos serviços
aws ecs describe-services --cluster {env}-001-cluster \
  --services {service} \
  --query 'services[*].{name:serviceName,desired:desiredCount,running:runningCount,status:deployments[0].rolloutState}'

# Ver capacidade do cluster (CPU disponível)
aws ecs describe-container-instances --cluster {env}-001-cluster \
  --container-instances $(aws ecs list-container-instances --cluster {env}-001-cluster --query 'containerInstanceArns' --output text) \
  --query 'containerInstances[*].{ec2:ec2InstanceId,cpu:remainingResources[?name==`CPU`].integerValue|[0]}'
```

### Forçar Atualização de Task Definition

```bash
# Criar nova versão idêntica
aws ecs describe-task-definition --task-definition {family}:N \
  --query 'taskDefinition.{family:family,containerDefinitions:containerDefinitions,cpu:cpu,memory:memory,networkMode:networkMode,executionRoleArn:executionRoleArn,taskRoleArn:taskRoleArn}' \
  > /tmp/task.json
aws ecs register-task-definition --cli-input-json file:///tmp/task.json

# Atualizar serviço
aws ecs update-service --cluster {env}-001-cluster --service {service} \
  --task-definition {family}:N --force-new-deployment
```

### Rollback Manual (Workers)

```bash
aws ecs update-service --cluster {env}-001-cluster --service {service} \
  --task-definition {family}:{versao-anterior} --force-new-deployment
```

### Rollback Manual (Web - CodeDeploy)

```bash
# Parar deployment em andamento
aws deploy stop-deployment --deployment-id {deployment-id}

# Ou criar novo deployment com versão anterior
aws deploy create-deployment \
  --application-name poc-001-web-app \
  --deployment-group-name poc-001-web-dg \
  --revision '{"revisionType":"AppSpecContent","appSpecContent":{"content":"{...}"}}'
```

### Ver Status CodeDeploy

```bash
aws deploy get-deployment --deployment-id {deployment-id} \
  --query 'deploymentInfo.{status:status,errorInfo:errorInformation}'
```

---

## Capacidade do Cluster

Cada instância `t3a.medium` = 2048 CPU units (2 vCPU)
Cada task usa 2048 CPU = **1 task por instância**

| POC | Instâncias | Tasks Máx |
|-----|------------|-----------|
| ASG | 8 | 8 |

Para rodar 8 serviços simultaneamente, precisa de no mínimo 8 instâncias.

---

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado
- Account: 405749097490
- Região: us-east-1
- Key Pair: 4Shark-key
- Route53 Zone: 4shark.internal
