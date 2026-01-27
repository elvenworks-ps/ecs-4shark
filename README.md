# 4Shark ECS - Infraestrutura Terraform

Infraestrutura AWS para a plataforma 4Shark usando Terraform. Cluster ECS com EC2, ALB interno, Blue/Green deployments via CodeDeploy e CI/CD com GitHub Actions.

## Estrutura do Projeto

```
terraform/
├── modules/
│   ├── vpc/                  # Criação de VPC completa
│   ├── vpc_data/             # Lookup de VPC existente (data sources)
│   ├── ecs_cluster/          # Cluster ECS + ASG + Capacity Provider
│   ├── ecs_service/          # Task Definitions + ECS Services
│   ├── internal_alb/         # ALB interno + Target Groups + Route53
│   ├── ecr/                  # Repositórios ECR
│   ├── codedeploy/           # CodeDeploy Blue/Green para ECS
│   ├── iam_deploy/           # IAM policy para CI/CD (GitHub Actions)
│   └── asg-launch-template/  # Launch Template + ASG (alternativo)
├── poc/                      # Ambiente POC
├── atento/                   # Ambiente Atento
└── .github/
    ├── workflows/
    │   └── deploy-bluegreen-poc.yaml   # Pipeline Blue/Green POC
    └── actions/
        ├── deploy-ecs/                 # Action: build, push e deploy ECS
        └── deploy-bluegreen/           # Action: deploy transacional Blue/Green
```

## Modulos Terraform

### `vpc`

Cria uma VPC completa com subnets publicas/privadas, Internet Gateway, NAT Gateway e route tables.

| Recurso         | Descricao                      |
| --------------- | ------------------------------ |
| VPC             | CIDR configuravel, DNS support |
| Public Subnets  | Roteamento via IGW             |
| Private Subnets | Roteamento via NAT Gateway     |
| Flow Logs       | Opcional                       |

### `vpc_data`

Modulo de data source que faz lookup de uma VPC existente por nome (tag). Retorna VPC ID, subnets privadas e publicas. Usado pelo POC para reutilizar a VPC "Beta" existente.

### `ecs_cluster`

Cria o cluster ECS com instancias EC2 gerenciadas por Auto Scaling Group.

| Recurso                     | Descricao                                               |
| --------------------------- | ------------------------------------------------------- |
| ECS Cluster                 | Cluster principal                                       |
| Launch Template             | Configuracao EC2 com user_data para registro no cluster |
| Auto Scaling Group          | Gerencia instancias EC2 (instance refresh habilitado)   |
| Capacity Provider           | Vincula ASG ao cluster ECS                              |
| IAM Role + Instance Profile | Permissoes para EC2 se registrar no ECS                 |
| Security Group              | Permite trafego interno da VPC                          |
| Scaling Policies            | Scale up/down automatico                                |

### `ecs_service`

Cria Task Definitions e Services no ECS. Suporta dois modos de deployment:

- **ECS (rolling update)**: Para workers, com circuit breaker e rollback automatico.
- **CODE_DEPLOY**: Para o servico web, com Blue/Green via CodeDeploy.

| Recurso              | Descricao                                                            |
| -------------------- | -------------------------------------------------------------------- |
| CloudWatch Log Group | Logs centralizados (opcional)                                        |
| Task Definition      | Bridge network mode, volumes, env vars, secrets                      |
| ECS Service          | Capacity provider strategy, load balancer, health check grace period |

### `internal_alb`

Cria um ALB interno com target groups, listeners e registro DNS no Route53.

| Recurso              | Descricao                                  |
| -------------------- | ------------------------------------------ |
| ALB (interno)        | Em subnets privadas                        |
| Target Group (Blue)  | Target group principal                     |
| Target Group (Green) | Target group alternativo para Blue/Green   |
| HTTP Listener        | Regras de roteamento path-based            |
| Route53 CNAME        | DNS interno (ex: `poc001.4shark.internal`) |
| Security Group       | Ingress HTTP dos CIDRs permitidos          |

### `ecr`

Cria repositorios ECR com encriptacao AES256 e tags mutaveis.

### `codedeploy`

Configura CodeDeploy para deploy Blue/Green de servicos ECS.

| Recurso                | Descricao                                              |
| ---------------------- | ------------------------------------------------------ |
| CodeDeploy Application | Plataforma ECS                                         |
| Deployment Group       | Auto-rollback, traffic shift, termination wait (5 min) |
| IAM Role               | Permissoes para CodeDeploy operar ECS/ALB              |

### `iam_deploy`

Cria IAM policy para o usuario de CI/CD (`app-staging`) com permissoes granulares para ECR, ECS, ALB, CloudWatch, IAM PassRole e CodeDeploy.

### `asg-launch-template`

Modulo alternativo/reutilizavel para criacao de Launch Template e Auto Scaling Group.

## Ambiente POC

O POC reutiliza a VPC "Beta" existente via modulo `vpc_data` e provisiona toda a infraestrutura ECS.

### Infraestrutura

| Componente    | Configuracao                          |
| ------------- | ------------------------------------- |
| VPC           | Reutiliza "Beta" via `vpc_data`       |
| Cluster       | `poc-001-cluster`                     |
| Instancias    | 8x `t3a.medium` (2048 CPU units cada) |
| ALB           | Interno, DNS `poc001.4shark.internal` |
| Blue/Green    | Habilitado para servico web           |
| State Backend | S3 `tfstateecs4shark-poc`             |

### Servicos ECS

