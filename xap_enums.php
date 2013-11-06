<?php
 
 include "xap.php";
 
 // set password=password('c0librI');
 
 
 $x= new XAP();
 $x->script="xap_enums.php";
 if ($x->start_page("enums"))
 {
  
   echo "<a href=\"index.php\">home</a><p>\n";
   
   echo "xap_enums<p>\n";
   
   echo "<pre>\n";
   
   
       $stmt = "select xap_id, name, description from xap_enumeration order by name";

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
                $enum_id= $row[0];
                $name= $row[1];
	        $description= $row[2];
               echo "$enum_id $name $description<br>\n";
               
                $stmt2= "select entry_id, entry_text, description from xap_enumeration_entry where enumeration_id=$enum_id order by entry_id";
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
                $entry_id= $row[0];
                $entry_text= $row[1];
	        $entry_description= $row[2];
               echo "      $entry_id $entry_text $entry_description\n";
           }
         }
               
               
               
               
           }
         }
        
   echo "</pre>\n";
    
   $x->close_page();
  
 }

?>
