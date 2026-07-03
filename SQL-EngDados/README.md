\# Estudos de SQL com PostgreSQL



Este repositório reúne anotações e scripts SQL utilizados para estudo prático de banco de dados PostgreSQL, com foco em comandos essenciais para análise de dados, modelagem e fundamentos de engenharia de dados.



O objetivo é servir como material de consulta rápida para revisar comandos SQL, criação de tabelas, manipulação de dados, joins, CTEs, views, procedures, triggers, transações e índices.



\---



\## Estrutura sugerida dos arquivos



```text

.

├── 01-ambiente-docker-postgres.md

├── 02-ddl-dml-basico.sql

├── 03-agregacoes-joins-cte-subquery.sql

├── 04-views-procedures-triggers-transacoes-indexes.sql

└── README.md

```



\---



\## 1. Ambiente com Docker e PostgreSQL



Arquivo sugerido:



```text

01-ambiente-docker-postgres.md

```



Este arquivo documenta a criação do ambiente PostgreSQL usando Docker.



Comando utilizado:



```bash

docker run --name databasesql \\

&#x20; -p 5437:5432 \\

&#x20; -e POSTGRES\_USER=supraul \\

&#x20; -e POSTGRES\_PASSWORD=xxxx \\

&#x20; -e POSTGRES\_DB=trndb \\

&#x20; -d postgres:16.0

```



\### Explicação do comando



| Parte | Significado |

|---|---|

| `docker run` | Cria e executa um novo container |

| `--name databasesql` | Define o nome do container |

| `-p 5437:5432` | Mapeia a porta 5437 da máquina local para a porta 5432 do PostgreSQL |

| `POSTGRES\_USER` | Define o usuário do banco |

| `POSTGRES\_PASSWORD` | Define a senha do banco |

| `POSTGRES\_DB` | Cria o banco inicial |

| `-d` | Executa o container em segundo plano |

| `postgres:16.0` | Imagem PostgreSQL utilizada |



\---



\## 2. DDL e DML básico



Arquivo sugerido:



```text

02-ddl-dml-basico.sql

```



Este script apresenta os primeiros comandos SQL para criação e manipulação de estruturas no banco de dados.



\### Conteúdos estudados



\- Criação de schema

\- Criação de tabelas

\- Alteração de tabelas

\- Exclusão de tabelas

\- Inserção de registros

\- Consulta de dados

\- Atualização de dados

\- Exclusão de dados



\### Principais comandos



```sql

CREATE SCHEMA estudos01 AUTHORIZATION supraul;

```



Cria um schema para organizar os objetos do banco.



```sql

CREATE TABLE estudos01.funcionarios (

&#x20;   id\_funcionario INT PRIMARY KEY,

&#x20;   nome VARCHAR(50),

&#x20;   departamento VARCHAR(50),

&#x20;   data\_contratacao DATE,

&#x20;   salario DECIMAL(10, 2)

);

```



Cria uma tabela de funcionários.



```sql

INSERT INTO estudos01.funcionarios (...)

VALUES (...);

```



Insere registros na tabela.



```sql

SELECT \* 

FROM estudos01.funcionarios;

```



Consulta os dados da tabela.



```sql

UPDATE estudos01.funcionarios 

SET salario = 26000.00 

WHERE nome = 'Machado de Assis';

```



Atualiza dados existentes.



```sql

DELETE FROM estudos01.funcionarios 

WHERE nome = 'Machado de Assis';

```



Remove registros da tabela.



```sql

DROP TABLE estudos01.funcionarios;

```



Exclui a tabela.



\---



\## 3. Agregações, agrupamentos, joins, CTEs e subqueries



Arquivo sugerido:



```text

03-agregacoes-joins-cte-subquery.sql

```



Este script aprofunda consultas SQL usando funções de agregação, agrupamentos, junções entre tabelas, CTEs e subconsultas.



\### Conteúdos estudados



\- `MIN`

\- `MAX`

\- `AVG`

\- `SUM`

\- `COUNT`

\- `ROUND`

\- `GROUP BY`

\- `HAVING`

\- `ORDER BY`

\- `INNER JOIN`

\- `LEFT JOIN`

\- `RIGHT JOIN`

