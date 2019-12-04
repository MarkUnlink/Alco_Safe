<?php

 include 'connect.php';
 
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
 $pcode = $_POST['pcode'];
 
 $Sql_Query = "select * from drinks where pcode='$pcode'";
 
 $check = mysqli_fetch_array(mysqli_query($con,$Sql_Query));
 
 if(isset($check)){
     echo 'success';
 }
 else{
     echo 'invalid';
 }

 mysqli_close($con);

?>