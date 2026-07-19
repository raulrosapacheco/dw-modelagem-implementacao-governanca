# Execute os comandos abaixo para criar os containers dos bancos de dados

# Container para a fonte (banco de dados transacional):

docker run --name dbtransacional -p 5252:5432 -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=0000 -e POSTGRES_DB=dbtransacional -d postgres:16.1


# Container para o destino (DW) e para a staging area:

docker run --name dbdw -p 5253:5432 -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=0000 -e POSTGRES_DB=dbdw -d postgres:16.1

Entra no Pg Admin e conecta no banco de datos transacional