\- `FULL JOIN`

\- `COALESCE`

\- `CTE`

\- `Subquery`

\- `EXTRACT`



\### Exemplos importantes



Média salarial geral:



```sql

SELECT ROUND(AVG(salario), 2) AS media\_salario

FROM estudos01.funcionarios;

```



Média salarial por departamento:



```sql

SELECT departamento, ROUND(AVG(salario), 2) AS media\_salario

FROM estudos01.funcionarios

GROUP BY departamento;

```



Filtro após agrupamento com `HAVING`:



```sql

SELECT departamento, ROUND(AVG(salario), 2) AS media\_salario

FROM estudos01.funcionarios

GROUP BY departamento

HAVING ROUND(AVG(salario), 2) > 20000

ORDER BY departamento;

```



Exemplo de `LEFT JOIN`:



```sql

SELECT e.nome, e.salario, p.nome\_projeto

FROM estudos01.funcionarios e

LEFT JOIN estudos01.projetos p 

&#x20;   ON e.id\_funcionario = p.func\_id;

```



Tratando valores nulos com `COALESCE`:



```sql

SELECT 

&#x20;   e.nome, 

&#x20;   e.salario, 

&#x20;   COALESCE(p.nome\_projeto, 'Não Alocado em Projeto') AS nome\_projeto

FROM estudos01.funcionarios e

LEFT JOIN estudos01.projetos p 

&#x20;   ON e.id\_funcionario = p.func\_id;

```



Exemplo de CTE:



```sql

WITH funcionarios\_salarios\_mais\_altos AS (

&#x20;   SELECT nome, salario, data\_contratacao

&#x20;   FROM estudos01.funcionarios

&#x20;   WHERE salario > 21900

)

SELECT \* 

FROM funcionarios\_salarios\_mais\_altos

WHERE EXTRACT(DAY FROM data\_contratacao) = 10;

```



Exemplo de subquery:



```sql

SELECT nome, departamento

FROM estudos01.funcionarios

WHERE salario = (

&#x20;   SELECT MAX(salario) 

&#x20;   FROM estudos01.funcionarios 

&#x20;   WHERE EXTRACT(MONTH FROM data\_contratacao) = 2

);

```



\---



\## 4. Views, materialized views, procedures, functions, triggers, transações e índices



Arquivo sugerido:



```text

04-views-procedures-triggers-transacoes-indexes.sql

```



Este script trabalha conceitos mais avançados do PostgreSQL, úteis para organização, automação, auditoria e performance.



\### Conteúdos estudados



\- View

\- Materialized View

\- Stored Procedure

\- Function

\- Trigger

\- Controle de transações

\- `COMMIT`

\- `ROLLBACK`

\- `EXPLAIN`

\- Índices

\- `CREATE INDEX`

\- `DROP INDEX`



\---



\## Views



Uma `VIEW` é uma consulta salva no banco de dados. Ela não armazena os dados fisicamente, apenas representa uma consulta.



Exemplo:



```sql

CREATE OR REPLACE VIEW estudos02.vw\_detalhes\_funcionarios AS

WITH Salario\_Departamento AS (

&#x20;   SELECT departamento, ROUND(AVG(salario), 2) AS salario\_medio

&#x20;   FROM estudos02.funcionarios

&#x20;   GROUP BY departamento

)

SELECT 

&#x20;   f.id\_funcionario, 

&#x20;   f.nome, 

&#x20;   f.departamento, 

&#x20;   f.data\_contratacao, 

&#x20;   f.salario

FROM estudos02.funcionarios f

INNER JOIN Salario\_Departamento sd 

&#x20;   ON f.departamento = sd.departamento

WHERE f.salario > sd.salario\_medio;

```



Consulta da view:



```sql

SELECT \* 

FROM estudos02.vw\_detalhes\_funcionarios;

```



\---



\## Materialized View



Uma `MATERIALIZED VIEW` armazena fisicamente o resultado da consulta.



Diferente da view comum, ela não atualiza automaticamente os dados quando a tabela de origem muda.



Exemplo:



