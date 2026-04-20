# Projet 5 — Infrastructure AWS avec Terraform (IaC)
 
## 📋 Description du projet
 
> **Contexte pédagogique** — Il s'agit d'une **première prise en main de Terraform**. L'objectif principal était de comprendre comment fonctionne l'outil : comment déclarer des ressources, comment Terraform interagit avec AWS, et comment l'infrastructure peut être créée et détruite depuis le terminal. Ce projet est donc volontairement simple et direct.
 
Ce projet utilise **Terraform** pour déployer automatiquement une infrastructure cloud complète sur **Amazon Web Services (AWS)**. L'objectif est de provisionner une instance EC2 Ubuntu accessible en SSH, intégrée dans un réseau sécurisé, le tout en **Infrastructure as Code (IaC)** : l'ensemble de l'environnement est décrit dans des fichiers de configuration versionnables et reproductibles.
 
> **Infrastructure as Code** signifie que l'infrastructure réseau et les serveurs sont définis dans du code (fichiers `.tf`), ce qui permet de créer, modifier ou détruire l'environnement en une seule commande, sans passer par la console AWS.
 
---
 
## Architecture déployée sur AWS
 
```
                        [Internet]
                             │
                    [VPC AWS — 172.31.0.0/16]
                             │
                   [Subnet — 172.31.12.0/24]
                             │
              [Security Group — lena_security_group]
               ┌─────────────┼─────────────┐
            Port 22       Port 80        ICMP
             (SSH)        (HTTP)         (ping)
                             │
                    [EC2 Instance — t2.micro]
                    Ubuntu 24.04 LTS (Noble)
                    Région : eu-west-3 (Paris)
                    Clé SSH : id_ed25519.pub
```
 
---
 
## Ressources Terraform créées
 
| Ressource Terraform                          | Nom AWS                  | Rôle |
|----------------------------------------------|--------------------------|------|
| `aws_security_group`                         | `lena_security_group`    | Pare-feu de l'instance |
| `aws_vpc_security_group_ingress_rule` (SSH)  | allow_ssh                | Autorise SSH (port 22/TCP) |
| `aws_vpc_security_group_ingress_rule` (HTTP) | allow_http               | Autorise HTTP (port 80) |
| `aws_vpc_security_group_ingress_rule` (ICMP) | allow_icmp               | Autorise ping (ICMP) |
| `aws_vpc_security_group_egress_rule`         | allow_all                | Tout le trafic sortant autorisé |
| `aws_subnet`                                 | `lena_subnet`            | Sous-réseau 172.31.12.0/24 dans le VPC |
| `aws_key_pair`                               | `lena_key`               | Clé SSH publique pour accès à l'instance |
| `aws_instance`                               | `lena_instance`          | Serveur EC2 Ubuntu 24.04 |
 
---
 
## Variables configurables
 
Toutes les valeurs modifiables sont centralisées dans `variables.tf` :
 
| Variable           | Valeur par défaut                                          | Description |
|--------------------|------------------------------------------------------------|-------------|
| `aws_region`       | `eu-west-3` (Paris)                                        | Région AWS de déploiement |
| `vpc_id`           | `vpc-0ebcdb39f7a526ef9`                                    | VPC cible existant |
| `vpc_ip_address`   | `172.31.0.0/16`                                            | Plage IP du VPC |
| `ubuntu_ami_name`  | `ubuntu-noble-24.04-amd64-server-*`                        | Image Ubuntu à utiliser |
| `ubuntu_ami_owner` | `099720109477` (Canonical officiel)                        | Propriétaire de l'AMI |
| `my_instance_type` | `t2.micro`                                                 | Type d'instance EC2 (Free Tier) |
 
---
 
## Fichiers du projet
 
| Fichier          | Rôle |
|------------------|------|
| `maint.tf`       | Fichier principal — définit toutes les ressources AWS à créer |
| `variables.tf`   | Déclare et centralise toutes les variables configurables |
| `terraform.tf`   | Configuration de Terraform lui-même (provider AWS ~5.92, version ≥1.2) |
 
---
 
## Comment utiliser ce projet
 
### Prérequis
 
- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.2 installé
- [AWS CLI](https://aws.amazon.com/cli/) configuré avec des credentials valides (`aws configure`)
- Une paire de clés SSH locale : `~/.ssh/id_ed25519.pub` doit exister
```bash
# Vérifier Terraform
terraform version
 
# Vérifier les credentials AWS
aws sts get-caller-identity
```
 
### Déploiement
 
```bash
# 1. Initialiser Terraform (télécharge le provider AWS)
terraform init
 
# 2. Prévisualiser les ressources qui vont être créées
terraform plan
 
# 3. Déployer l'infrastructure
terraform apply
 
# Confirmer avec "yes" quand demandé
```
 
### Se connecter à l'instance
 
```bash
# Récupérer l'IP publique après le déploiement
terraform show | grep public_ip
 
# Connexion SSH
ssh -i ~/.ssh/id_ed25519 ubuntu@<IP_PUBLIQUE>
```
 
### Supprimer l'infrastructure
 
```bash
# Détruire toutes les ressources créées
terraform destroy
```
 
---
 
## Technologies & outils utilisés
 
- **Terraform** ≥ 1.2 — Outil IaC (Infrastructure as Code)
- **Provider AWS** (~5.92) — Plugin Terraform pour AWS
- **Amazon EC2** — Instance de calcul cloud (t2.micro, Free Tier)
- **Amazon VPC** — Réseau virtuel privé
- **Ubuntu 24.04 LTS** (Noble Numbat) — Système d'exploitation de l'instance
- **SSH / ED25519** — Authentification sécurisée à l'instance
- **Région AWS** : `eu-west-3` — Paris
---
 
## Structure du projet
 
```
projet-5-terraform/
├── maint.tf          # Ressources AWS (EC2, VPC, subnet, security group, key pair)
├── variables.tf      # Variables configurables (région, AMI, type d'instance...)
├── terraform.tf      # Configuration provider et version Terraform
└── README.md         # Ce fichier
```
 
---
