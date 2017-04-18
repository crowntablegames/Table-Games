<?php
    $host='localhost';
    $user='root';
    $password='';
     
    $connection = mysql_connect($host,$user,$password);
     
    $serviceRank = $_POST['a'];
    $comment = $_POST['b'];
    $dealer = $_POST['c'];
    $tableNumber = $_POST['d'];

 
     
    if(!$connection){
        die('Connection Failed');
    }
    else{
        $dbconnect = @mysql_select_db('sqlphpswiftdb', $connection);
         
        if(!$dbconnect){
            die('Could not connect to Database');
        }
        else{
            $query = "INSERT INTO `crownProto`.`customerFeedback` (`serviceRank`, `comment`,`dealer`,`tableNumber`)
                VALUES ('$serviceRank','$comment','$dealer','$tableNumber');";
            mysql_query($query, $connection) or die(mysql_error());
             
            echo 'Successfully added.';
            echo $query;
        }
    }
?>