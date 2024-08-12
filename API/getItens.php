<?php

    include_once "CORS.php";

    if (IsSet($_POST["token"])){
           
        include_once "../backend/connect.php";
        
        $query = 'CALL sp_api_view_itens("'.$_POST["token"].'");';
                
        $result = mysqli_query($conexao, $query);
        if(is_object($result)){
            if($result->num_rows > 0){			
                while($r = mysqli_fetch_assoc($result)) {
                    $rows[] = $r;
                }
            }        
        }

        $conexao->close();

        foreach($rows as $key=>$value){
            
            $path ='files/'. $rows[$key]['id_acervo'].'/'.$rows[$key]['id'].'/';
            $files = scandir(getcwd()."/../$path");

            $rows[$key]['files'] = [];
            for($i=2; $i<count($files); $i++){          
                array_push($rows[$key]['files'],$URL_FOLDER.$path.$files[$i]);
            }
             
          }

//        var_dump($rows);
        print json_encode($rows, JSON_UNESCAPED_UNICODE);

    }


?>