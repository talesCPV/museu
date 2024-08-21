/* ACERVO ITENS */

 DROP VIEW vw_itens_veiculo;
 CREATE VIEW vw_itens_veiculo AS
    SELECT 
        ACE.nome AS acervo,ITN.*,VCL.*
    FROM
        tb_acervo AS ACE
        INNER JOIN tb_item AS ITN
        LEFT JOIN tb_item_vcl AS VCL
        ON ACE.id = ITN.id_acervo
        AND VCL.id_item = ITN.id
        WHERE ITN.cat="VCL"
        GROUP BY ITN.id;
        
SELECT * FROM vw_itens_veiculo;

 DROP VIEW vw_itens_quadro;
  CREATE VIEW vw_itens_quadro AS
    SELECT 
		ACE.nome AS acervo, AUT.nome as autor,ITN.*,QDR.*
    FROM
		tb_acervo AS ACE
        INNER JOIN tb_item AS ITN
        INNER JOIN tb_autor AS AUT
        LEFT JOIN tb_item_qdr AS QDR
        ON QDR.id_item = ITN.id
        AND QDR.id_autor = AUT.id
        WHERE ITN.cat="QDR"
        AND id_quadro > 0
        GROUP BY ITN.id;
        
SELECT * FROM vw_itens_quadro;

 DROP VIEW vw_itens;
 CREATE VIEW vw_itens AS
    SELECT 
		ACE.nome AS acervo,
        ITN.*
    FROM
		tb_acervo AS ACE
	INNER JOIN
		tb_item AS ITN
	ON
		ACE.id = ITN.id_acervo;
        
SELECT * FROM vw_itens;

 DROP VIEW vw_autor;
 CREATE VIEW vw_autor AS
	SELECT *,
	(SELECT nome FROM tb_autor WHERE id=AUT.id_pai) AS pai,
	(SELECT nome FROM tb_autor WHERE id=AUT.id_mae) AS mae 
	FROM tb_autor AS AUT;
    
SELECT * FROM vw_autor;    

UPDATE tb_autor SET id_pai=null, id_mae=null WHERE id=1;