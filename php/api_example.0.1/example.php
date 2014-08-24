<?php
    include_once("objAPI.php");
    
    $objAPI = new objAPI();
    
    $objAPI->loadToken();
    
    $result = $objAPI->getResource("request=forum/threads");
    //$result = $objAPI->getResource("request=forum/threads&category=friday");
    //$result = $objAPI->getResource("request=forum/threads&category=friday&items=20&start=20");
    //$result = $objAPI->getResource("request=forum/threads");
    
    
    print_r($result);

?>
