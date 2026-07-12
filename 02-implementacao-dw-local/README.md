# Projeto 1 - Data Warehouse com PostgreSQL, Docker e SCD

Este projeto tem como objetivo demonstrar, de forma prática, a construção de um **Data Warehouse dimensional** utilizando **PostgreSQL**, executado em container Docker.

O laboratório contempla a criação de um modelo estrela, carga de dados em tabelas de dimensão e fato, criação de views para relatórios, criação de índices para otimização e aplicação dos conceitos de **Slowly Changing Dimension (SCD)** dos tipos 1, 2 e 3.

---

## Objetivos do Laboratório

Ao final deste projeto, será possível compreender:

- criação de um ambiente PostgreSQL utilizando Docker;
- conexão ao banco utilizando pgAdmin;
- criação de schema para organização do Data Warehouse;
- modelagem física de tabelas dimensão e fato;
- construção de um modelo estrela;
- carga de dados nas dimensões e tabela fato;
- criação de procedures para carga de dados;
- criação de views, materialized views e functions para relatórios;
- criação de índices para otimização de consultas;
- aplicação prática dos conceitos de SCD Tipo 1, Tipo 2 e Tipo 3.

---

## Visão Geral da Arquitetura

O projeto utiliza uma arquitetura simples de Data Warehouse com modelo estrela.

```text
                    dim_produto
                         |
                         |
dim_cliente ---- fato_venda ---- dim_canal
                         |
                         |
                     dim_data
```

A tabela central do modelo é a `fato_venda`, responsável por armazenar os eventos de venda.  
As tabelas de dimensão armazenam os contextos de análise, como produto, cliente, canal e data.

---

## Modelo Dimensional

O modelo físico do Data Warehouse foi construído no schema `dw`.

### Tabela Fato

| Tabela | Finalidade |
|---|---|
| `dw.fato_venda` | Armazena as vendas realizadas, contendo chaves para as dimensões, quantidade vendida e valor da venda. |

### Tabelas Dimensão

| Tabela | Finalidade |
|---|---|
| `dw.dim_produto` | Armazena informações dos produtos. |
| `dw.dim_cliente` | Armazena informações dos clientes. |
| `dw.dim_canal` | Armazena informações dos canais de venda. |
| `dw.dim_data` | Armazena informações de calendário para análise temporal. |

---

## Relacionamentos do Modelo

A tabela `fato_venda` se relaciona com as dimensões por meio de chaves substitutas, também conhecidas como **surrogate keys**.

```text
dw.dim_produto
    sk_produto
        |
        | 1:N
        |
dw.fato_venda
        |
        | N:1
        |
    sk_cliente
dw.dim_cliente
```

Relacionamentos principais:

```text
dim_produto 1:N fato_venda
dim_cliente 1:N fato_venda
dim_canal   1:N fato_venda
dim_data    1:N fato_venda
```

> **Observação**
>
> Esse tipo de estrutura é comum em Data Warehouses porque facilita consultas analíticas e melhora a organização dos dados para relatórios.

---

## Estrutura dos Arquivos

```text
projeto-dw/
│
├── 01-modelo-fisico.sql
├── 02-etl-carga-dados.sql
├── 03-relatorios-view-function.sql
├── 04-indices.sql
├── 05-SCD-tipo1.sql
├── 06-SCD-tipo2.sql
├── 07-SCD-tipo3.sql
├── projeto-dw.pgerd
├── projeto-dw.pgerd.png
└── README.md
```

---

## Descrição dos Arquivos

| Arquivo | Descrição |
|---|---|
| `01-modelo-fisico.sql` | Cria o schema `dw`, as dimensões, a tabela fato, as chaves primárias e os relacionamentos. |
| `02-etl-carga-dados.sql` | Realiza a carga das dimensões e da tabela fato. Também cria procedures de carga. |
| `03-relatorios-view-function.sql` | Cria views, materialized view e function para análise dos dados. |
| `04-indices.sql` | Cria índices para otimizar consultas analíticas. |
| `05-SCD-tipo1.sql` | Demonstra atualização de dimensão usando SCD Tipo 1. |
| `06-SCD-tipo2.sql` | Demonstra atualização de dimensão usando SCD Tipo 2. |
| `07-SCD-tipo3.sql` | Demonstra atualização de dimensão usando SCD Tipo 3. |
| `projeto-dw.pgerd` | Arquivo do ERD criado no pgAdmin. |
| `projeto-dw.pgerd.png` | Imagem do modelo entidade-relacionamento para consulta. |

