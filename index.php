
<?php

include "xap.php"; 

 
 $x= new XAP();
 $x->script="index.php";
 
 if ($x->start_page("welcome"))
 {
  
   ?>
   
   <ul>
     <li><a href="xap_enums.php">enums</?>
   </ul>
   
   <?
 $x->close_page();
  
 }
?>




