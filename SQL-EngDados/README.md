# 📚 Estudos de SQL com PostgreSQL

Este repositório reúne exercícios e exemplos práticos de SQL desenvolvidos durante meus estudos em PostgreSQL.

O objetivo é consolidar os principais conceitos da linguagem SQL e servir como material de consulta rápida para revisões futuras.

---

# 🎯 Objetivos

Neste projeto foram praticados conceitos fundamentais de SQL, desde a criação de estruturas até recursos avançados do PostgreSQL, como:

- DDL
- DML
- Consultas SQL
- Funções de agregação
- Joins
- CTE
- Subqueries
- Views
- Materialized Views
- Procedures
- Functions
- Triggers
- Transações
- Índices
- Análise de performance

---

# 📂 Estrutura do Projeto

```
.
├── 01-ambiente-docker-postgres.md
├── 02-ddl-dml-basico.sql
├── 03-agregacoes-joins-cte-subquery.sql
├── 04-views-procedures-triggers-transacoes-indexes.sql
└── README.md
```

---

# 📖 Conteúdo dos Arquivos

## 01 - Ambiente Docker PostgreSQL

Arquivo:

```
01-ambiente-docker-postgres.md
```

Conteúdo:

- Instalação do Docker Desktop
- Criação do container PostgreSQL
- Configuração do banco de dados
- Conexão utilizando pgAdmin
- Preparação do ambiente de desenvolvimento

Principais comandos:

- `docker run`
- `docker start`
- `docker stop`
- `docker ps`

---

## 02 - DDL e DML Básico

Arquivo:

```
02-ddl-dml-basico.sql
```

Conteúdo estudado:

### DDL

- CREATE SCHEMA
- CREATE TABLE
- ALTER TABLE
- DROP TABLE

### DML

- INSERT
- UPDATE
- DELETE
- SELECT

Também foram praticados:

- Tipos de dados
- Chave Primária
- Constraints
- Organização de schemas

---

## 03 - Agregações, JOINs, CTE e Subqueries

Arquivo:

```
03-agregacoes-joins-cte-subquery.sql
```

Conteúdo estudado:

### Funções de agregação

- COUNT
- SUM
- AVG
- MAX
- MIN
- ROUND

### Agrupamentos

- GROUP BY
- HAVING
- ORDER BY

### JOINs

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL JOIN

### Outros recursos

- COALESCE
- CASE
- CTE (WITH)
- Subqueries
- EXTRACT

---

## 04 - Views, Procedures, Triggers, Transações e Índices

Arquivo:

```
04-views-procedures-triggers-transacoes-indexes.sql
```

Conteúdo estudado:

### Views

- VIEW
- MATERIALIZED VIEW

### Programação no Banco

- FUNCTION
- PROCEDURE
- CURSOR

### Automação

- TRIGGER

### Controle de Transações

- BEGIN
- COMMIT
- ROLLBACK

### Performance

- EXPLAIN
- CREATE INDEX
- DROP INDEX

---

# 🚀 Ordem Recomendada de Estudo

1. Preparação do ambiente Docker
2. DDL e criação das tabelas
3. Manipulação de dados (DML)
4. Consultas SQL
5. Funções de agregação
6. Agrupamentos
7. JOINs
8. CTE
9. Subqueries
10. Views
11. Materialized Views
12. Procedures
13. Functions
14. Triggers
15. Transações
16. Índices
17. EXPLAIN

---

# 💡 Objetivo do Repositório

Este repositório faz parte da minha jornada de estudos em Banco de Dados, PostgreSQL e Engenharia de Dados.

A organização dos arquivos foi feita para facilitar futuras consultas e revisões dos principais conceitos da linguagem SQL.

Cada arquivo representa um tema específico, permitindo localizar rapidamente exemplos práticos de determinado recurso da linguagem.

---

# 📌 Tecnologias

- PostgreSQL 16
- Docker
- pgAdmin
- SQL