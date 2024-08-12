<?php

    // Allow from any origin
    if (isset($_SERVER['HTTP_ORIGIN'])) {
        // Decide if the origin in $_SERVER['HTTP_ORIGIN'] is one
        // you want to allow, and if so:
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Max-Age: 86400');    // cache for 1 day
    }
    
    // Access-Control headers are received during OPTIONS requests
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        
        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
            // may also be using PUT, PATCH, HEAD etc
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
        
        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
            header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    
        exit(0);
    }

    

    if (IsSet($_POST["token"])){
           
        include_once "../backend/connect.php";

        $URL = "https://$_SERVER[HTTP_HOST]/";
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

            $rows[$key]['files'] = [];
    
            $dir = '/../files/'. $rows[$key]['id_acervo'].'/'.$rows[$key]['id'].'/';
            $files = scandir(getcwd().$dir);

            $arr_dir = explode("/", getcwd() );
            $path = $arr_dir[count($arr_dir)-2].'/files/'. $rows[$key]['id_acervo'].'/'.$rows[$key]['id'].'/';

    
            for($i=2; $i<count($files); $i++){          
                array_push($rows[$key]['files'],$URL. $path. $files[$i]);
            }
             
          }

//        var_dump($rows);
        print json_encode($rows, JSON_UNESCAPED_UNICODE);

    }


?>