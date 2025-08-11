# Deploy da aplicação

## Instalações das dependências:

### Terraform
Para construção da infraestrura.
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

### Docker
Para execução dos containers:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh


## Executando aplicação

Criar as variáveis de ambiente abaixo com seus respectivos valores: O sufixo TF_VAR_é importante para o terraform conseguir pegar seus valores.

export TF_VAR_pg_user=user
export TF_VAR_pg_db_name=db_name
export TF_VAR_pg_pass=pg_pass
export TF_VAR_backend_port=3000

#### Executar comandos

terraform init
terraform validate
terraform plan -var-file=variables.tfvars -out=plan.out
terraform apply plan.out

#### Inserir dados no banco
Acessar o container do postgres e incluir os valores contidos script sql

## Acessar a Aplicação
Criar um registro dns desafio.cubos.io apontando para o servidor onde está rodando os containers

acessar no navegador http://desafio.cubos.io


# Levantamento de requisitos:

PostgreSQl PostgreSQL 15.8 em Docker
    postgres:15.8-bullseye
    criar variaveis de ambiente local
        TF_VAR_pg_user, TF_VAR_pg_db_name, TF_VAR_pg_pass, TF_VAR_db_port

Terraform com provider docker

Proxy reverse

Variáveis de ambiente: user, pass, host e db_port
${user}:${pass}@${host}:${db_port}`

Nginx para servidor frontend

Criar imagem docker para backend e frontend

Variaveis para backend
const port = Number(process.env.port);
const user = process.env.pg_user
const pass = process.env.pg_pass
const host = process.env.pg_pass


ajustes:
implementado ${db_name} na conexão com banco

alterado if para if (req.url == "/api")