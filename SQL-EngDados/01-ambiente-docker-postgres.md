# Preparando o Ambiente de Trabalho


# 1- Instale o Docker Desktop conforme instruções das aulas.


# 2- Abra o terminal ou prompt de comando e execute a instrução abaixo para criar o container Docker:

docker run --name databasesql -p 5437:5432 -e POSTGRES_USER=supraul -e POSTGRES_PASSWORD=xxxx -e POSTGRES_DB=trndb -d postgres:16.0


# 3- Instale o pgAdmin na maquina local

Conectei ao banco postgres criado pelo pgAdmin



