# Terra project : Generation gatling machine in AWS with terraform

## French Version

Ce projet utilise Terraform afin de créer une machine sur AWS qui servira à faire le test de performance.
L'infrastructure comprend une instance Amazon EC2 et les ressources associée.
L'instance Amazon EC2 est pre-installé de :
_ java & scala
_ firewalld
_ influxdb & grafana
_ gatling

### Prérequis

Avant de commencer, assurez-vous d'avoir les prérequis suivants :

-   **Terraform installé:** Suivez les instructions de la section [Installation de Terraform](#Installation de Terraform) pour installer Terraform sur votre système.
-   Compte AWS:\*\* Vous aurez besoin d'un compte AWS et de clés d'accès avec les permissions appropriées pour créer des ressources.

### Installation de Terraform (pour Windows 11)

1. **Télécharger Terraform:**

    - Visitez la page [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads) et téléchargez la version de Terraform correspondant à votre système d'exploitation.

2. **Extraire l'archive:**

    - Utilisez la méthode de votre choix pour extraire le contenu de l'archive téléchargée.

3. **Déplacer l'extrait**

    - Utilisez la méthode de votre choix pour extraire le contenu de l'archive téléchargée.

4. **Déplacer l'extrait**

    - Utilisez la méthode de votre choix pour extraire le contenu de l'archive téléchargée.

### Installation

1.  **Cloner le dépôt:**

        ```bash
        git clone https://github.com/phuc-hyphen/terraform-aws-gatling-injecter.git
        cd terraform-aws-project
        ```

    generation access key :
    go to https://us-east-1.console.aws.amazon.com/iamv2/home#/security_credentials
    in access key section > create access key

2.  **commands pour démarrer**

    - terraform init
    - terraform plan
    - terraform apply -auto-approve

3.  **commands pour arreter**

    - terraform destroy -auto-approve
