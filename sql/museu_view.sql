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

 DROP VIEW vw_tokens;
 CREATE VIEW vw_tokens AS
	SELECT USR.email AS owner,ACV.nome AS acervo,ACS.*
	FROM tb_acesso AS ACS
	INNER JOIN tb_usuario AS USR
	INNER JOIN tb_acervo AS ACV
	ON ACS.id_owner = USR.id
	AND ACS.id_acervo = ACV.id;
    
SELECT * FROM vw_tokens;