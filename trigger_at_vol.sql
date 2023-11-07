-- Este trigger poderia ser usado para atualizar automaticamente o volume total de ações após cada nova inserção na tabela de fatos.
DELIMITER //

CREATE TRIGGER AtualizarVolumeTotalAposInsercao
AFTER INSERT ON fatos_acoes
FOR EACH ROW
BEGIN
    UPDATE dim_acoes
    SET volume_total = volume_total + NEW.volume
    WHERE acao_id = NEW.acao_id;
END //

DELIMITER ;
