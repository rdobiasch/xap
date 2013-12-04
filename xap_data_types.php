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
                      dt.data_len, dt.data_prec, dt.enum_id, e.name as enum_name,
                      dt.class_id, c.name as class_name
               from xap_data_type dt left join xap_enumeration e on (e.xap_id=dt.enum_id)
                                     left join xap_class c on (c.xap_id=dt.class_id),
                    xap_enumeration_entry btv,
                    xap_enumeration  bte
               where bte.name='XAP_Data_Type_Enum'
                 and btv.enumeration_id=bte.xap_id
                 and btv.xap_id=dt.base_type
               order by dt.xap_id";

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
                $dt_enum_id= $row[5];
                $dt_enum= $row[6];
                $dt_class_id= $row[7];
                $dt_class=$row[8];
                
               echo "\n\n$dt_id $dt_name bastype=$dt_base_type length=$dt_data_len  prec=$dt_data_prec enum_id=$dt_enum_id enum=$dt_enum class_id=$dt_class_id class=$dt_class\n";
               
            
               
               
               
           }
         }
        
   echo "</pre>\n";
    
   $x->close_page();
  
 }

?>
