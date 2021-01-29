<?php
  require_once('dbconnect.php');

  if($_SERVER['REQUEST_METHOD']=='POST'){
    $input = (array) json_decode(file_get_contents('php://input'), TRUE);
    login_details($conn,$input);
  }


  function login_details($conn,$data){
     $email = $data['email_address'];
     $password = $data['password'];
     //echo json_encode($data);
     $query = $conn->query("SELECT * FROM viduradb.tbl_user WHERE email_address='".$email."' and password='".$password."'");
     //$query = $conn->query("SELECT * FROM viduradb.tbl_user");
     
     $result = array();
     while($fetchData=$query->fetch_assoc()){
         $result[]=$fetchData;
     }
     if(!empty($result)){
         echo "true";
     }else{
         echo "false";
     }
  }
?>