```sql

CREATE MATERIALIZED VIEW estudos02.mv\_funcionarios\_projetos AS

WITH FuncionariosProjetos AS (

&#x20;   SELECT 

&#x20;       f.id\_funcionario,

&#x20;       f.nome AS nome\_funcionario,

&#x20;       f.departamento,

&#x20;       f.salario,

&#x20;       COALESCE(p.id\_projeto, 0) AS id\_projeto,

&#x20;       COALESCE(p.nome\_projeto, 'NA') AS nome\_projeto

&#x20;   FROM estudos02.funcionarios f

&#x20;   LEFT JOIN estudos02.projetos p 

&#x20;       ON f.id\_funcionario = p.func\_id

)

SELECT \* 

FROM FuncionariosProjetos;

```



Atualização da materialized view:



```sql

REFRESH MATERIALIZED VIEW estudos02.mv\_funcionarios\_projetos;

```



\---



\## Stored Procedure



Uma procedure executa uma sequência de comandos no banco.



Exemplo:



```sql

CREATE OR REPLACE PROCEDURE estudos02.aumenta\_salario()

LANGUAGE plpgsql

AS $$

DECLARE 

&#x20;   cur CURSOR FOR 

&#x20;       SELECT 

&#x20;           id\_funcionario, 

&#x20;           nome, 

&#x20;           salario, 

&#x20;           salario \* 1.05 AS salario\_novo 

&#x20;       FROM estudos02.funcionarios;

BEGIN

&#x20;   FOR record IN cur LOOP

&#x20;       RAISE NOTICE 'Funcionario: %, Salario Atual: %, Novo Salario: %', 

&#x20;                    record.nome, record.salario, record.salario\_novo;

&#x20;   END LOOP;

END;

$$;

```



Executar a procedure:



```sql

CALL estudos02.aumenta\_salario();

```



\---



\## Function e Trigger



Uma function pode ser usada por uma trigger para executar uma regra automaticamente.



Exemplo de function para impedir projeto sem funcionário:



```sql

CREATE OR REPLACE FUNCTION estudos02.verifica\_funcionario\_projeto()

RETURNS TRIGGER AS $$

BEGIN

&#x20;   IF NEW.func\_id IS NULL THEN

&#x20;       RAISE EXCEPTION 'Não é permitido inserir um projeto sem um funcionário associado.';

&#x20;   END IF;



&#x20;   RETURN NEW;

END;

$$ LANGUAGE plpgsql;

```



Trigger associada:



```sql

CREATE TRIGGER trg\_verifica\_funcionario\_projeto

BEFORE INSERT ON estudos02.projetos

FOR EACH ROW 

EXECUTE FUNCTION estudos02.verifica\_funcionario\_projeto();

```



Essa trigger impede a inserção de um projeto sem funcionário associado.



\---



\## Histórico de alterações com Trigger



Criação de tabela de histórico:



```sql

CREATE TABLE estudos02.historico\_salarios (

&#x20;   id\_funcionario INT,

&#x20;   salario\_antigo DECIMAL(10, 2),

&#x20;   data\_mudanca TIMESTAMP DEFAULT CURRENT\_TIMESTAMP

);

```



Function para salvar salário antigo:



```sql

CREATE OR REPLACE FUNCTION estudos02.salva\_salario\_antigo()

RETURNS TRIGGER AS $$

BEGIN

&#x20;   IF OLD.salario IS DISTINCT FROM NEW.salario THEN

&#x20;       INSERT INTO estudos02.historico\_salarios (

&#x20;           id\_funcionario, 

&#x20;           salario\_antigo

&#x20;       )

&#x20;       VALUES (

&#x20;           OLD.id\_funcionario, 

&#x20;           OLD.salario

&#x20;       );

&#x20;   END IF;



&#x20;   RETURN NEW;

END;

$$ LANGUAGE plpgsql;

```



Trigger:



```sql

CREATE TRIGGER trg\_salva\_salario\_antigo

BEFORE UPDATE ON estudos02.funcionarios

FOR EACH ROW 

EXECUTE FUNCTION estudos02.salva\_salario\_antigo();

```



Atualização de salário:



```sql

UPDATE estudos02.funcionarios 

SET salario = 36500.00 

WHERE nome = 'Machado de Assis';

```



Consulta do histórico:



```sql

SELECT \* 

FROM estudos02.historico\_salarios;

```



