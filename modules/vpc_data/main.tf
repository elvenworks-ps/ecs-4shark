# modules/vpc_data/main.tf

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  # Alternativamente, comente o bloco acima e descomente o abaixo para usar o ID diretamente
  # id = var.vpc_id  source   = "../modules/vpc_data"

}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["Beta-prv-*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["Beta-pub-*"]
  }
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "private_ids" {
  value = data.aws_subnets.private.ids
}

output "public_ids" {
  value = data.aws_subnets.public.ids
}
