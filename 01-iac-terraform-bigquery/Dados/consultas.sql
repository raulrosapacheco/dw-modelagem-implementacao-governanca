# Lab 1 - Automação da Infraestrutura de Consultas SQL com Terraform e BigQuery no Google Cloud Platform
# Relatórios do DW

# Consulta Simples - Listar o total de vendas por cliente

SELECT c.Nome_Cliente, ROUND(SUM(f.valor_venda),2) AS Total_Vendas
FROM `lab01-modelagem-dw.FJS_dw_dataset.tbClienteFJS` c
JOIN `lab01-modelagem-dw.FJS_dw_dataset.tbFatoFJS` f ON c.tbClienteFJS_id = f.tbClienteFJS_id
GROUP BY c.Nome_Cliente;


# Consulta Intermediária - Listar o total de vendas por categoria para cliente do Tipo_1

SELECT p.Categoria_Produto, ROUND(SUM(f.valor_venda),2) AS Total_Vendas
FROM `lab01-modelagem-dw.FJS_dw_dataset.tbProdutoFJS` p
JOIN `lab01-modelagem-dw.FJS_dw_dataset.tbFatoFJS` f ON p.tbProdutoFJS_id = f.tbProdutoFJS_id
JOIN `lab01-modelagem-dw.FJS_dw_dataset.tbClienteFJS` c ON f.tbClienteFJS_id = c.tbClienteFJS_id
WHERE c.Tipo_Cliente = 'Tipo_1'
GROUP BY p.Categoria_Produto;


# Consulta Avançada - Produtos com média de vendas superior a 600 no ano de 2023

SELECT p.Nome_Produto, ROUND(AVG(f.valor_venda),2) AS Media_Vendas
FROM `lab01-modelagem-dw.FJS_dw_dataset.tbClienteFJS` c
JOIN `lab01-modelagem-dw.FJS_dw_dataset.tbFatoFJS` f ON c.tbClienteFJS_id = f.tbClienteFJS_id
JOIN `lab01-modelagem-dw.FJS_dw_dataset.tbProdutoFJS` p ON f.tbProdutoFJS_id = p.tbProdutoFJS_id
WHERE f.data BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY p.Nome_Produto
HAVING ROUND(AVG(f.valor_venda),2) > 600
ORDER BY Media_Vendas DESC;
