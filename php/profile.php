<?php

 include 'connect.php';
 
 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);
 
 $data= array();
 
 $name = $_POST['name'];
 
 $Sql_Query = "select * from users where email='$name' OR username='$name'";
 $query = mysqli_query ($con,  $Sql_Query);
 
 while($result = mysqli_fetch_array ($query)){
     $data['username'] = $result['username'];
     $data['fname'] = $result['fname'];
     $data['sname'] = $result['sname'];
     $data['cardno'] = $result['cardno'];
     $data['email'] = $result['email'];
     
 }
 
 //displaying the data in json format 
 echo json_encode ($data);
 
 mysqli_close($con);

?>