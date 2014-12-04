<?php
 
include "xap.php";
include "xap_table.php";
 
# 2014-09-12

# function to be performed by script like insert, edit ....
#
# if function is empty, the record should be just displayed
#
# func=create   .... display input dialog, data will be
#                    sent to same script with func=insert
# func=insert   .... data is taken from post request
#                    and a new record is to be created in the database
#
# func=edit     .... display input dialog with current data from
#                    record. Data will be sent to same script
#                    with func=update
#
# func=update   .... data is taken from post request
#                    and record is to be updated in the database
#
# func=delete   .... user will be asked if the record shall really
#                    be deleted from db
#
# func=purge    .... record will be deleted from db.
#                    user will be informed on success and link
#                    should point her/him to record list script.
#




$badInput=0;           # set to 1 if input in form is not ok
$skipInserOrUpdate=0;  # set to one if insert or update should not
                          #   be performed (doe to bad input data, ...)
$skipDisplay=0;        # set to one if the record should not be displayed
                          #   e.g. because of entry form beeing displayed 
                          #   anyway.
                          
                          

$nSysCols=1;  # number of system columns selected (e.g. xap_id, xap_cre_dat, ...)                          
                          
$x= new XAP();
$x->script="xap_generic.php";
 
#if (isset($_GET["class"])) 
# {$class_name= $_GET["class"];} 
# 	 else {
# 	   if (isset($_POST["class"])) { $class_name= $_POST["class"]; } 
# 	   }
 