---

## Pré-requisitos

Antes de iniciar, é necessário ter instalado:

- Docker Desktop;
- pgAdmin;
- editor de SQL ou o Query Tool do pgAdmin.

---

## Etapa 1 - Criando o Container PostgreSQL

Abra o terminal ou prompt de comando e execute:

```bash
docker run --name dw \
-p 5431:5432 \
-e POSTGRES_DB=dwprd \
-e POSTGRES_USER=dbuser \
-e POSTGRES_PASSWORD=0000 \
-d postgres:16.1
```

Em uma única linha:

```bash
docker run --name dw -p 5431:5432 -e POSTGRES_DB=dwprd -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=0000 -d postgres:16.1
```

### O que esse comando faz?

| Parâmetro | Descrição |
|---|---|
| `docker run` | Cria e executa um novo container. |
| `--name dw` | Define o nome do container como `dw`. |
| `-p 5431:5432` | Mapeia a porta `5432` do PostgreSQL para a porta `5431` da máquina local. |
| `POSTGRES_DB=dwprd` | Cria o banco de dados inicial chamado `dwprd`. |
| `POSTGRES_USER=dbuser` | Define o usuário do banco. |
| `POSTGRES_PASSWORD=0000` | Define a senha do usuário. |
| `-d` | Executa o container em segundo plano. |
| `postgres:16.1` | Imagem do PostgreSQL utilizada. |

> **Observação**
>
> As credenciais utilizadas neste laboratório são apenas para ambiente local de estudo. Em ambientes reais, não é recomendado versionar senhas ou utilizar credenciais simples.

---

## Etapa 2 - Acessando o Banco pelo pgAdmin

Abra o pgAdmin e registre um novo servidor.

Utilize os dados abaixo:

| Campo | Valor |
|---|---|
| Host name/address | `localhost` |
| Port | `5431` |
| Maintenance database | `dwprd` |
| Username | `dbuser` |
| Password | `0000` |

Após conectar, o banco `dwprd` estará disponível para execução dos scripts SQL.

---

## Etapa 3 - Criando o Modelo Físico

No pgAdmin:

```text
Databases
  └── dwprd
      └── Query Tool
```

Execute o arquivo:

```text
01-modelo-fisico.sql
```

Esse script cria:

1. o schema `dw`;
2. a tabela `dw.dim_produto`;
3. a tabela `dw.dim_canal`;
4. a tabela `dw.dim_data`;
5. a tabela `dw.dim_cliente`;
6. a tabela `dw.fato_venda`;
7. as chaves primárias;
8. as chaves estrangeiras entre fato e dimensões.

### Modelo criado

```text
Schema: dw

dim_produto
    sk_produto
    id_produto
    nome
    categoria

dim_canal
    sk_canal
    id_canal
    nome
    regiao

dim_data
    sk_data
    data_completa
    dia
    mes
    ano

dim_cliente
    sk_cliente
    id_cliente
    nome
    tipo
    cidade
    estado
    pais

fato_venda
    sk_produto
    sk_cliente
    sk_canal
    sk_data
    quantidade
    valor_venda
```

---

## Etapa 4 - Visualizando o Modelo no ERD Tool

Após criar as tabelas, é possível visualizar o modelo no pgAdmin.

No pgAdmin, acesse:

```text
Tools > ERD Tool
```

Em seguida:

1. arraste as tabelas criadas no schema `dw`;
2. selecione a tabela fato;
3. crie os relacionamentos 1:N com as dimensões;
4. salve o arquivo do modelo.

Os arquivos gerados para consulta são:

```text
projeto-dw.pgerd
projeto-dw.pgerd.png
```

A imagem abaixo representa o modelo estrela utilizado no laboratório:

```text
dim_produto  ----|
                 |
dim_cliente  ----| 
                 |---- fato_venda
dim_canal    ----|
                 |
dim_data     ----|
```

---

## Etapa 5 - Carga de Dados no Data Warehouse

Após a criação do modelo físico, execute o arquivo:

```text
02-etl-carga-dados.sql
```

Esse script é responsável pela carga inicial do Data Warehouse.

### O que é carregado?

| Tabela | Tipo de carga |
|---|---|
| `dw.dim_produto` | Carga direta com produtos de exemplo. |
| `dw.dim_canal` | Carga direta com canais de venda. |
| `dw.dim_cliente` | Carga direta com clientes individuais e corporativos. |
| `dw.dim_data` | Carga via procedure para gerar datas de 2021 até 2031. |
| `dw.fato_venda` | Carga via procedure com registros aleatórios de venda. |

---

## Procedure de Carga da Dimensão Data

O script cria a procedure:

```sql
dw.sp_popula_dim_data()
```

Essa procedure popula a dimensão de data com registros entre:

```text
2021-01-01 até 2031-12-31
```

A dimensão `dim_data` permite análises por:

- dia;
- mês;
- ano;
- data completa.

---

## Procedure de Carga da Tabela Fato

O script também cria a procedure:

```sql
dw.sp_carrega_tabela_fato()
```

Essa procedure insere 1000 registros na tabela `fato_venda`.

Durante a carga, são selecionadas chaves aleatórias válidas das dimensões:

- produto;
- cliente;
- canal;
- data.

Também são gerados valores aleatórios para:

- quantidade;
- valor da venda.

> **Observação**
>
> A tabela fato possui uma chave primária composta por `sk_produto`, `sk_cliente`, `sk_canal` e `sk_data`. Por isso, o script trata possíveis violações de unicidade durante a geração dos registros.

---

## Etapa 6 - Criando Views, Materialized View e Function

Após carregar os dados, execute o arquivo:

```text
03-relatorios-view-function.sql
```

Esse script cria objetos para apoiar a geração de relatórios.

---

## Views Criadas

### 1. Vendas por Produto e Canal

```sql
dw.VW_VendasPorProdutoCanal
```

Essa view apresenta:

- nome do produto;
- nome do canal;
- total de vendas;
- total de quantidade vendida.

Consulta de exemplo:

```sql
SELECT *
FROM dw.vw_vendasporprodutocanal
ORDER BY nome_produto;
```

---

### 2. Vendas por Cliente e Período

```sql
dw.VW_VendasPorClientePeriodo
```

Essa view apresenta:

- nome do cliente;
- ano;
- mês;
- total de vendas;
- total de quantidade vendida.

Consulta de exemplo:

```sql
SELECT *
FROM dw.vw_vendasporclienteperiodo
ORDER BY nome_cliente;
```

---

## Materialized View Criada

```sql
dw.MV_RelatorioVendasResumido
```

A materialized view consolida as vendas por:

- categoria;
- ano;
- total de vendas;
- total de quantidade.

Consulta de exemplo:

```sql
SELECT *
FROM dw.mv_relatoriovendasresumido
ORDER BY ano;
```

Para atualizar os dados da materialized view:

```sql
REFRESH MATERIALIZED VIEW dw.MV_RelatorioVendasResumido;
```

> **Observação**
>
> Diferente de uma view comum, a materialized view armazena fisicamente o resultado da consulta. Por isso, pode melhorar a performance de relatórios, mas precisa ser atualizada quando os dados de origem mudam.

---

## Function Criada

```sql
dw.RelatorioVendasPorCliente(cliente_nome, relatorio_ano)
```

Essa function permite consultar vendas por cliente e ano, usando parâmetros opcionais.

Exemplos de execução:

```sql
SELECT * FROM dw.RelatorioVendasPorCliente();

SELECT * FROM dw.RelatorioVendasPorCliente('João Silva');

SELECT * FROM dw.RelatorioVendasPorCliente('João Silva', 2024);

SELECT * FROM dw.RelatorioVendasPorCliente(NULL, 2024);
```

---

