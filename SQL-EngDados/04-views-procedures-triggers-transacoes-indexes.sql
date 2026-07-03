# Modelagem, Implementação e Governança de Data Warehouses - Capítulo 4


-- Cria um schema de organização lógica de objetos no banco de dados
CREATE SCHEMA estudos02 AUTHORIZATION supraul;


-- Criação da tabela
CREATE TABLE estudos02.funcionarios (
    id_funcionario INT PRIMARY KEY,
    nome VARCHAR(50),
    departamento VARCHAR(50),
    data_contratacao DATE,
    salario DECIMAL(10, 2)
);


-- Inserção de dados
INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (100, 'José de Alencar', 'Engenharia de Dados - FJS', '2024-01-10', 25000.00);

INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (101, 'Machado de Assis', 'Data Science - FJS', '2024-02-10', 19000.00);

INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (102, 'Cecília Meireles', 'Engenharia de Dados - FJS', '2024-02-11', 22000.00);

INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (103, 'Carlos Drummond de Andrade', 'DataOps - FJS', '2024-02-12', 23400.00);

INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (104, 'Clarice Lispector', 'DataOps - FJS', '2024-02-13', 21800.00);


-- Seleção de dados
SELECT * 
FROM estudos02.funcionarios;


-- Tabela de projetos
CREATE TABLE estudos02.projetos (
    id_projeto INT PRIMARY KEY,
    nome_projeto VARCHAR(100),
    func_id INT REFERENCES estudos02.funcionarios(id_funcionario)
);


-- Inserção de dados
INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6001, 'Análise de Dados em Tempo Real', 101);

INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6002, 'Pipelines de CI/CD', 103);

INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6003, 'Extração de Dados de Bancos Transacionais', 104);

INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6004, 'Backup de Dados', 102);

INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6005, 'Levantamento de Requisitos', null);


-- Seleção de dados
SELECT * 
FROM estudos02.projetos;


-- View para retornar funcionários com salário maior que a média por departamento
CREATE OR REPLACE VIEW estudos02.vw_detalhes_funcionarios AS
WITH Salario_Departamento AS (
    SELECT departamento, ROUND(AVG(salario), 2) AS salario_medio
    FROM estudos02.funcionarios
    GROUP BY departamento
)
SELECT 
    f.id_funcionario, 
    f.nome, 
    f.departamento, 
    f.data_contratacao, 
    f.salario
FROM 
    estudos02.funcionarios f
INNER JOIN 
    Salario_Departamento sd ON f.departamento = sd.departamento
WHERE f.salario > sd.salario_medio;


-- Visualiza os dados
SELECT * FROM estudos02.vw_detalhes_funcionarios


-- View para retornar funcionários alocados em projetos
CREATE VIEW estudos02.vw_funcionarios_projetos AS
WITH FuncionariosProjetos AS (
    SELECT 
        f.id_funcionario,
        f.nome AS nome_funcionario,
        f.departamento,
        f.salario,
        COALESCE(p.id_projeto, 0) AS id_projeto,
        COALESCE(p.nome_projeto, 'NA') AS nome_projeto
    FROM 
        estudos02.funcionarios f
    LEFT JOIN 
        estudos02.projetos p ON f.id_funcionario = p.func_id
)
SELECT * FROM FuncionariosProjetos;


-- Visualiza os dados
SELECT * FROM estudos02.vw_funcionarios_projetos


-- Materialized View para retornar funcionários alocados em projetos
CREATE MATERIALIZED VIEW estudos02.mv_funcionarios_projetos AS
WITH FuncionariosProjetos AS (
    SELECT 
        f.id_funcionario,
        f.nome AS nome_funcionario,
        f.departamento,
        f.salario,
        COALESCE(p.id_projeto, 0) AS id_projeto,
        COALESCE(p.nome_projeto, 'NA') AS nome_projeto
    FROM 
        estudos02.funcionarios f
    LEFT JOIN 
        estudos02.projetos p ON f.id_funcionario = p.func_id
)
SELECT * FROM FuncionariosProjetos;


-- Visualiza os dados
SELECT * FROM estudos02.mv_funcionarios_projetos


-- Inserindo mais um funcionário
INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (105, 'Cora Coralina', 'Analytics Engineer - FJS', '2024-03-13', 29700.00);


-- Visualiza os dados
SELECT * FROM estudos02.vw_funcionarios_projetos


-- Visualiza os dados
SELECT * FROM estudos02.mv_funcionarios_projetos


-- Refresh
REFRESH MATERIALIZED VIEW estudos02.mv_funcionarios_projetos;


-- Visualiza os dados
SELECT * FROM estudos02.mv_funcionarios_projetos


