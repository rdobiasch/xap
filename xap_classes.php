<?php
 
 include "xap.php";
 
 // set password=password('c0librI');
 
 
 $x= new XAP();
 $x->script="xap_classes.php";
 if ($x->start_page("classes"))
 {
  
   echo "<a href=\"index.php\">home</a><p>\n";
   
   echo "xap_classes<p>\n";
   
   echo "<pre>\n";
   
   
       $stmt = "select xap_id, name, table_name from xap_class order by name";

         $r= mysql_query($stmt, $x->db);
         if (!$r)
         {
           
           $x->error_message= mysql_error()."<p>\n";
           
           echo $x->error_message;
         }
         else
         {
           $cnt= 0;
           while ($row= mysql_fetch_row($r))
           {
                $cnt++;
                $class_id= $row[0];
                $class_name= $row[1];
	       
               echo "\n\n$class_id $class_name\n";
               
                $stmt2= "select ca.xap_id, ca.sort_id, ca.name, ca.description, dt.name 
                           from xap_class_attribute ca,
                                xap_data_type dt
                where ca.class_id=$class_id 
                  and dt.xap_id=ca.data_type
                  order by ca.sort_id";
                $r2= mysql_query($stmt2, $x->db);
         if (!$r2)
         {
           $x->error_message= mysql_error()."<p>\n";
         }
         else
         {
           $cnt= 0;
           while ($row= mysql_fetch_row($r2))
           {
                $cnt++;
                $a_id= $row[0];
                $a_sort_id= $row[1];
	        $a_name= $row[2];
	        $a_descr= $row[3];
	        $a_dt= $row[4];
               echo "      $a_sort_id  $a_name  type=$a_dt\n";
           }
         }
               
               
               
               
           }
         }
        
   echo "</pre>\n";
    
   $x->close_page();
  
 }

?>
