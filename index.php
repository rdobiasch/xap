
<?php

include "xap.php"; 

 
 $x= new XAP();
 $x->script="index.php";
 
 if ($x->start_page("welcome"))
 {
  
   ?>
   
   <ul>
     <li><a href="xap_enums.php">enums</a>
     <li><a href="xap_data_types.php">data types</a>
     <li><a href="xap_classes.php">classes</a>
   </ul>
   
   <?
 $x->close_page();
  
 }
?>




