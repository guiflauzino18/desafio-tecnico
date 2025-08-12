# Solução do Desafio

## Instalações das dependências:

### Terraform
Para construção da infraestrura. <br>
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

### Docker
Para execução dos containers: <br>
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh


## Executando aplicação

Criar as variáveis de ambiente abaixo com seus respectivos valores: O sufixo TF_VAR_é importante para o terraform conseguir pegar seus valores.

export TF_VAR_pg_user=your_user <br>
export TF_VAR_pg_pass=your_pg_pass <br>
export TF_VAR_pg_db_name <br>

#### Executar comandos

terraform init <br>
terraform validate <br>
terraform plan -var-file=variables.tfvars -out=plan.out <br>
terraform apply plan.out <br>

#### Inserir dados no banco
Acessar o container do postgres e incluir os valores contidos script sql

## Acessar a Aplicação
Criar um registro dns desafio.cubos.io apontando para o servidor onde está rodando os containers

acessar no navegador http://desafio.cubos.io

## Correções necessárias:
No backend em index.js foi necessário recuperar os valores para as variáveis:
const user = process.env.pg_user, 
const pass = process.env.pg_pass, 
const host = process.env.pg_host, 
const db_port = 5432 e 
const db_name = process.env.db_name.

E acrescentar o valor ${db_name} na string de conexão com o postgres: `postgres://${user}:${pass}@${host}:${db_port}/${db_name}`

## Resultado

<img width="1919" height="704" alt="image" src="https://github.com/user-attachments/assets/9b02083d-ce5e-440b-8701-58d829c72b83" />


