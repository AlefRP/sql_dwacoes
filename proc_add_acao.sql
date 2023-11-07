-- Para usar: CALL AdicionarAcao('AAPL', 'Apple Inc.', 'Tecnologia', 'NASDAQ');

DELIMITER //

CREATE PROCEDURE AdicionarAcao(
    IN _codigo VARCHAR(10), 
    IN _nome_empresa VARCHAR(100), 
    IN _setor VARCHAR(50), 
    IN _mercado VARCHAR(50)
)
BEGIN
    INSERT INTO dim_acoes (codigo, nome_empresa, setor, mercado) 
    VALUES (_codigo, _nome_empresa, _setor, _mercado);
END //

DELIMITER ;