| Servico                                         | Porta | Desired | Deploy      | Observacao         |
| ----------------------------------------------- | ----- | ------- | ----------- | ------------------ |
| `poc-001-web-service`                           | 3000  | 1       | CODE_DEPLOY | Blue/Green com ALB |
| `poc-001-worker-commission-service`             | -     | 1       | ECS         | Circuit breaker    |
| `poc-001-worker-system-service`                 | 3000  | 1       | ECS         | Circuit breaker    |
| `poc-001-worker-user-service`                   | -     | 1       | ECS         | Circuit breaker    |
| `poc-001-worker-migration-service`              | -     | 0       | ECS         | Circuit breaker    |
| `poc-001-worker-cleansing-service`              | -     | 0       | ECS         | Circuit breaker    |
| `poc-001-worker-commission-tiger-shark-service` | -     | 0       | ECS         | Circuit breaker    |
| `poc-001-worker-commission-white-shark-service` | -     | 0       | ECS         | Circuit breaker    |

Todos os servicos usam **2048 CPU / 2048 MiB memory** e a execution role `ecsTaskExecutionRole`.

### Repositorios ECR

Um repositorio por servico: `poc-001-web`, `poc-001-worker-commission`, `poc-001-worker-system`, `poc-001-worker-user`, `poc-001-worker-migration`, `poc-001-worker-cleansing`, `poc-001-worker-commission-tiger-shark`, `poc-001-worker-commission-white-shark`.

### Comandos

```bash
cd poc
terraform init
terraform plan -var-file="poc.tfvars"
terraform apply -var-file="poc.tfvars"
```

## Pipeline Blue/Green POC (`deploy-bluegreen-poc.yaml`)

Workflow do GitHub Actions disparado manualmente (`workflow_dispatch`) que faz o deploy coordenado de todos os servicos do POC com Blue/Green para o web e rolling update para os workers.

### Fluxo dos Jobs

```
1. scale-workers-zero
   └──> 2. deploy-web (CodeDeploy)
         ├──> 3a. deploy-worker-commission
         ├──> 3b. deploy-worker-system
         └──> 3c. deploy-worker-user
              └──> 4. resume-deployment (libera hook do CodeDeploy)
                    └──> 5. traffic-shift (monitora CodeDeploy)
                          └──> 6. validate (verifica todos os jobs)
                                └──> 7. success
```

### Detalhamento dos Jobs

**1. Scale Workers to 0** - Zera o `desired_count` dos workers ativos (commission, system, user) para liberar capacidade no cluster para o deploy do web.

**2. Deploy Web** - Usa a action `deploy-ecs` no modo `codedeploy`:

- Build da imagem Docker (Dockerfile web)
- Push para ECR `poc-001-web`
- Registra nova Task Definition
- Cria deployment no CodeDeploy com AppSpec que inclui um hook `BeforeAllowTraffic` (Lambda)
- O CodeDeploy registra novas tasks no Green Target Group e **fica aguardando** a liberacao do hook

**3a/3b/3c. Deploy Workers** - Executam em paralelo apos o deploy-web. Cada um usa a action `deploy-ecs` no modo `update-service`:

- Build da imagem Docker (Dockerfile worker com Sidekiq config)
- Push para ECR do respectivo worker
- Registra nova Task Definition
- Atualiza o servico ECS com `force-new-deployment`
- Aguarda estabilizacao (`wait-stable: true`)

**4. Resume Deployment** - Executa apos todos os workers estarem estaveis:

- Busca o `LifecycleEventHookExecutionId` no SSM Parameter Store (gravado pela Lambda do hook)
- Polling com retry (30 tentativas, 10s intervalo)
- Chama `put-lifecycle-event-hook-execution-status` com `Succeeded` para liberar o CodeDeploy

**5. Traffic Shift** - Monitora o deployment do CodeDeploy:

- Polling do status (40 tentativas, 15s intervalo)
- Aguarda status `Succeeded` (trafego migrado do Blue para Green)
- Falha se status for `Failed` ou `Stopped`

**6. Validate** - Verifica o resultado de todos os jobs anteriores. Falha se qualquer job falhou.

**7. Success** - Exibe resumo do deploy concluido.

### Por que esse fluxo?

O cluster POC tem **8 instancias t3a.medium** e cada task usa **2048 CPU** (capacidade total de uma instancia). Para fazer Blue/Green do web, o CodeDeploy precisa subir novas tasks no Green TG **antes** de derrubar as antigas. Zerando os workers primeiro, libera-se capacidade para as novas tasks do web. O hook `BeforeAllowTraffic` pausa o CodeDeploy enquanto os workers sao redeployados, garantindo que tudo esta atualizado antes de migrar o trafego.

### Reusable Actions

**`deploy-ecs`** - Action composta que faz build, push e deploy:

- Determina versao da imagem a partir de `config/version.rb` + git SHA
- Build com Docker (web ou worker)
- Push para ECR com tags `latest` e versao
- Registra Task Definition com env vars e secrets do GitHub Environment
- Modo `update-service`: atualiza o servico ECS e aguarda estabilizacao
- Modo `codedeploy`: apenas registra a Task Definition (retorna ARN via output)

**`deploy-bluegreen`** - Action composta para deploy transacional Blue/Green:

- Armazena task definitions atuais para rollback
- Registra novas task definitions para todos os servicos
- Executa migrations (opcional)
- Atualiza todos os servicos
- Aguarda estabilizacao
- Bake time configuravel
- Rollback automatico em caso de falha (restaura task definitions anteriores)

## Capacidade do Cluster

Cada instancia `t3a.medium` = 2048 CPU units (2 vCPU). Cada task usa 2048 CPU = **1 task por instancia**.

| POC            | Valor |
| -------------- | ----- |
| Instancias ASG | 8     |
| Tasks maximas  | 8     |

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado
- Account: 405749097490
- Regiao: us-east-1
- Key Pair: 4Shark-key
- Route53 Zone: 4shark.internal
