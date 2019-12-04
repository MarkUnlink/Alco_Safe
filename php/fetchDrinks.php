<?php

 include 'connect.php';
 
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
 $data= array();
 
 $pcode = $_POST['pcode'];
 
 $Sql_Query = "select * from drinks where pcode='$pcode'";
 $query = mysqli_query ($con,  $Sql_Query);
 
 while($result = mysqli_fetch_array ($query)){
     $data['pcode'] = $result['pcode'];
     $data['name'] = $result['name']; 
     $data['price'] = $result['price'];           
     
 }
 
 //displaying the data in json format 
 echo json_encode ($data);
 
 mysqli_close($con);

?>