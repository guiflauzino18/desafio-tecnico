# Volume para persistir os dados
resource "docker_volume" "vol_pgdata" {
  name = "vol_pgdata"
}

# Rede privada
resource "docker_network" "private_network" {
  name = "private_net"
  driver = "bridge"
}

################# POSTGRE #######################

# Pull da imagem do Postgres
resource "docker_image" "postgres15" {
  name = "postgres:15.8-bullseye"
}

# container do postgres
resource "docker_container" "postgres" {
  image = docker_image.postgres15.image_id
  name  = "postgres"
  restart = "always"

  volumes {
    volume_name = docker_volume.vol_pgdata.name
    container_path = var.pg_data
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  env = [
    "POSTGRES_PASSWORD=${var.pg_pass}",
    "POSTGRES_USER=${var.pg_user}",
    "POSTGRES_DB=${var.pg_db_name}",
    "PGDATA=${var.pg_data}"
  ]

}

####################### BACKEND ##########################

# Cria imagem do Backend
resource "docker_image" "backend_image" {
  name = "backend-app:v1.0.0"
  build {
    context = "../backend"
    dockerfile = "/build/Dockerfile"
    tag = ["backend-app:1.0.0"]
  }
}

# Cria Container do backend
resource "docker_container" "backend"{
  name = "backend-app"
  image = docker_image.backend_image.image_id
  depends_on = [ docker_image.backend_image, docker_container.postgres ]

  networks_advanced {
    name = docker_network.private_network.name
  }

  env = [
    "pg_user=${var.pg_user}",
    "pg_pass=${var.pg_pass}",
    "pg_host=${docker_container.postgres.hostname}",
    "db_name=${var.pg_db_name}",
    "port=${var.backend_port}",
  ]
}


###################### FRONTEND########################
#Cria imagem do Frontend
resource "docker_image" "frontend_image" {
  name = "frontend-app:v1.0.0"
  
  build {
    context = "../frontend/"
    dockerfile = "build/Dockerfile"
    tag = ["frontend-app:1.0.0"]
  }
}

#Cria container do frontend
resource "docker_container" "frontend" {
  name = "frontend-app"
  image = docker_image.frontend_image.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
}




#################### PROXY ###########################
#Cria imagem do proxy reverse
resource "docker_image" "proxy_image" {
  name = "nginx-proxy:latest"
  build {
    context = "../proxy/"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "proxy" {
  name = "proxy"
  image = docker_image.proxy_image.image_id
  depends_on = [ docker_container.backend, docker_container.frontend ]
  networks_advanced {
    name = docker_network.private_network.name
  }
  ports {
    internal = 80
    external = 80
  }
}