-- SP que retorna o salário de cada funcionário com aumento de 5%
CREATE OR REPLACE PROCEDURE estudos02.aumenta_salario()
LANGUAGE plpgsql
AS $$
DECLARE 
    cur CURSOR FOR SELECT id_funcionario, nome, salario, salario * 1.05 AS salario_novo FROM estudos02.funcionarios;
BEGIN
    FOR record IN cur LOOP
        RAISE NOTICE 'Funcionario: %, Salario Atual: %, Novo Salario: %', 
                     record.nome, record.salario, record.salario_novo;
    END LOOP;
END;
$$;


-- Executa a SP
CALL estudos02.aumenta_salario();


-- Qual a Diferença Entre Stored Procedure e Function?

-- 1. Propósito e Uso:

-- Stored Procedure: Geralmente usada para realizar um conjunto de operações no banco de dados, 
-- como inserções, atualizações, deleções e consultas complexas. Pode ou não retornar um valor.

-- Function: Projetada para calcular e retornar um valor. 
-- É frequentemente usada em consultas SQL para realizar cálculos, formatar dados, etc.

-- 2. Retorno de Valores:

-- Stored Procedure: Pode retornar zero, um ou vários valores (através de parâmetros OUT ou conjuntos 
-- de resultados).

-- Function: Sempre retorna um único valor. Não pode retornar múltiplos conjuntos de resultados.

-- 3. Uso em SQL:

-- Stored Procedure: Não pode ser utilizada diretamente em instruções SQL como SELECT, WHERE, etc.

-- Function: Pode ser incorporada em instruções SQL.

-- 4. Natureza:

-- Stored Procedure: Mais procedimental, ideal para executar sequências de comandos e lógicas complexas.

-- Function: Mais funcional, concentrada em cálculos ou operações de dados.


-- Função que vai verificar se um projeto está sendo cadastrado sem funcionário associado
CREATE OR REPLACE FUNCTION estudos02.verifica_funcionario_projeto()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o ID do funcionário associado ao projeto é nulo
    IF NEW.func_id IS NULL THEN
        RAISE EXCEPTION 'Não é permitido inserir um projeto sem um funcionário associado.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger
CREATE TRIGGER trg_verifica_funcionario_projeto
BEFORE INSERT ON estudos02.projetos
FOR EACH ROW EXECUTE FUNCTION estudos02.verifica_funcionario_projeto();


-- Tentativa de inserir projeto sem funcionário associado
INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (6008, 'Pipeline de Integração de Dados', null);


-- Cria tabela
CREATE TABLE estudos02.historico_salarios (
    id_funcionario INT,
    salario_antigo DECIMAL(10, 2),
    data_mudanca TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Function
CREATE OR REPLACE FUNCTION estudos02.salva_salario_antigo()
RETURNS TRIGGER AS $$
BEGIN
    -- Insere o salário antigo na tabela historico_salarios
    IF OLD.salario IS DISTINCT FROM NEW.salario THEN
        INSERT INTO estudos02.historico_salarios (id_funcionario, salario_antigo)
        VALUES (OLD.id_funcionario, OLD.salario);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger
CREATE TRIGGER trg_salva_salario_antigo
BEFORE UPDATE ON estudos02.funcionarios
FOR EACH ROW EXECUTE FUNCTION estudos02.salva_salario_antigo();


-- Atualização de dados
UPDATE estudos02.funcionarios 
SET salario = 36500.00 
WHERE nome = 'Machado de Assis';


-- Verifica os dados
SELECT * FROM estudos02.historico_salarios;


-- Controle de Transações

-- Início da transação
BEGIN;

-- Inserindo um novo funcionário
INSERT INTO estudos02.funcionarios (id_funcionario, nome, departamento, data_contratacao, salario)
VALUES (106, 'Jorge Amado', 'Desenvolvimento', '2024-01-01', 15000.00);

-- Tentativa de inserir um projeto associado ao funcionário
INSERT INTO estudos02.projetos (id_projeto, nome_projeto, func_id)
VALUES (7777, 'Projeto Alpha', 106);

-- Commit ou Rollback
COMMIT;
-- ROLLBACK; em caso de erro ou necessidade de desfazer as operações


-- Explain
EXPLAIN WITH FuncionariosProjetos AS (
    SELECT 
        f.nome AS nome_funcionario,
        f.departamento,
        f.salario,
        COALESCE(p.id_projeto, 0) AS id_projeto,
        COALESCE(p.nome_projeto, 'NA') AS nome_projeto
    FROM 
        estudos02.funcionarios f
    LEFT JOIN 
        estudos02.projetos p ON f.id_funcionario = p.func_id
)
SELECT * 
FROM FuncionariosProjetos
WHERE salario > 20000;


-- Criação de índice
CREATE INDEX idx_funcionarios_id ON estudos02.funcionarios (id_funcionario);
CREATE INDEX idx_salario ON estudos02.funcionarios (salario);


-- DROP
DROP INDEX estudos02.idx_funcionarios_id;




