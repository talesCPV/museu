 DROP TABLE tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(64) NOT NULL,
    nome varchar(30) NOT NULL DEFAULT "",
    token varchar(64) DEFAULT NULL,
    access int(11) DEFAULT -1,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ALTER TABLE tb_usuario ADD nome varchar(30) NOT NULL DEFAULT ""; 
INSERT INTO tb_usuario (email,hash,access)VALUES("adm@museu.com.br","61daf013f06616eb51b330e6c9e6bab63ad387d49b7cbb6fdb7a4aa3a5926f3d",0);
UPDATE tb_usuario SET nome="Tales C. Dantas" WHERE id=1;

 DROP TABLE tb_usr_perm_perfil;
CREATE TABLE tb_usr_perm_perfil (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(30) NOT NULL,
    perm varchar(50) NOT NULL DEFAULT "0",
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_acesso;
CREATE TABLE tb_acesso (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(64) NOT NULL,
    token varchar(64) DEFAULT NULL,
    access int(11) DEFAULT -1,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


 DROP TABLE tb_mail;
CREATE TABLE tb_mail (
	data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    id_from int(11) NOT NULL,
    id_to int(11) NOT NULL,
    message varchar(1000),
    looked boolean DEFAULT 0,
    FOREIGN KEY (id_from) REFERENCES tb_usuario(id),
    FOREIGN KEY (id_to) REFERENCES tb_usuario(id),
    PRIMARY KEY (data,id_from)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_calendario;
CREATE TABLE tb_calendario (
    id_user int(11) NOT NULL,
    data_agd date NOT NULL,
    obs varchar(255),
    PRIMARY KEY (id_user,data_agd)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* ACERVO */

 DROP TABLE tb_acervo;
CREATE TABLE tb_acervo (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(90) NOT NULL,
    lat double DEFAULT NULL,
    lon double DEFAULT NULL,
	pais varchar(25) DEFAULT NULL,
    uf varchar(2) DEFAULT NULL,
	cidade varchar(60) DEFAULT NULL,
    rua varchar(60) DEFAULT NULL,
    num varchar(6) DEFAULT NULL,
    comp varchar(60) DEFAULT NULL,
    bairro varchar(60) DEFAULT NULL,
    tel varchar(11) DEFAULT NULL,
    email varchar(80) DEFAULT NULL,
    obs varchar(255) DEFAULT NULL,
    cep varchar(8) DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_item;
CREATE TABLE tb_item (
    id int(11) NOT NULL AUTO_INCREMENT,
    id_acervo int(11) NOT NULL,
    nome varchar(90) NOT NULL,
	cat varchar(3) NOT NULL,
    obs varchar(255) DEFAULT NULL,
    FOREIGN KEY (id_acervo) REFERENCES tb_acervo(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_item_vcl;
CREATE TABLE tb_item_vcl (
    id_veiculo int(11) NOT NULL AUTO_INCREMENT,
    id_item int(11) NOT NULL,
	pais varchar(25) DEFAULT NULL,
    marca varchar(20) DEFAULT NULL,
	ano varchar(4) DEFAULT NULL,
    modelo varchar(30) DEFAULT NULL,
    chassi varchar(20) DEFAULT NULL,
    placa varchar(10) DEFAULT NULL,
    tipo varchar(20) DEFAULT NULL,
    cor varchar(15) DEFAULT NULL,
    cilindros int DEFAULT NULL,
    cilindrada double DEFAULT NULL,
    pot_hp double DEFAULT NULL,
    vel_max double DEFAULT NULL,
    alt double DEFAULT NULL,
    larg double DEFAULT NULL,
    comp double DEFAULT NULL,
    entre_eixo double DEFAULT NULL,
    portas int DEFAULT NULL,
    lugares int DEFAULT NULL,
	FOREIGN KEY (id_item) REFERENCES tb_item(id),
    PRIMARY KEY (id_veiculo)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

--  ALTER TABLE tb_item_vcl ADD placa varchar(10) DEFAULT NULL AFTER chassi; 