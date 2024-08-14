/* ACERVO ITENS */

 DROP VIEW vw_itens_veiculo;
 CREATE VIEW vw_itens_veiculo AS
    SELECT 
        ITN.*,VCL.*
    FROM
        tb_item AS ITN
        LEFT JOIN tb_item_vcl AS VCL
        ON VCL.id_item = ITN.id;
        
SELECT * FROM vw_itens_veiculo;

 DROP VIEW vw_itens;
 CREATE VIEW vw_itens AS
    SELECT 
		ACE.nome AS acervo,
        VCL.*
    FROM
		tb_acervo AS ACE
    INNER JOIN
		vw_itens_veiculo AS VCL
    ON
		VCL.id_acervo = ACE.id
	GROUP BY 
		VCL.id_item;
        
SELECT * FROM vw_itens;

 DROP VIEW vw_autor;
 CREATE VIEW vw_autor AS
	SELECT *,
	(SELECT nome FROM tb_autor WHERE id=AUT.id_pai) AS pai,
	(SELECT nome FROM tb_autor WHERE id=AUT.id_mae) AS mae 
	FROM tb_autor AS AUT;
    
SELECT * FROM vw_autor;    