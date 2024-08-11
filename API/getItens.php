<?php


    if (IsSet($_GET["token"])){
           
        include_once "../backend/connect.php";

        $query = 'CALL sp_api_view_itens("'.$_GET["token"].'");';
        
        $result = mysqli_query($conexao, $query);
        if(is_object($result)){
            if($result->num_rows > 0){			
                while($r = mysqli_fetch_assoc($result)) {
                    $rows[] = $r;
                }
            }        
        }

        $conexao->close();


//        $json = json_encode($rows);

        var_dump($rows);

        echo '<br><br><br>';

        foreach($rows as $key=>$value){

            echo $value;

            $rows[$key]['link'] = 'teste';


            echo($rows[$key]['link'].', ');
          }


//        print json_encode($rows);

    }


?>