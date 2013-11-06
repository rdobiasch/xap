<?php
 
 include "xap.php";
 
 // set password=password('c0librI');
 
 
 $x= new XAP();
 $x->script="xap_data_types.php";
 if ($x->start_page("data types"))
 {
  
   echo "<a href=\"index.php\">home</a><p>\n";
   
   echo "xap_data_types<p>\n";
   
   echo "<pre>\n";
   
   
       $stmt = "select dt.xap_id, dt.name, btv.entry_text as base_type_name, 
                      dt.data_len, dt.data_prec 
               from xap_data_type dt,
                    xap_enumeration_entry btv,
                    xap_enumeration  bte
               where bte.name='XAP_Data_Type_Enum'
                 and btv.enumeration_id=bte.xap_id
                 and btv.xap_id=dt.base_type
               order by dt.name";

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
                $dt_id= $row[0];
                $dt_name=$row[1];
                $dt_base_type= $row[2];
                $dt_data_len= $row[3];
                $dt_data_prec= $row[4];
                
               echo "\n\n$dt_id $dt_name $dt_base_type $dt_data_len  $dt_data_prec\n";
               
            
               
               
               
           }
         }
        
   echo "</pre>\n";
    
   $x->close_page();
  
 }

?>
