# Projeto 1 - Configuração do Ambiente de Banco de Dados


# 1- Instale o Docker Desktop.


# 2- Abra o terminal ou prompt de comando e execute a instrução abaixo para criar o container Docker:

docker run --name dw -p 5431:5432 -e POSTGRES_DB=dwprd -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=0000 -d postgres:16.1


# 3- Instale o pgAdmin.

Abre o PGadmin
Registra o Servidor

Host name/Address: localhost
port 5431
Maintenance database: dwprd
Username: dbuser
Password: 0000

no pg admin, iremos criar as tabelas do dw seguindo o arquivo. 
schemas -> query tool -> e executar o arquivo 01-modelo-fisico.sql

vou no pgadmin, em tools --> ERD Tool
arrasto as tabelas criadas clino na fato e vou criando os relacionamentos 1-M

o arquivo projeto-dw.pgerd e  projeto-dw.pgerd.png com os relacionamentos está salvo na raiz do projeto para consulta.

no arquivo 02-etl-carga-dados.sql são criadas as procedures para carregamento das tabelas de dimensão e fato. Devemos executar o script no pgadmin para carregar os dados. 





