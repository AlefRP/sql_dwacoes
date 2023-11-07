-- Tabela Dimensão Calendario
CREATE TABLE dim_calendario (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    ano INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    UNIQUE KEY (data)
);

-- Tabela Dimensão Ações
CREATE TABLE dim_acoes (
    acao_id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nome_empresa VARCHAR(100) NOT NULL,
    setor VARCHAR(50),
    mercado VARCHAR(50),
    UNIQUE KEY (codigo)
);

-- Tabela Dimensão Mercado
CREATE TABLE dim_mercado (
    mercado_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    cidade VARCHAR(50),
    fuso_horario VARCHAR(50),
    UNIQUE KEY (nome)
);

-- Tabela de Fatos
CREATE TABLE fatos_acoes (
    transacao_id INT AUTO_INCREMENT PRIMARY KEY,
    data_id INT NOT NULL,
    acao_id INT NOT NULL,
    mercado_id INT NOT NULL,
    preco_abertura DECIMAL(10, 2),
    preco_fechamento DECIMAL(10, 2),
    volume BIGINT,
    FOREIGN KEY (data_id) REFERENCES dim_tempo(data_id),
    FOREIGN KEY (acao_id) REFERENCES dim_acoes(acao_id),
    FOREIGN KEY (mercado_id) REFERENCES dim_mercado(mercado_id)
);