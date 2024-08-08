<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03");', // ID, EMAIL, PASS, ACCESS
        "USR-2"  => 'CALL sp_updatePass(@hash,"x00");', // PASS
        "USR-3"  => 'CALL sp_check_usr_mail(@access,@hash);', //

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

    );

?>