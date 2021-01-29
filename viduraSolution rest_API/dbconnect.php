<?php
  define('HOST','localhost:3308');
  define('USER','root');
  define('PASSWORD','');
  define('DATABASE','viduradb');

  $conn = mysqli_connect(HOST,USER,PASSWORD,DATABASE) or die("Cannot connect to the database");
?>