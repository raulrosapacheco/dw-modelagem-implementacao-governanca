# ☁️ Provisionamento de Data Warehouse no Google BigQuery com Terraform

Este projeto demonstra como utilizar **Terraform** para automatizar a criação de um ambiente analítico no **Google Cloud Platform (GCP)**.

Durante o laboratório é provisionado um Data Warehouse no BigQuery, realizada a carga automática de arquivos CSV armazenados no Cloud Storage e executadas consultas SQL para validação dos dados.

Todo o ambiente é criado utilizando **Infraestrutura como Código (IaC)**.

---

# 🎯 Objetivos

Neste projeto foram praticados conceitos relacionados a:

- Infraestrutura como Código (IaC)
- Terraform
- Docker
- Google Cloud Platform
- BigQuery
- Cloud Storage
- Google Cloud CLI
- Provisionamento automatizado
- Carga de dados
- SQL Analítico

---

# 📂 Estrutura do Projeto

```text
.
├── Dockerfile
│
├── Dados/
│   ├── tbClienteFJS.csv
│   ├── tbProdutoFJS.csv
│   └── tbFatoFJS.csv
│
├── Lab1/
│   └── main.tf
│
├── relatorios.sql
├── README.md
├── .gitignore
└── LICENSE
```

---

# 🏗 Arquitetura da Solução

```text
                Docker

                   │

                   ▼

          Google Cloud CLI

                   │

                   ▼

              Terraform

                   │

                   ▼

         Google Cloud Storage

                   │

                   ▼

           BigQuery Dataset

                   │

                   ▼

            BigQuery Tables

                   │

                   ▼

        Importação dos arquivos CSV

                   │

                   ▼

          Consultas SQL Analíticas
```

---

# 📖 Conteúdo do Projeto

## Dockerfile

Responsável pela criação da imagem Docker contendo todas as ferramentas necessárias para execução do laboratório.

Ferramentas instaladas:

- Ubuntu
- Terraform
- Google Cloud CLI
- Curl
- Wget
- Utilitários Linux

---

## Pasta Dados

Contém os arquivos CSV utilizados para carga do Data Warehouse.

Arquivos disponíveis:

- tbClienteFJS.csv
- tbProdutoFJS.csv
- tbFatoFJS.csv

Esses arquivos são enviados para um bucket no Google Cloud Storage antes da execução do Terraform.

---

## Pasta Lab1

Contém o código Terraform responsável pelo provisionamento da infraestrutura.

Arquivo:

```
main.tf
```

Recursos provisionados:

- Dataset BigQuery
- Tabela Cliente
- Tabela Produto
- Tabela Fato
- Jobs de importação dos arquivos CSV

---

## relatorios.sql

Contém consultas SQL para validação dos dados carregados no BigQuery.

Foram desenvolvidas consultas em três níveis:

- Consulta simples
- Consulta intermediária
- Consulta avançada

---

# 🚀 Execução do Projeto

## 1. Construir a imagem Docker

```bash
docker build -t image-modelagem:lab1 .
```

---

## 2. Criar o container

```bash
docker run -dit \
--name dw-lab1 \
-v <CAMINHO_LOCAL>:/lab1 \
image-modelagem:lab1 \
/bin/bash
```

---

## 3. Acessar o container

```bash
docker exec -it dw-lab1 /bin/bash
```

Entrar na pasta do projeto:

```bash
cd /lab1/Lab1
```

---

## 4. Criar o projeto no Google Cloud

Projeto utilizado:

```
lab01-modelagem-dw
```

---

## 5. Criar um Bucket no Cloud Storage

Criar um bucket chamado:

```
fjs-modeling-p1
```

Configuração utilizada:

- Multi-region
- Classe Standard
- Acesso público bloqueado

Após criar o bucket, enviar os arquivos presentes na pasta:

```
Dados/
```

---

## 6. Autenticação

Realizar login:

```bash
gcloud auth application-default login
```

Após concluir:

```bash
gcloud auth application-default set-quota-project lab01-modelagem-dw
```

---

## 7. Inicializar o Terraform

```bash
terraform init
```

---

## 8. Provisionar a infraestrutura

```bash
terraform apply
```

---

## 9. Executar consultas SQL

Após o provisionamento:

- Abrir o BigQuery Studio
- Executar as consultas presentes em:

```
relatorios.sql
```

---

## 10. Remover a infraestrutura

```bash
terraform destroy
```

---

# 📊 Recursos Criados

Durante a execução do Terraform são criados automaticamente:

- Dataset BigQuery
- Tabela Cliente
- Tabela Produto
- Tabela Fato
- Jobs de importação dos CSVs

---

# 💡 Principais Conceitos Praticados

- Terraform
- Docker
- Google Cloud Platform
- BigQuery
- Cloud Storage
- Dataset
- Tabelas Analíticas
- Infraestrutura como Código
- SQL Analítico
- Provisionamento Automatizado

---

# 🛠 Tecnologias Utilizadas

- Terraform
- Docker
- Google Cloud Platform
- BigQuery
- Google Cloud Storage
- Google Cloud CLI
- SQL

---

# 🧠 O que aprendi

Ao concluir este laboratório fui capaz de:

- Criar um ambiente Docker para execução do Terraform.
- Configurar autenticação utilizando o Google Cloud CLI.
- Provisionar recursos no Google BigQuery utilizando Terraform.
- Automatizar a criação de datasets e tabelas.
- Carregar dados automaticamente a partir de arquivos CSV armazenados no Cloud Storage.
- Executar consultas analíticas no BigQuery.
- Remover toda a infraestrutura utilizando Terraform.

---

# 🙏 Créditos

Os conhecimentos e desafios documentados neste repositório fazem parte da minha jornada de aprendizado em Infraestrutura como Código, Computação em Nuvem e Engenharia de Dados.

Grande parte deste conteúdo foi estudada por meio das formações da **Data Science Academy (DSA)**, cujos cursos têm contribuído significativamente para o desenvolvimento das minhas habilidades em Engenharia de Dados, Cloud Computing e Inteligência Artificial.

A documentação, organização do projeto e adaptações presentes neste repositório foram elaboradas por mim como material de estudo, consulta e revisão futura.