## Etapa 7 - Criando Índices para Otimização

Após a criação das views e relatórios, execute o arquivo:

```text
04-indices.sql
```

Esse script cria índices para otimizar consultas analíticas.

### Índices criados

| Índice | Finalidade |
|---|---|
| `idx_fato_venda_produto_canal` | Otimiza consultas por produto e canal. |
| `idx_dim_produto` | Otimiza joins com a dimensão produto. |
| `idx_dim_canal` | Otimiza joins com a dimensão canal. |
| `idx_fato_venda_cliente_data` | Otimiza consultas por cliente e data. |
| `idx_dim_cliente` | Otimiza joins com a dimensão cliente. |
| `idx_dim_data` | Otimiza joins com a dimensão data. |
| `idx_fato_venda_produto_data` | Otimiza consultas por produto e data. |
| `idx_dim_produto_categoria` | Otimiza filtros por categoria de produto. |
| `idx_dim_data_ano` | Otimiza filtros por ano. |

> **Observação**
>
> Índices podem melhorar a performance das consultas, mas também aumentam o custo de escrita. Por isso, devem ser criados com base no padrão de uso dos relatórios.

---

## Etapa 8 - Aplicando SCD Tipo 1

Execute o arquivo:

```text
05-SCD-tipo1.sql
```

O **SCD Tipo 1** substitui o valor antigo pelo valor novo, sem preservar histórico.

Neste laboratório, a dimensão `dim_cliente` é atualizada.

Exemplo conceitual:

```text
Antes:
Empresa Epsilon | Sydney | NA | Austrália

Depois:
Empresa Epsilon | Recife | Pernambuco | Brasil
```

### Quando usar SCD Tipo 1?

Utilize SCD Tipo 1 quando o histórico da alteração não é relevante.

Exemplos:

- correção de erro cadastral;
- ajuste de grafia;
- atualização de informação sem necessidade de rastreabilidade histórica.

---

## Etapa 9 - Aplicando SCD Tipo 2

Execute o arquivo:

```text
06-SCD-tipo2.sql
```

O **SCD Tipo 2** preserva o histórico completo das alterações.

Neste laboratório, a dimensão `dim_produto` recebe colunas adicionais:

```text
data_inicio
data_fim
ativo
```

A lógica aplicada é:

1. identificar se houve mudança nos atributos do produto;
2. encerrar o registro atual;
3. marcar o registro antigo como inativo;
4. inserir um novo registro com os dados atualizados;
5. manter o histórico da alteração.

### Exemplo conceitual

```text
Produto atual:
Mouse | Acessórios | ativo = true

Após alteração:
Mouse | Acessórios   | ativo = false | data_fim preenchida
Mouse | Periféricos  | ativo = true  | novo registro
```

### Quando usar SCD Tipo 2?

Utilize SCD Tipo 2 quando o histórico das alterações precisa ser preservado.

Exemplos:

- mudança de categoria de produto;
- mudança de segmento de cliente;
- mudança de região comercial;
- análises históricas que dependem da versão correta da dimensão no tempo.

> **Atenção**
>
> Ao aplicar SCD Tipo 2, novas surrogate keys são criadas. Por isso, cargas futuras da tabela fato devem apontar para a versão correta da dimensão.

---

## Etapa 10 - Aplicando SCD Tipo 3

Execute o arquivo:

```text
07-SCD-tipo3.sql
```

O **SCD Tipo 3** armazena a versão atual e uma versão anterior do atributo.

Neste laboratório, a dimensão `dim_canal` recebe a coluna:

```text
regiao_anterior
```

A lógica aplicada é:

1. criar a coluna para armazenar o valor anterior;
2. gravar a região antiga em `regiao_anterior`;
3. atualizar a coluna `regiao` com o novo valor.

### Exemplo conceitual

```text
Canal: Telemarketing

regiao_anterior = América Latina
regiao          = LATAM
```

### Quando usar SCD Tipo 3?

Utilize SCD Tipo 3 quando é necessário armazenar apenas a versão anterior e a versão atual do dado.

Exemplos:

- comparação entre região antiga e nova;
- alteração pontual de classificação;
- cenários onde não é necessário manter histórico completo.

