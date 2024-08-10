/* FUNCTIONS */

 DROP PROCEDURE sp_getHash;
DELIMITER $$
	CREATE PROCEDURE sp_getHash(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SELECT SHA2(CONCAT(Iemail, Isenha), 256) AS HASH;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_allow;
DELIMITER $$
	CREATE PROCEDURE sp_allow(
		IN Iallow varchar(80),
		IN Ihash varchar(64)
    )
	BEGIN    
		SET @access = (SELECT IFNULL(access,-1) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET @quer =CONCAT('SET @allow = (SELECT ',@access,' IN ',Iallow,');');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
	END $$
DELIMITER ;

/* LOGIN */

 DROP PROCEDURE sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @hash = (SELECT SHA2(CONCAT(Iemail, Isenha), 256));
		SELECT *, IF(nome="",SUBSTRING_INDEX(email,"@",1),nome) AS nome FROM tb_usuario WHERE hash=@hash;
	END $$
DELIMITER ;

/* USER */

 DROP PROCEDURE sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Iemail varchar(80),
		IN Isenha varchar(30),
        IN Iaccess int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iemail="")THEN
				DELETE FROM tb_mail WHERE de=Iid OR para=Iid;
				DELETE FROM tb_user WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_usuario (email,hash,access)VALUES(Iemail,SHA2(CONCAT(Iemail, Isenha), 256),Iaccess);            
                ELSE
					IF(Isenha="")THEN
						UPDATE tb_usuario SET email=Iemail, access=Iaccess WHERE id=Iid;
                    ELSE
						UPDATE tb_usuario SET email=Iemail, hash=SHA2(CONCAT(Iemail, Isenha), 256), access=Iaccess WHERE id=Iid;
                    END IF;
                END IF;
            END IF;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_viewUser;
DELIMITER $$
	CREATE PROCEDURE sp_viewUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT id,email,access, IF(access=0,"ROOT",IFNULL((SELECT nome FROM tb_usr_perm_perfil WHERE USR.access = id),"DESCONHECIDO")) AS perfil FROM tb_usuario AS USR WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS email, 0 AS access;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_updatePass;
DELIMITER $$
	CREATE PROCEDURE sp_updatePass(	
		IN Ihash varchar(64),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @call_id = (SELECT IFNULL(id,0) FROM tb_user WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@call_id > 0)THEN
			UPDATE tb_user SET hash = SHA2(CONCAT(email, Isenha), 256) WHERE id=@call_id;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

/* PERMISSÂO */

 DROP PROCEDURE sp_set_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_set_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        In Iid int(11),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			IF(Iid = 0 AND Inome != "")THEN
				INSERT INTO tb_usr_perm_perfil (nome) VALUES (Inome);
            ELSE
				IF(Inome = "")THEN
					DELETE FROM tb_usr_perm_perfil WHERE id=Iid;
				ELSE
					UPDATE tb_usr_perm_perfil SET nome = Inome WHERE id=Iid;
                END IF;
            END IF;			
			SELECT * FROM tb_usr_perm_perfil;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_view_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			SET @quer = CONCAT('SELECT * FROM tb_usr_perm_perfil WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS nome;
        END IF;
	END $$
DELIMITER ;

/* CALENDAR */

 DROP PROCEDURE sp_view_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_view_calendar(	
		IN Ihash varchar(64),
		IN IdataIni date,
		IN IdataFin date
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT * FROM tb_calendario WHERE id_user=@id_call AND data_agd>=IdataIni AND data_agd<=IdataFin;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_set_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_set_calendar(	
		IN Ihash varchar(64),
		IN Idata date,
		IN Iobs varchar(255)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			SET @exist = (SELECT COUNT(*) FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata);
			IF(@exist AND Iobs = "")THEN
				DELETE FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata; 
			ELSE
				INSERT INTO tb_calendario (id_user, data_agd, obs) VALUES(@id_call, Idata, Iobs)
                ON DUPLICATE KEY UPDATE obs=Iobs;
			END IF;
        END IF;
	END $$
DELIMITER ;

/* MAIL */

 DROP PROCEDURE sp_check_usr_mail;
DELIMITER $$
	CREATE PROCEDURE sp_check_usr_mail(
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call>0)THEN        
			SELECT COUNT(*) AS new_mail FROM tb_mail WHERE id_to = @id_call AND looked=0;
		ELSE
			SELECT 0 AS new_mail ;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_set_mail;
DELIMITER $$
	CREATE PROCEDURE sp_set_mail(	
		IN Ihash varchar(64),
        IN Iid_to int(11),
		IN Imessage varchar(512)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			INSERT INTO tb_mail (id_from,id_to,message) VALUES (@id_call,Iid_to,Imessage);
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_mail;
DELIMITER $$
	CREATE PROCEDURE sp_view_mail(	
		IN Ihash varchar(64),
        IN Isend boolean
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call > 0)THEN
			IF(Isend)THEN
				SELECT MAIL.*, USR.email AS mail_from
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_from = USR.id AND MAIL.id_to = @id_call;            
            ELSE
				SELECT MAIL.*, USR.email AS mail_to
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_to = USR.id AND MAIL.id_from = @id_call;            
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_del_mail;
DELIMITER $$
	CREATE PROCEDURE sp_del_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			DELETE FROM tb_mail WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_mark_mail;
DELIMITER $$
	CREATE PROCEDURE sp_mark_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			UPDATE tb_mail SET looked=1 WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_all_mail_adress;
DELIMITER $$
	CREATE PROCEDURE sp_all_mail_adress(	
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT id,email FROM tb_usuario WHERE id != @id_call ORDER BY email ASC;
	END $$
DELIMITER ;

/* ACERVO */

 DROP PROCEDURE sp_view_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_view_acervo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM tb_acervo WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_set_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_set_acervo(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Inome varchar(90),
		IN Ilat double,
		IN Ilon double,
		IN Ipais varchar(25),
		IN Iuf varchar(2),
		IN Icidade varchar(60),
		IN Irua varchar(60),
		IN Inum varchar(6),
		IN Icomp varchar(60),
		IN Ibairro varchar(60),
		IN Itel varchar(11),
		IN Iemail varchar(80),
		IN Iobs varchar(255),
		IN Icep varchar(8)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iid=0)THEN
				INSERT INTO tb_acervo (nome,lat,lon,pais,uf,cidade,rua,num,comp,bairro,tel,email,obs,cep)
				VALUES (Inome,Ilat,Ilon,Ipais,Iuf,Icidade,Irua,Inum,Icomp,Ibairro,Itel,Iemail,Iobs,Icep);
            ELSE 
				IF(Inome="")THEN
					DELETE FROM tb_acervo WHERE id=Iid;
				ELSE
					UPDATE tb_acervo
					SET nome=Inome,lat=Ilat,lon=Ilon,pais=Ipais,uf=Iuf,cidade=Icidade,rua=Irua,
                    num=Inum,comp=Icomp,bairro=Ibairro,tel=Itel,email=Iemail,obs=Iobs,cep=Icep
					WHERE id=Iid;
				END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_view_itens;
DELIMITER $$
	CREATE PROCEDURE sp_view_itens(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT * FROM vw_itens WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE sp_set_item_vcl;
DELIMITER $$
	CREATE PROCEDURE sp_set_item_vcl(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
        IN Iid_acervo int(11),
		IN Inome varchar(90),
		IN Icat varchar(3),
		IN Iobs varchar(255),
		IN Ipais varchar(25),
		IN Imarca varchar(20),
		IN Iano varchar(4),
		IN Imodelo varchar(30),
        IN Ichassi varchar(20),
        IN Iplaca varchar(10),
		IN Itipo varchar(20),
		IN Icor varchar(15),
		IN Icilindros int,
		IN Icilindrada double,
		IN Ipot_hp double,
        IN Ivel_max double,
		IN Ialt double,
		IN Ilarg double,
		IN Icomp double,
		IN Ientre_eixo double,
		IN Iportas int,
		IN Ilugares int
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iid=0)THEN
				INSERT INTO tb_item (id_acervo,nome,cat,obs)
				VALUES (Iid_acervo,Inome,Icat,Iobs);
                SET @id = (SELECT MAX(id) FROM tb_item);
                INSERT INTO tb_item_vcl (id_item,pais,marca,ano,modelo,chassi,placa,tipo,cor,cilindros,cilindrada,pot_hp,vel_max,alt,larg,comp,entre_eixo,portas,lugares)
                VALUES(@id,Ipais,Imarca,Iano,Imodelo,Ichassi,Iplaca,Itipo,Icor,Icilindros,Icilindrada,Ipot_hp,Ivel_max,Ialt,Ilarg,Icomp,Ientre_eixo,Iportas,Ilugares);                
            ELSE 
				IF(Inome="")THEN
					DELETE FROM tb_item WHERE id=Iid;
                    DELETE FROM tb_item_vcl WHERE id_item=Iid;
				ELSE
					UPDATE tb_item SET id_acervo=Iid_acervo,nome=Inome,cat=Icat,obs=Iobs WHERE id=Iid;
                    UPDATE tb_item_vcl SET pais=Ipais,marca=Imarca,ano=Iano,modelo=Imodelo,chassi=Ichassi,placa=Iplaca,tipo=Itipo,cor=Icor,cilindros=Icilindros,
                    cilindrada=Icilindrada,pot_hp=Ipot_hp,vel_max=Ivel_max,alt=Ialt,larg=Ilarg,comp=Icomp,entre_eixo=Ientre_eixo,portas=Iportas,lugares=Ilugares
                    WHERE id_item=Iid;
				END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;