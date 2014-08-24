<?php
    include_once("objAPI.php");
    $objAPI = new objAPI();
    $objAPI->loadToken();
    
    $tcx_data = urlencode(gzcompress(file_get_contents("example.tcx")));
    $result = $objAPI->putResource("request=training/import",array("uid"=>3,"method"=>"TCX","category"=>"R","data"=>$tcx_data));
    print_r($result);

?>
