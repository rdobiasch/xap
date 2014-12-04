<?
 
  class XAP
  {
    var $db;
   
    var $error_message;
    
 
    var $user;
    var $user_id;
    
    function XAP()
    {
       $this->connect_db();
     
       $this->error_message= "";
    }
    
    function connect_db()
    {
       $this->db= mysql_connect("localhost", "root", "c0librI"); 
    
       if ($this->db)
      {
      
        if (!mysql_select_db("xap", $this->db))
        {
          $this->db= null;
        }
      }
      
      $_SESSION["db"]= $this->db;
    }

    
    
    function login()
    {
      if (isset($_POST['login'])) 
      { 
        $name    =  $_POST['username'];
        $password=  $_POST['userpass'];
        
        if ($this->login_ok($name, $password))
        { 
          $_SESSION["logged_in"]=1;
          $_SESSION["user_name"]=$name;
          $_SESSION["user_id"]=
             $this->select_single_val("select xap_id from xap_user where name='$name'");
               
        }  
        else
        {
          $_SESSION["logged_in"]=0;
          $_SESSION["user_name"]="";;
        }
      }
      
      if (!isset($_SESSION["logged_in"]))
      {
        $_SESSION["logged_in"]=0;
      }
    }
    
    function login_ok($name, $password)
    {  
       $this->error_message="";
         
       if ($this->db)
       {
         $stmt = "select u.password, md5('".$password."') from xap_user u where u.name='".$name."' ";
	# echo $stmt;
         $r= mysql_query($stmt, $this->db);
         if (!$r)
         {
           $this->error_message= mysql_error()."<p>\n";
         }
         else
         {
           $cnt= 0;
           while ($row= mysql_fetch_row($r))
           {
                $cnt++;
                $pwd= $row[0];
	            	$m5pwd= $row[1];
              #  $locked= $row[1];
           }
           if ($cnt==1)
           { 
             #if (crypt($password, substr($pwd, 0, 2))==$pwd)
	     if ($pwd==$m5pwd)
             {
             #  if ($locked!='y')
             #  {
                  $this->error_message="login successful";
                  return(true);
             #  }
             #  else
             #  {
             #    $this->error_message="sorry, the account is locked";
             #    return(false);
             #  }
             }
             else
             {
               $this->error_message="wrong password";
             }
           }
           else
           {
             $this->error_message="user not found";
           }
           return(false);  
         }
       }
       else
       {
         $this->error_message="could not connect to database server<p>\n";
       }
       return(false);
     }
     
     
     function login_dialog()
     {
       
        echo "<div align=\"center\" valign=\"center\">\n";
            
        echo  "  <table height=\"100%\">\n";
        echo "   <tr>\n";
        echo "   <td valign=\"center\">\n";
        echo "   <form method=\"post\" action=\"".$this->script."\">\n"; 
        echo "   <table>\n";
        echo "      <tr>\n";
        echo "       <td><label>user:</label></td>\n";
        echo "       <td><input name=\"username\" type=\"text\"></td>\n";
        echo "      </tr>\n";
        echo "      <tr>\n";
        echo "        <td><label>password: </label></td>\n";
        echo "        <td><input name=\"userpass\" type=\"password\" id=\"userpass\"></td>\n";
        echo "        </tr>\n";
        echo "        <tr>\n";
        echo "       <td colspan=\"2\" align= \"center\">\n";
        echo "         <input name=\"login\" type=\"submit\" id=\"login\" value=\"login\"></td>\n";
        echo "       </tr>\n";
        echo "       </table>\n";
        echo "    </form>\n";
        echo "    </td>\n";
        echo "    </tr>\n";
        echo "    </table>\n";
     }

     function logout()
     {
       $_SESSION["logged_in"]=0;
       $_SESSION["user_name"]=0;
       $_SESSION["user_id"]=0;
     }
 
     
    function start_page($title)
    {
      
      session_start();
      $this->login();  // login if login_data was posted
        
      if ($_SESSION["logged_in"])
      {
        $this->user= $_SESSION["user_name"];
        $this->user_id=$_SESSION["user_id"];
             
        echo "<html>\n";
        echo " <head>\n";
        echo "   <title>$title</title>\n";
        
  #      menu_style_sheets($this->db, $this->site, $menu_bar, $this->user);
  #      menu_scripts($this->db, $this->site, $menu_bar, $this->user);

        echo " </head>\n";
       
        echo "<body topMargin=0 leftmargin=\"0\" marginwidth=\"10\" marginheight=\"0\">\n";
     
	
	
 #       menus($this->db, $this->site, $menu_bar, $this->user);
        
 

    
?>
 
<table cellspacing=0 cellPadding=0 width="100%" border="0" >
  <tr>
    <td>
    
    <?php 
    #  menu_bar($this->db, $this->site, $menu_bar, $this->user);
      
      ?>
  
     
  </tr>
  <tr onmouseover="hideAll();">
    <td>
         &nbsp;<p>
    
        <?php
	
	
#	$this->log_access(1);

  echo "<table width=\"100%\">";
       echo "<tr><td width=\"20\">&nbsp;</td><td><font face=\"arial\">\n";
    
	
        return(1);
      }
      else
      {
        echo "<html>\n";
        echo " <head>\n";
        echo "   <title>no access</title>\n";
        echo " </head>\n";
        echo " <body>\n";
        
        $this->login_dialog();
        /* echo "Sorry, this area is restricted to members only."; */
        return(0);
       
      }
  
        
    }
    
    
    function close_page()
    {
       echo "</font></td></tr><table>\n";
       
       echo $this->error_message;
       
       if ($_SESSION["logged_in"])
       {
         echo " </td>\n";
         echo " </tr>\n";
         echo " </table>\n";
       }
       echo " </body>\n";
       echo "</html>\n";
     /*
       if (isset($_SESSION["db"]))
       {
         mysql_close($_SESSION["db"]);
       }
       */
       mysql_close($this->db);
 
    }
    
    
    
    
         
    function query($q)
    {
      $r= mysql_query($q, $this->db);
      if (!$r)
      {
        print "error at sql statement:<p>\n<pre>\n$q\n</pre>\n<p>\n";
        print "<pre>".mysql_error()."</pre><p>";
        return(null);
      }
      return($r);
    }
  
    function select_single_val($q)
    { 
      $r= $this->query($q);
      
      if (!$r)
      {
        return(null);
      }
      else
      {
         $a=mysql_fetch_row($r);
         return($a[0]);
      }
    }
    
    # get html parameter from  get  or from post
    function get_param($name, $default)
    {
    	$v= $default;
    	
        if (isset($_GET[$name])) 
        {
            $v= $_GET[$name];
        } 
 	else
 	{
 	   if (isset($_POST[$name])) 
 	   { 
 	      $v= $_POST[$name]; 
 	   }
 	   else
 	   {
 	      $v= $default;
 	   }
 	}
       return($v);
    }
     
  }
?>
