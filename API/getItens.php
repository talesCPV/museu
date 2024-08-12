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

        foreach($rows as $key=>$value){

            $rows[$key]['files'] = [];
    
            $dir = '/../files/'. $rows[$key]['id_acervo'].'/'.$rows[$key]['id'].'/';
            $files = scandir(getcwd().$dir);

            $arr_dir = explode("/", getcwd() );
            $path = $arr_dir[count($arr_dir)-2].'/files/'. $rows[$key]['id_acervo'].'/'.$rows[$key]['id'].'/';

    
            for($i=2; $i<count($files); $i++){
//                echo $path. $files[$i];                 
                array_push($rows[$key]['files'],$path. $files[$i]);
            }
             
          }

        var_dump($rows);
//        print json_encode($rows, JSON_UNESCAPED_UNICODE);

    }


?>