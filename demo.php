<?php

# just a new comment line

  include "vp.php";
  include "xap.php";
 
  class VP_INTERNAL
  {
    var $db;
    var $x;
    var $title;
    var $script;
    var $site;
    var $errstr;
    
    function VP_INTERNAL($title, $script)
    {
      $this->site="ViennaPipeBand";
      $this->title= $title;
      $this->script= $script;
      $this->errstr="";
      $this->db= connect_db();
      
      $cmd="select id from xam_sites where name='".$this->site."'";
      $r= mysql_query($cmd, $this->db);
      if (!$r)
      {
        echo $cmd."<p>\n";
        echo mysql_error()."<p>\n";
      }
      else
      {
        $a= mysql_fetch_row($r);
        $this->site_id=$a[0];
      }
      $this->x= new XAM($this->db, $this->script, "ViennaPipeBand");
    }
    
    function start_page()
    {
      
       $r= $this->x->start_application_page($this->title, "pipeband");
       echo "<table width=\"100%\">";
       echo "<tr><td width=\"20\">&nbsp;</td><td><font face=\"arial\">\n";
       
       return($r);
    }
    
    
    function close_page()
    {
      echo "</font></td></tr><table>\n";
      $this->x->close_application_page();
    }
    
    function query($q)
    {
      return($this->x->query($q));
    }
    
    function select_single_val($q)
    {
      return($this->x->select_single_val($q));
    }
    
    function h1($header)
    {
      echo "<div align=\"center\">\n";
      echo "<h1>$header</h1>\n";
      echo "</div>\n";
    }
    
    function check_group($group)
    {
        return($this->x->check_group($group));
    }
  
    function get_pgroup_access($group_id)
    {
      return($this->x->get_pgroup_access($group_id));
    }
    
    function edit_person_dialog($id)
    {
      $this->x->edit_person_dialog($id, $this->script);
    }
    
    function create_person_dialog($groupid)
    {
      $this->x->create_person_dialog($this->script, $groupid);
    }
    
    function edit_person()
    {
      $this->x->edit_person();
    }
    
    function create_person()
    {
        $this->x->create_person();
    }
    
     
      
  
     function logout()
     {
       $_SESSION["logged_in_".$this->site]=0;
       $_SESSION["user_".$this->site]=0;
     }
   
   
  function question($q, $yes, $no)
  {
        echo "&nbsp;<p>\n";
        echo "<div align=\"center\">\n";
        echo "<table cellpadding=10 border=10>\n";
        echo "<tr><td colspan=\"2\" bgcolor=#5555ff>\n";
        echo "&nbsp;$q;&nbsp;";
        echo "</td></tr><tr>\n";
        echo "<td bgcolor=#ff0000 align=center><a href=\"$yes\">yes</a></td>\n";
        echo "<td bgcolor=#00ff00 align=center><a href=\"$no\">no</a></td>\n";
        echo "</tr></table></div>\n";
   
    
 }
 
   function db_clean_str($s)
   {
     return($this->x->db_clean_str($s));
   }
 
  }       
 
?>
