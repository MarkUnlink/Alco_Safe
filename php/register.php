<?php
if($_SERVER['REQUEST_METHOD']=='POST'){

 include 'connect.php';

 $con = mysqli_connect($HostName,$HostUser,$HostPass,$DatabaseName);

 $username = $_POST['username'];
 $fname = $_POST['fname'];
 $sname = $_POST['sname'];
 $cardno = $_POST['cardno'];
 $email = $_POST['email'];
 $password = $_POST['password'];
 
 $profilepic = $_POST['profilepic'];
 
 $decodedimage = base64_decode("$profilepic");


 $CheckSQL = "SELECT * FROM users WHERE username='$username'";
 
 $check = mysqli_fetch_array(mysqli_query($con,$CheckSQL));
 
 if(isset($check)){

 echo 'account already exists';

 }
 else{ 
    $Sql_Query = "INSERT INTO users (username,fname,sname,cardno,email,password) VALUES ('$username','$fname','$sname','$cardno','$email','$password')";
    
    file_put_contents("users/".$username.".jpg", $decodedimage);

 if(mysqli_query($con,$Sql_Query))
 {
  echo 'account created';
 }
 else
 {
  echo 'something went wrong';
 }
 }
}
 mysqli_close($con);
?>