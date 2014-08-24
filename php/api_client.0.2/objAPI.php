<?php

    class objAPI {
        
        var $user;
        var $secret;
        var $token;
        
        function objAPI() {
            $this->user=  "USER_KEY_GOES_HERE";
            $this->secret="USER_SECRET_GOES_HERE";
        }
        
        function loadToken() {
            $this->token=null;
            
            $headers=array(
                "Accept: application/json",
                "Authorization: Basic " . base64_encode($this->user.":".$this->secret)
            );

            $c=curl_init();
            curl_setopt($c,CURLOPT_HTTPHEADER,$headers);
            curl_setopt($c,CURLOPT_URL,"https://api.fetcheveryone.com/token.php");
            curl_setopt($c,CURLOPT_FOLLOWLOCATION, TRUE);
            curl_setopt($c,CURLOPT_RETURNTRANSFER,true);
            $result=curl_exec($c);

            if ($result) {
                $decoded=json_decode($result);
                if (($decoded) && (isset($decoded->access_token))) {
                    $this->token=$decoded;
                }
            }
            curl_close($c);
            return true;
        }
        
	function getResource($resource) {
            $headers=array(
                'Authorization: Bearer '.$this->token->access_token,
                'Accept: application/json'
            );
            $c=curl_init();
            curl_setopt($c,CURLOPT_HTTPHEADER,$headers);
            curl_setopt($c,CURLOPT_URL,"https://api.fetcheveryone.com/api.php?"."$resource");
            curl_setopt($c,CURLOPT_FOLLOWLOCATION, TRUE);
            curl_setopt($c,CURLOPT_RETURNTRANSFER,true);
            curl_setopt($c,CURLOPT_HEADER,false);
            curl_setopt($c,CURLOPT_POST,false);
            $result=curl_exec($c);
            return json_decode($result,TRUE);
	}

	function putResource($resource,$params) {
            $headers=array(
                'Authorization: Bearer '.$this->token->access_token,
                'Accept: application/json'
            );
            $c=curl_init();
            curl_setopt($c,CURLOPT_HTTPHEADER,$headers);
            curl_setopt($c,CURLOPT_URL,"https://api.fetcheveryone.com/api.php?"."$resource");
            curl_setopt($c,CURLOPT_FOLLOWLOCATION, TRUE);
            curl_setopt($c,CURLOPT_POST,true);
            curl_setopt($c,CURLOPT_POSTFIELDS, http_build_query($params));
            $result=curl_exec($c);
            return json_decode($result,TRUE);
	}
        
    }
?>