<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03");', // ID, EMAIL, PASS, ACCESS
        "USR-2"  => 'CALL sp_updatePass(@hash,"x00");', // PASS
        "USR-3"  => 'CALL sp_check_usr_mail(@hash);', //

        /* ACCESS */
        "ACC-0" => 'CALL sp_set_acesso(@access,@hash,x00,"x01","x02","x03","x04","x05","x06","x07","x08");', //allow,hash,token,id_acervo,expira_em,ler,criar,alterar,deletar

        /* CALENDAR */
        "CAL-0"  => 'CALL sp_view_calendar(@hash,"x00","x01");', // DT_INI, DT_FIN
        "CAL-1"  => 'CALL sp_set_calendar(@hash,"x00","x01");', // DT_AGD, OBS

        /* MAIL */
        "MAIL-0"  => 'CALL sp_set_mail(@hash,"x00","x01");', // ID_TO, MESSAGE
        "MAIL-1"  => 'CALL sp_view_mail(@hash,x00);', // I_SEND
        "MAIL-2"  => 'CALL sp_all_mail_adress(@hash);', //      
        "MAIL-3"  => 'CALL sp_del_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO
        "MAIL-4"  => 'CALL sp_mark_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO

        /* SYSTEMA */
        "SYS-0"  => 'CALL sp_set_usr_perm_perf(@access,@hash,x00,"x01");', // ID, NOME
        "SYS-1"  => 'CALL sp_view_usr_perm_perf(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE

        /* ACERVO */
        "ACE-0"  => 'CALL sp_view_acervo(@access,@hash,"x00","x01","x02");', // FIELD, SIGNAL, VALUE
        "ACE-1"  => 'CALL sp_set_acervo(@access,@hash,x00,"x01","x02","x03","x04","x05","x06","x07","x08","x09","x10","x11","x12","x13","x14");', // id,nome,lat,lon,pais,uf,cidade,rua,num,comp,bairro,tel,email,obs,cep
        "ACE-2"  => 'CALL sp_view_itens(@access,@hash,"x00","x01","x02");', // FIELD, SIGNAL, VALUE
        "ACE-3"  => 'CALL sp_set_item_vcl(@access,@hash,x00,x01,"x02","x03","x04","x05","x06","x07","x08","x09","x10","x11","x12","x13","x14","x15","x16","x17","x18","x19","x20","x21","x22");', //  id,id_acervo,nome,cat,obs,pais,marca,ano,modelo,chassi,placa,tipo,cor,cilindros,cilindada,pot_hp,Vel_max,alt,larg,comp,entre_eixo,portas,passageiro

    );

?>