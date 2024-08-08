DROP VIEW vw_analise_frota;
 CREATE VIEW vw_analise_frota AS
    SELECT 
        `ANA`.`id` AS `id`,
        `ANA`.`id_emp` AS `id_emp`,
        `ANA`.`data_analise` AS `data_analise`,
        `ANA`.`num_carro` AS `num_carro`,
        `ANA`.`exec` AS `exec`,
        `ANA`.`func` AS `func`,
        `ANA`.`local` AS `local`,
        `ANA`.`valor` AS `valor`,
        `ANA`.`obs` AS `obs`,
        `ANA`.`serv_exec` AS `serv_exec`,
        `EMP`.`fantasia` AS `empresa`,
        EMP.cnpj,
        EMP.endereco,
        EMP.num,
        EMP.cidade,
        EMP.estado
    FROM
        (`tb_analise_frota` `ANA`
        JOIN `tb_empresa` `EMP` ON ((`ANA`.`id_emp` = `EMP`.`id`)));
        
SELECT * FROM vw_analise_frota;