-- Contagem de ações negociadas por empresa e filtragem para aquelas com mais de 100 negociações
SELECT e.nome_empresa,
       COUNT(a.codigo) AS total_negociacoes
FROM dim_acoes AS a
INNER JOIN fatos_acoes AS f ON a.acao_id = f.acao_id
GROUP BY e.nome_empresa
HAVING COUNT(a.codigo) > 100
ORDER BY total_negociacoes DESC;

-- Relatório de desempenho de ações com preço de abertura, fechamento e volume por data
SELECT d.data, 
       a.nome_empresa, 
       m.nome AS nome_mercado, 
       f.preco_abertura, 
       f.preco_fechamento, 
       f.volume
FROM dim_tempo AS d
INNER JOIN fatos_acoes AS f ON d.data_id = f.data_id
INNER JOIN dim_acoes AS a ON f.acao_id = a.acao_id
INNER JOIN dim_mercado AS m ON f.mercado_id = m.mercado_id
WHERE d.data BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY d.data, a.nome_empresa;

-- Comparação do preço médio de fechamento atual com o preço médio do ano anterior
SELECT a.nome_empresa,
       AVG(f.preco_fechamento) AS media_fechamento_atual,
       (SELECT AVG(preco_fechamento) 
        FROM fatos_acoes AS f2
        INNER JOIN dim_tempo AS d2 ON f2.data_id = d2.data_id
        WHERE d2.ano = YEAR(CURDATE()) - 1 AND f2.acao_id = f.acao_id) AS media_fechamento_ano_anterior
FROM dim_acoes AS a
INNER JOIN fatos_acoes AS f ON a.acao_id = f.acao_id
INNER JOIN dim_tempo AS d ON f.data_id = d.data_id
WHERE d.ano = YEAR(CURDATE())
GROUP BY a.nome_empresa;

-- Listagem de ações sem negociações registradas
SELECT a.nome_empresa,
       IFNULL(SUM(f.volume), 0) AS volume_total
FROM dim_acoes AS a
LEFT JOIN fatos_acoes AS f ON a.acao_id = f.acao_id
GROUP BY a.nome_empresa
HAVING volume_total = 0;

-- Comparação cruzada do volume de ações entre todos os mercados
SELECT m1.nome AS mercado_origem,
       m2.nome AS mercado_comparacao,
       SUM(f1.volume) AS volume_origem,
       SUM(f2.volume) AS volume_comparacao
FROM dim_mercado AS m1
CROSS JOIN dim_mercado AS m2
INNER JOIN fatos_acoes AS f1 ON m1.mercado_id = f1.mercado_id
INNER JOIN fatos_acoes AS f2 ON m2.mercado_id = f2.mercado_id
WHERE m1.nome != m2.nome
GROUP BY mercado_origem, mercado_comparacao;