---

## Ordem Recomendada de Execução

Execute os arquivos nesta sequência:

```text
1. 01-modelo-fisico.sql
2. 02-etl-carga-dados.sql
3. 03-relatorios-view-function.sql
4. 04-indices.sql
5. 05-SCD-tipo1.sql
6. 06-SCD-tipo2.sql
7. 07-SCD-tipo3.sql
```

> **Importante**
>
> Os scripts de SCD devem ser executados após a criação do modelo e a carga inicial dos dados, pois dependem das tabelas já criadas e populadas.

---

## Validação do Ambiente

Após executar os scripts principais, utilize as consultas abaixo para validar o ambiente.

### Verificar dimensões

```sql
SELECT * FROM dw.dim_produto;
SELECT * FROM dw.dim_cliente;
SELECT * FROM dw.dim_canal;
SELECT * FROM dw.dim_data LIMIT 10;
```

### Verificar tabela fato

```sql
SELECT * FROM dw.fato_venda LIMIT 10;
```

### Verificar quantidade de registros na fato

```sql
SELECT COUNT(*) AS total_registros
FROM dw.fato_venda;
```

### Verificar vendas por produto e canal

```sql
SELECT *
FROM dw.vw_vendasporprodutocanal
ORDER BY nome_produto;
```

### Verificar vendas por cliente e período

```sql
SELECT *
FROM dw.vw_vendasporclienteperiodo
ORDER BY nome_cliente;
```

### Verificar relatório resumido

```sql
SELECT *
FROM dw.mv_relatoriovendasresumido
ORDER BY ano;
```

---

## Comandos Docker Úteis

### Verificar containers em execução

```bash
docker ps
```

### Acessar o container PostgreSQL

```bash
docker exec -it dw bash
```

### Acessar o PostgreSQL via terminal

```bash
docker exec -it dw psql -U dbuser -d dwprd
```

### Parar o container

```bash
docker stop dw
```

### Iniciar novamente o container

```bash
docker start dw
```

### Remover o container

```bash
docker rm -f dw
```

---

## Problemas Comuns

### Porta 5431 já está em uso

Se a porta `5431` já estiver ocupada, altere o mapeamento de porta no comando Docker.

Exemplo:

```bash
-p 5433:5432
```

Depois, no pgAdmin, utilize a nova porta:

```text
5433
```

---

### Erro ao criar schema porque já existe

Se o schema `dw` já existir, será necessário limpar o ambiente ou ajustar o script.

Para recriar tudo do zero:

```sql
DROP SCHEMA dw CASCADE;
```

Depois execute novamente:

```text
01-modelo-fisico.sql
```

---

### Erro de conexão no pgAdmin

Verifique:

- se o container está em execução;
- se a porta informada está correta;
- se usuário e senha estão corretos;
- se o banco `dwprd` foi criado.

Comando para validar:

```bash
docker ps
```

---

### Materialized View não atualiza automaticamente

Após novas cargas ou alterações nos dados, execute:

```sql
REFRESH MATERIALIZED VIEW dw.MV_RelatorioVendasResumido;
```

---

## Conceitos Praticados

Neste laboratório foram praticados os seguintes conceitos:

- Docker;
- PostgreSQL;
- pgAdmin;
- schema;
- Data Warehouse;
- modelagem dimensional;
- modelo estrela;
- tabela fato;
- tabelas dimensão;
- surrogate key;
- chave primária;
- chave estrangeira;
- procedures;
- views;
- materialized views;
- functions;
- índices;
- SCD Tipo 1;
- SCD Tipo 2;
- SCD Tipo 3.

---

## Conclusão

Este laboratório apresentou a criação de um Data Warehouse dimensional utilizando PostgreSQL em container Docker.

Foram desenvolvidas as principais etapas de um fluxo analítico: criação do modelo físico, carga de dados, geração de relatórios, otimização com índices e aplicação de técnicas de controle histórico em dimensões.

O projeto serve como base para estudos de modelagem dimensional, construção de Data Warehouses e fundamentos de Engenharia de Dados aplicados a bancos relacionais.