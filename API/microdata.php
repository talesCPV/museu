<?php

    include_once "CORS.php";

	if (IsSet($_POST["file"])){
        $file = getcwd().'/microdata/'.$_POST["file"];   
        if (file_exists($file)) {
            $fp = fopen($file, "r");
            $resp = "";
            while (!feof ($fp)) {
                $resp = $resp . fgets($fp,4096);
            }
            fclose($fp);
  
            print $resp;
        }            
  
    }
?>