$class_name= $x->get_param("class", "");

 if (isset($_GET["func"])) {$func= $_GET["func"]; } else {$func="list"; }
 if (isset($_GET["id"]))   {$id=   $_GET["id"];   } else {$id=0;        }

 
 
 

 
 if ($x->start_page("generic $class_name"))
 {
  
   echo "<a href=\"index.php\">home</a><p>\n";
   
   echo "xap_generic  $class_name  $func<p>\n";
   
   echo "<pre>\n";
   
  
   $sel_stmt = "select xap_id ";
   $nSysCols= 1; # number of system columns
   
   $stmt= "select a.name, c.table_name,
                  bt.entry_id   as base_type_id,
                  bt.entry_text as base_type_name
              from xap_class c,
                   xap_class_attribute a,
                   xap_data_type  dt,
                   xap_enumeration_entry  bt
            where c.name='$class_name'
              and a.class_id=c.xap_id
              and dt.xap_id=a.data_type
              and dt.base_type=bt.xap_id
             order by a.sort_id
             ";
             

            
             
         $r= mysql_query($stmt, $x->db);
         if (!$r)
         {
           
           $x->error_message= mysql_error()."<p>\n";
           
           echo $x->error_message;
         }
         else
         {
           $cnt= 0;
           #  $sep= " ";  if no other column was selected before
            $sep= ", ";
           while ($row= mysql_fetch_row($r))
           {
                $cnt++;
                $a_name[$cnt]= $row[0];
                $table_name= $row[1];
                $a_base_type_id[$cnt]= $row[2];
                $a_base_type_name[$cnt]= $row[3];
	     
             $sel_stmt .= $sep . $a_name[$cnt]  ;
             $sep= ", ";
           }
         }
        
         
         # add references here
      $stmt3=  " select c2.name, c2.table_name
           from xap_reference r,
                xap_class   c1,
                xap_class   c2
           where c1.name='$class_name' 
            and r.from_class_id=c1.xap_id
            and r.to_class_id=c2.xap_id
            order by r.sort_id";
         
         
         $sel_stmt .= " from $table_name ";
         
         
         
         
         if ($id>0) 
         {
           $sel_stmt .= " where xap_id=$id";
         }
         
   echo $sel_stmt."\n";
   
    
   echo "</pre>\n";
 
   
   
   
#if ($func eq "edit" || $func eq "delete" || $func eq "purge")
#{
#  get_data();
#}


if ($func == "create")
{
  entry_form("insert"); 
  $skipDisplay=1;
}
else
{
   
   #  if (isset($_GET["newitem"])&&($v->check_group('SysAdmin')||$v->check_group('MusicAdmin')))
   
   if ($func=="new")
   {
      echo "new ... <p>\n";
   }
   else
   {
   
   
   echo "<a href=\"$x->script?class=$class_name&func=create\">create</a><p>";
   
   
    
   if ($id==0)
   {
     # List display 
   $t= new XAP_Table();
   
   $t->table_tr();
   
    $t->header("xap_id");
    
    for ($i=1; $i<= $cnt; $i++)
    {
      $t->header($a_name[$i]." ".$a_base_type_id[$i]." ".$a_base_type_name[$i]);
    }
   $t->row_end();
   
  
     
          $r= mysql_query($sel_stmt, $x->db);
         if (!$r)
         {
           
           $x->error_message= mysql_error()."<p>\n";
           
           echo $x->error_message;
         }
         else
         {
          
           while ($row= mysql_fetch_row($r))
           {
             $t->row();
             
              $t->cell("<a href=\"xap_generic.php?class=$class_name&id=".$row[0]."\">".$row[0]."</a>");
             
              for ($i=0; $i< $cnt; $i++)
              {
              	 $value= $row[$i+$nSysCols];
              	 if ($a_base_type_id[$i+$nSysCols]==8) 
              	 {
              	 	  
              	    $r2= mysql_query("select entry_text from xap_enumeration_entry where xap_id=".$value, $x->db);
                    if (!$r2)
                    {
                      $x->error_message= mysql_error()."<p>\n";
           
                      echo $x->error_message;
                    }
                    else
                    { 
                      while ($row2= mysql_fetch_row($r2))
                      {
           	        $value= $row2[0];
                      }
                    }
              	 	 
              	 	 
              	 	 
              	 }
                 $t->cell($value);
              }
              $t->row_end();
           }
         }
  
    $t->table_end();
   
   
  # echo "</table>\n";
   }
   else
   {
   	   # form display
   	   
   	   
         $r= mysql_query($sel_stmt, $x->db);
         if (!$r)
         {
           
           $x->error_message= mysql_error()."<p>\n";
           
           echo $x->error_message;
         }
         else
         {
          
           while ($row= mysql_fetch_row($r))
           {
   	     $t= new XAP_Table();
   	     $t->table();
    for ($i=1; $i<= $cnt; $i++)
    {
      $t->row();
       
      $t->cell($a_name[$i]);
      $t->cell($row[$i-1+$nSysCols]); 
      $t->row_end();
    }
    
   
     $t->row_end();
     $t->table_end();
     	   }
   	   
   }
   
   }
   }
   
}
   
   $x->close_page();
  
 }

 
 
function entry_form($function)
{
	 global $id;
	 global $a_name;
	 global $cnt;
	 global $x;
	 global $class_name;
	 global $nSysCols;
	
	
	
	

  echo "<form method=\"post\" action=\"$x->script\">\n";
  
  echo "<input name=\"func\" type=\"hidden\" value=\"$function\">";
  echo "<input name=\"id\" type=\"hidden\" value=\"$id\">";
  echo "<input name=\"class\" type=\"hidden\" value=\"$class_name\">";

  $t= new XAP_Table();
  $t->table();
    for ($i=1; $i<= $cnt; $i++)
    {
      $t->row();
       
      $t->cell($a_name[$i]);
      $t->cell("<input name=\"$a_name[$i]\" type=\"text\" id=\"$a_name[$i]\" size=\"20\" maxlength=\"20\" value=\"no nix\" >"); 
      $t->row_end();
    }
    
    $t->row();
    $t->cell("<input  type=\"submit\" id=\"ok\"     name=\"submit\" value=\""."save"."\">\n");
    $t->cell( "      <input  type=\"submit\" id=\"cancel\" name=\"submit\"  value=\""."cancel"."\">\n");
     $t->row_end();
     $t->table_end();
	
  
	echo " </form>\n";
	
}

?>




