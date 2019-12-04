<?php

 include 'connect.php';
 
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
 $email = $_POST['email'];
 $password = $_POST['password'];
 
 $Sql_Query = "select * from users where  (email='$email' OR username='$email') and password = '$password'";
 
 $check = mysqli_fetch_array(mysqli_query($con,$Sql_Query));
 
 if(isset($check)){
     echo 'success';
 }
 else{
     echo 'invalid';
 }

 mysqli_close($con);

?>