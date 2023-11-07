-- Esta view pode ser usada para ter uma visão rápida dos preços de abertura e fechamento das ações, junto com o volume negociado.
-- Uso: SELECT * FROM vw_relatorio_precos_acoes;
CREATE VIEW vw_relatorio_precos_acoes AS
SELECT a.nome_empresa,
       m.nome AS nome_mercado,
       d.data,
       f.preco_abertura,
       f.preco_fechamento,
       f.volume
FROM dim_acoes AS a
JOIN fatos_acoes AS f ON a.acao_id = f.acao_id
JOIN dim_tempo AS d ON f.data_id = d.data_id
JOIN dim_mercado AS m ON f.mercado_id = m.mercado_id;