\---



\## Transações



Transações permitem agrupar comandos e confirmar ou desfazer tudo de uma vez.



```sql

BEGIN;



INSERT INTO estudos02.funcionarios (

&#x20;   id\_funcionario, 

&#x20;   nome, 

&#x20;   departamento, 

&#x20;   data\_contratacao, 

&#x20;   salario

)

VALUES (

&#x20;   106, 

&#x20;   'Jorge Amado', 

&#x20;   'Desenvolvimento', 

&#x20;   '2024-01-01', 

&#x20;   15000.00

);



INSERT INTO estudos02.projetos (

&#x20;   id\_projeto, 

&#x20;   nome\_projeto, 

&#x20;   func\_id

)

VALUES (

&#x20;   7777, 

&#x20;   'Projeto Alpha', 

&#x20;   106

);



COMMIT;

```



Para desfazer:



```sql

ROLLBACK;

```



\---



\## Análise de plano de execução



O comando `EXPLAIN` mostra como o banco pretende executar uma consulta.



```sql

EXPLAIN

WITH FuncionariosProjetos AS (

&#x20;   SELECT 

&#x20;       f.nome AS nome\_funcionario,

&#x20;       f.departamento,

&#x20;       f.salario,

&#x20;       COALESCE(p.id\_projeto, 0) AS id\_projeto,

&#x20;       COALESCE(p.nome\_projeto, 'NA') AS nome\_projeto

&#x20;   FROM estudos02.funcionarios f

&#x20;   LEFT JOIN estudos02.projetos p 

&#x20;       ON f.id\_funcionario = p.func\_id

)

SELECT \* 

FROM FuncionariosProjetos

WHERE salario > 20000;

```



\---



\## Índices



Índices ajudam a melhorar a performance de consultas, principalmente em colunas muito utilizadas em filtros, joins e ordenações.



Criação de índice:



```sql

CREATE INDEX idx\_funcionarios\_id 

ON estudos02.funcionarios (id\_funcionario);

```



```sql

CREATE INDEX idx\_salario 

ON estudos02.funcionarios (salario);

```



Exclusão de índice:



```sql

DROP INDEX estudos02.idx\_funcionarios\_id;

```



\---



\## Resumo dos principais aprendizados



| Tema | O que foi praticado |

|---|---|

| Docker | Criação de ambiente PostgreSQL em container |

| DDL | Criação, alteração e exclusão de estruturas |

| DML | Inserção, atualização, exclusão e consulta de dados |

| Agregações | `MIN`, `MAX`, `AVG`, `SUM`, `COUNT` |

| Agrupamentos | `GROUP BY` e `HAVING` |

| Joins | `INNER`, `LEFT`, `RIGHT` e `FULL JOIN` |

| CTE | Organização de consultas temporárias |

| Subquery | Consulta dentro de outra consulta |

| Views | Consultas salvas no banco |

| Materialized Views | Consulta salva com dados materializados |

| Procedures | Rotinas executáveis no banco |

| Functions | Funções reutilizáveis |

| Triggers | Execução automática de regras |

| Transações | Controle com `BEGIN`, `COMMIT` e `ROLLBACK` |

| Performance | Uso de `EXPLAIN` e índices |



\---



\## Ordem recomendada de estudo



1\. Preparar ambiente com Docker e PostgreSQL

2\. Criar schema e tabelas

3\. Inserir dados de exemplo

4\. Praticar `SELECT`

5\. Aplicar filtros e ordenações

6\. Usar funções de agregação

7\. Agrupar dados com `GROUP BY`

8\. Filtrar grupos com `HAVING`

9\. Relacionar tabelas com joins

10\. Organizar consultas com CTE

11\. Usar subqueries

12\. Criar views e materialized views

13\. Criar procedures e functions

14\. Automatizar regras com triggers

15\. Controlar operações com transações

16\. Analisar performance com `EXPLAIN`

17\. Criar índices



\---



\## Observações pessoais



Este projeto faz parte da minha jornada de estudos em SQL, PostgreSQL, modelagem de dados e engenharia de dados.



A ideia é manter os scripts organizados para consulta futura, facilitando a revisão de comandos e conceitos importantes usados no dia a dia de dados.

