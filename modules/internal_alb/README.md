# Internal ALB (instance target)

Provisiona um ALB interno para ECS/EC2 com target group `instance` (porta 3000), listener HTTP na porta 80 e CNAME na zona privada do Route53.

## Inputs principais
- `name_prefix` (string): prefixo para nomes do ALB/TG.
- `vpc_id` (string) e `subnet_ids` (list): VPC e subnets privadas.
- `private_zone_id` (string) e `record_name` (string): hosted zone privada e nome do CNAME.
- `security_group_ids` (list, opcional): SGs para o ALB. Se não setado, o módulo cria um SG permitindo HTTP 80 a partir de `alb_ingress_cidrs`.
- `listener_rules` (list): regras path-based; padrão cria `/health` (priority 10) e `/` (priority 100) além da default action.
- `enable_blue_green` (bool): cria TG secundário para uso com CodeDeploy (Blue/Green).

## Outputs
- `alb_dns_name`, `alb_arn`, `listener_arn`, `target_group_arn`, `target_group_green_arn`, `record_fqdn`, `security_group_ids`.

## Exemplo de uso
```hcl
module "internal_alb_beta" {
  source = "../modules/internal_alb"

  name_prefix  = "beta-app"
  vpc_id       = data.aws_vpc.beta.id
  subnet_ids   = data.aws_subnets.beta_private.ids
  record_name  = "beta.4shark.internal"
  private_zone_id = data.aws_route53_zone.internal.id

  # Usando SG gerenciado pelo módulo
  alb_ingress_cidrs = [data.aws_vpc.beta.cidr_block]

  # Para Blue/Green:
  # enable_blue_green = true
}

# No serviço ECS:
# load_balancers = [{
#   target_group_arn = module.internal_alb_beta.target_group_arn
#   container_name   = "app"
#   container_port   = 3000
# }]
```
